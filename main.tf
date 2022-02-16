# Local vars
locals {

  aws_subnets = {
    for subnet in var.subnets :
    try("${subnet.name}/${subnet.cidr}/${subnet.zone}") => subnet
    if !contains(keys(subnet), "flag")
  }

  alkira_subnets = {
    for subnet in var.subnets :
    try("${subnet.name}/${subnet.cidr}/${subnet.zone}/${subnet.flag}") => subnet
    if contains(keys(subnet), "flag")
  }

  # If list is not empty, set to true
  is_custom = length(var.custom_prefixes) > 0 ? true : false

  # Filter tag IDs
  tag_id_list = [
    for v in data.alkira_billing_tag.tag : v.id
  ]

}

/*
AWS data sources
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
*/

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "alkira_credential" "credential" {
  name = var.credential
}

/*
Alkira data sources
https://registry.terraform.io/providers/alkiranet/alkira/latest/docs
*/

data "alkira_segment" "segment" {
  name = var.segment
}

data "alkira_group" "group" {
  name = var.group
}

data "alkira_billing_tag" "tag" {
  for_each = toset(var.billing_tags)
  name     = each.key
}

data "alkira_policy_prefix_list" "prefix" {

  # Count values
  count = length(var.custom_prefixes)

  # Index each prefix-list ID
  name = element(tolist(var.custom_prefixes), count.index)

}

# Create AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  tags       = merge({ "Name" = var.name }, var.aws_network_tags)

}

# Create AWS subnets
resource "aws_subnet" "aws_subnet" {
  for_each          = local.aws_subnets
  vpc_id            = one(aws_vpc.vpc[*].id)
  cidr_block        = each.value.cidr
  availability_zone = each.value.zone
  tags              = merge({ "Name" = each.value.name }, var.aws_subnet_tags)

  depends_on = [aws_vpc.vpc]

}

# Create AWS subnets that get onboarded to Alkira
resource "aws_subnet" "alkira_subnet" {
  for_each          = local.alkira_subnets
  vpc_id            = one(aws_vpc.vpc[*].id)
  cidr_block        = each.value.cidr
  availability_zone = each.value.zone
  tags              = merge({ "Name" = each.value.name, "Flag" = each.value.flag }, var.aws_subnet_tags)

  depends_on = [aws_vpc.vpc]

}

# Connect AWS VPC or subnet(s) through Alkira CXP
resource "alkira_connector_aws_vpc" "aws_vpc" {

  # AWS values
  name           = var.name
  vpc_id         = one(aws_vpc.vpc[*].id)
  vpc_cidr       = var.onboard_subnet ? null : [one(aws_vpc.vpc[*].cidr_block)]
  aws_region     = data.aws_region.current.name
  aws_account_id = coalesce(var.account_id, data.aws_caller_identity.current.account_id)

  # Connector values
  enabled                        = var.enabled
  cxp                            = var.cxp
  size                           = var.size
  group                          = data.alkira_group.group.name
  segment_id                     = data.alkira_segment.segment.id
  billing_tag_ids                = local.tag_id_list
  credential_id                  = data.alkira_credential.credential.id
  direct_inter_vpc_communication = var.direct_inter_vpc

  # If onboarding specific subnets
  dynamic "vpc_subnet" {
    for_each = {
      for subnet in aws_subnet.alkira_subnet : subnet.id => subnet
      if var.onboard_subnet == true
    }

    content {
      id   = vpc_subnet.value.id
      cidr = vpc_subnet.value.cidr_block
    }
  }

  /*
  Does custom bool exist?
  If yes, advertise custom prefix and pass through list
  If not, use default route and set option to route custom to null
  */
  dynamic "vpc_route_table" {
    for_each = {
      for prefix in data.alkira_policy_prefix_list.prefix : prefix.id => prefix
      if local.is_custom == true
    }

    content {
      id              = one(aws_vpc.vpc[*].default_route_table_id)
      options         = local.is_custom ? "ADVERTISE_CUSTOM_PREFIX" : "ADVERTISE_DEFAULT_ROUTE"
      prefix_list_ids = try([vpc_route_table.value.id])
    }
  }


  depends_on = [
    aws_vpc.vpc,
    aws_subnet.aws_subnet,
    aws_subnet.alkira_subnet,
  ]

}

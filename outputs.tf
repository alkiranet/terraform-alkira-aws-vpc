output "name" {
  description = "Network name"
  value       = var.name
}

output "vpc_id" {
  description = "AWS VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "AWS VPC cidr"
  value       = aws_vpc.vpc.cidr_block
}

output "rtb_id" {
  description = "AWS route table id"
  value       = aws_vpc.vpc.default_route_table_id
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "subnet" {
  description = "AWS subnet configuration"
  value = [
    for subnet in aws_subnet.aws_subnet : {
      id   = subnet.id
      name = subnet.tags.Name
      cidr = subnet.cidr_block
    }
  ]
}

output "subnet_onboarded" {
  description = "AWS subnets onboarded to Alkira"
  value = [
    for subnet in aws_subnet.alkira_subnet : {
      id   = subnet.id
      name = subnet.tags.Name
      cidr = subnet.cidr_block
    }
  ]
}

output "connector_id" {
  description = "Alkira connector id"
  value       = alkira_connector_aws_vpc.aws_vpc.id
}

output "cxp" {
  description = "Alkira connector CXP"
  value       = alkira_connector_aws_vpc.aws_vpc.cxp
}

output "size" {
  description = "Alkira connector size"
  value       = alkira_connector_aws_vpc.aws_vpc.size
}

output "segment_id" {
  description = "Alkira connector segment id"
  value       = alkira_connector_aws_vpc.aws_vpc.segment_id
}

output "vpc_subnet" {
  description = "Alkira subnet onboarded to CXP"
  value       = try(alkira_connector_aws_vpc.aws_vpc.vpc_subnet)
}

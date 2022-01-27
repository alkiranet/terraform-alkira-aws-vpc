output "aws_vpc" {
  description = "AWS VPC configuration"

  value = [
    for vpc in aws_vpc.vpc : {
      vpc_name   = vpc.tags["Name"]
      vpc_id     = vpc.id
      vpc_cidr   = vpc.cidr_block
      rtb_id     = vpc.default_route_table_id
      vpc_region = data.aws_region.current.name
    }
  ]

}

output "aws_subnet" {
  description = "AWS subnet configuration"

  value = [
    for subnet in merge(aws_subnet.aws_subnet, aws_subnet.alkira_subnet) : {
      subnet_name = subnet.tags["Name"]
      subnet_id   = subnet.id
      subnet_cidr = subnet.cidr_block
    }
  ]

}

output "aws_connector" {
  description = "Alkira connector configuration"

  value = [
    for connector in alkira_connector_aws_vpc.aws_vpc : {
      name            = connector.name
      id              = connector.id
      cxp             = connector.cxp
      size            = connector.size
      group           = connector.group
      segment_id      = connector.segment_id
      vpc_route_table = connector.vpc_route_table
      vpc_subnet      = try(connector.vpc_subnet)
    }
  ]

}

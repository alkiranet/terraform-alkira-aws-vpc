module "aws_vpc" {
  source = "alkiranet/aws-vpc/alkira"

  onboard_subnet = true

  name    = "vpc-east"
  cidr    = "10.1.0.0/16"

  subnets = [
    {
      name = "app-subnet-a"
      cidr = "10.1.1.0/24"
      zone = "us-east-2a"
    },
    {
      name = "app-subnet-b"
      cidr = "10.1.2.0/24"
      zone = "us-east-2b"
      flag = "alkira"
    }
  ]

  cxp          = "US-EAST-2"
  segment      = "corporate"
  group        = "non-prod"
  billing_tags = ["cloud", "network"]
  credential   = "aws-auth"

}
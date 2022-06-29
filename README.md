# Alkira AWS Connector - Terraform Module
This module makes it easy to provision an [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and connect it through [Alkira](htts://alkira.com).

## What it does
- Build a [VPC](https://aws.amazon.com/vpc/) and one or more [Subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
- Create an [Alkira Connector](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_aws_vpc) for the new VPC
- Apply [Billing Tags](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/billing_tag) to the connector
- Place resources in an existing [Segment](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) and [Group](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/group)
- Provide optional capabilities for customized routing

### Basic Usage
```hcl
module "aws_vpc" {
  source = "alkiranet/aws-vpc/alkira"

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
    }
  ]

  cxp          = "US-EAST-2"
  segment      = "corporate"
  group        = "non-prod"
  billing_tags = ["cloud", "network"]
  credential   = "aws-auth"

}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_alkira"></a> [alkira](#requirement\_alkira) | >= 0.8.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alkira"></a> [alkira](#provider\_alkira) | >= 0.8.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.63 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alkira_connector_aws_vpc.aws_vpc](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_aws_vpc) | resource |
| [aws_subnet.alkira_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [alkira_billing_tag.tag](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/billing_tag) | data source |
| [alkira_credential.credential](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/credential) | data source |
| [alkira_group.group](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/group) | data source |
| [alkira_policy_prefix_list.prefix](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/policy_prefix_list) | data source |
| [alkira_segment.segment](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID that owns or contains calling entity | `string` | `""` | no |
| <a name="input_aws_network_tags"></a> [aws\_network\_tags](#input\_aws\_network\_tags) | AWS VPC tags | `map(string)` | `{}` | no |
| <a name="input_aws_subnet_tags"></a> [aws\_subnet\_tags](#input\_aws\_subnet\_tags) | AWS Subnet tags | `map(string)` | `{}` | no |
| <a name="input_billing_tags"></a> [billing\_tags](#input\_billing\_tags) | List of billing tag names to apply to connector | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Address space of cloud network | `string` | `""` | no |
| <a name="input_credential"></a> [credential](#input\_credential) | Alkira cloud credential | `string` | n/a | yes |
| <a name="input_custom_prefixes"></a> [custom\_prefixes](#input\_custom\_prefixes) | Controls if custom prefixes are used for routing from cloud network to CXP; If values are provided, local var 'is\_custom' changes to 'true' | `list(string)` | `[]` | no |
| <a name="input_cxp"></a> [cxp](#input\_cxp) | Alkira CXP to create connector in | `string` | n/a | yes |
| <a name="input_direct_inter_vpc"></a> [direct\_inter\_vpc](#input\_direct\_inter\_vpc) | Enable direct inter-vpc communication | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Status of connector; Default is true | `bool` | `true` | no |
| <a name="input_group"></a> [group](#input\_group) | Alkira group to add connector to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of cloud network and Alkira connector | `string` | `""` | no |
| <a name="input_onboard_subnet"></a> [onboard\_subnet](#input\_onboard\_subnet) | Controls if subnet gets onboarded in lieu of entire cloud network | `bool` | `false` | no |
| <a name="input_segment"></a> [segment](#input\_segment) | Alkira segment to add connector to | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Alkira connector size | `string` | `"SMALL"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create for cloud network | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region |
| <a name="output_connector_id"></a> [connector\_id](#output\_connector\_id) | Alkira connector id |
| <a name="output_cxp"></a> [cxp](#output\_cxp) | Alkira connector CXP |
| <a name="output_name"></a> [name](#output\_name) | Network name |
| <a name="output_rtb_id"></a> [rtb\_id](#output\_rtb\_id) | AWS route table id |
| <a name="output_segment_id"></a> [segment\_id](#output\_segment\_id) | Alkira connector segment id |
| <a name="output_size"></a> [size](#output\_size) | Alkira connector size |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | AWS subnet configuration |
| <a name="output_subnet_onboarded"></a> [subnet\_onboarded](#output\_subnet\_onboarded) | AWS subnets onboarded to Alkira |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | AWS VPC cidr |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | AWS VPC ID |
| <a name="output_vpc_subnet"></a> [vpc\_subnet](#output\_vpc\_subnet) | Alkira subnet onboarded to CXP |
<!-- END_TF_DOCS -->
# Alkira AWS Connector - Terraform Module
This module makes it easy to provision an [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and connect it through [Alkira](htts://alkira.com).

## What it does
- Build a [VPC](https://aws.amazon.com/vpc/) and one or more [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
- Create an [Alkira Connector](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_aws_vpc) for the new VPC
- Apply an existing [Billing Tag](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/billing_tag) to the connector
- Place resources in an existing [segment](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) and [group](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/group)

## Example Usage
Alkira offers enhanced capabilities for how traffic gets routed to and from _Cloud Exchange Points (CXPs)_.

### Onboard entire VPC CIDR
To onboard the entire VPC CIDR:

```hcl
module "aws-vpc" {
  source = "alkiranet/aws-vpc/alkira"

  network_name = "vpc-aws-east"
  network_cidr = "10.1.0.0/16"
  subnets = [
    {
      name = "subnet-01"
      cidr = "10.1.1.0/24"
      zone = "us-east-2a"
    },
    {
      name = "subnet-02"
      cidr = "10.1.2.0/24"
      zone = "us-east-2b"
    }
  ]

  cxp          = "US-EAST-2"
  segment      = "corporate"
  group        = "nonprod"
  billing_tags = ["cloud", "network"]
  credential   = "aws-auth"

}
```

### Onboard specific subnets
You may also wish to onboard specific subnets. To do this, simply switch the onboarding option at the top of the configuration to **onboard_subnet = true** and add an extra **flag** key with **value** _alkira_ to the subnets you wish to onboard. You can do this with additional subnets as needed:

```hcl
module "aws-subnet" {
  source = "alkiranet/aws-vpc/alkira"

  onboard_subnet = true # Trigger specific subnets to be onboarded

  network_name = "vpc-aws-east"
  network_cidr = "10.1.0.0/16"
  subnets = [
    {
      name = "subnet-01"
      cidr = "10.1.1.0/24"
      zone = "us-east-2a"
    },
    {
      name = "subnet-02"
      cidr = "10.1.2.0/24"
      zone = "us-east-2b"
      flag = "alkira" # This subnet will be onboarded in lieu of the entire VPC CIDR
    }
  ]

  cxp          = "US-EAST-2"
  segment      = "corporate"
  group        = "nonprod"
  billing_tags = ["cloud", "network"]
  credential   = "aws-auth"

}
```

### Custom Routing
By default, Alkira will override the existing default route and route the traffic to the _CXP_. As an alternative, you can provide a list of prefixes for which traffic must be routed. This can be done by adding the option **custom_prefixes = []** to the configuration.

```hcl
module "aws-vpc-custom" {
  source = "alkiranet/aws-vpc/alkira"

  custom_prefixes = ["pfx-01", "pfx-02"] # Must exist in Alkira

  network_name = "vpc-aws-east"
  network_cidr = "10.1.0.0/16"
  subnets = [
    {
      name = "subnet-01"
      cidr = "10.1.1.0/24"
      zone = "us-east-2a"
    },
    {
      name = "subnet-02"
      cidr = "10.1.2.0/24"
      zone = "us-east-2b"
    }
  ]

  cxp          = "US-EAST-2"
  segment      = "corporate"
  group        = "nonprod"
  billing_tags = ["cloud", "network"]
  credential   = "aws-auth"

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_alkira"></a> [alkira](#requirement\_alkira) | >= 0.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alkira"></a> [alkira](#provider\_alkira) | >= 0.8.0 |
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
| <a name="input_group"></a> [group](#input\_group) | Alkira group to add connector to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of cloud network and Alkira connector | `string` | `""` | no |
| <a name="input_onboard_subnet"></a> [onboard\_subnet](#input\_onboard\_subnet) | Controls if subnet gets onboarded in lieu of entire cloud network | `bool` | `false` | no |
| <a name="input_segment"></a> [segment](#input\_segment) | Alkira segment to add connector to | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Alkira connector size | `string` | `"SMALL"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create for cloud network | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_connector"></a> [aws\_connector](#output\_aws\_connector) | Alkira connector configuration |
| <a name="output_aws_subnet"></a> [aws\_subnet](#output\_aws\_subnet) | AWS subnet configuration |
| <a name="output_aws_vpc"></a> [aws\_vpc](#output\_aws\_vpc) | AWS VPC configuration |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

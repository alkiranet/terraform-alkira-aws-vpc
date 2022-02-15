variable "account_id" {
  description = "AWS account ID that owns or contains calling entity"
  type        = string
  default     = ""
  sensitive   = true
}

variable "onboard_subnet" {
  description = "Controls if subnet gets onboarded in lieu of entire cloud network"
  type        = bool
  default     = false
}

variable "custom_prefixes" {
  description = "Controls if custom prefixes are used for routing from cloud network to CXP; If values are provided, local var 'is_custom' changes to 'true'"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name of cloud network and Alkira connector"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "Address space of cloud network"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "Subnets to create for cloud network"
  type        = list(map(string))
}

variable "aws_network_tags" {
  description = "AWS VPC tags"
  type        = map(string)
  default     = {}
}

variable "aws_subnet_tags" {
  description = "AWS Subnet tags"
  type        = map(string)
  default     = {}
}

variable "billing_tags" {
  description = "List of billing tag names to apply to connector"
  type        = list(string)
  default     = []
}

variable "credential" {
  description = "Alkira cloud credential"
  type        = string
}

variable "segment" {
  description = "Alkira segment to add connector to"
  type        = string
}

variable "group" {
  description = "Alkira group to add connector to"
  type        = string
}

variable "cxp" {
  description = "Alkira CXP to create connector in"
  type        = string
}

variable "size" {
  description = "Alkira connector size"
  type        = string
  default     = "SMALL"
}

terraform {
  required_version = ">= 0.13.1"

  required_providers {

    alkira = {
      source  = "alkiranet/alkira"
      version = ">= 0.8.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }

  }
}
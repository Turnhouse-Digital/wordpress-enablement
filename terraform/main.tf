terraform {
  backend "s3" {
    bucket         = "wordpress-enablement-terraform-state-bucket"
    key            = "erraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "external" {

}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
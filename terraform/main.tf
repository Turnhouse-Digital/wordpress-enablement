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
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

locals {
  turnhousedigital_domain = "turnhousedigital.co.uk"
  turnhousemarketing_domain = "turnhousemarketing.co.uk"
}
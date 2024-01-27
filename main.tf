terraform {
  backend "s3" {
    bucket         = "wordpress-enablement-terraform-state-bucket"
    key            = "erraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2"
}
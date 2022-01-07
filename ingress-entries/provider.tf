
provider "aws" {
  region = var.region
}

# Configure the Terraform backend for remote state
terraform {
  required_version = ">= 1.0.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.15"
    }
  }

  backend "s3" {
     bucket = "cmacmg-test-tfstates"
     key    = "ingress-entries/terraform.tfstate"
     region = "eu-west-3"

     #dynamodb_table = "acme.com-test-locks"
     #encrypt        = true
   }
}

terraform {
  #   required_version = ">= 0.12"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

}

# Configure the AWS provier
provider "aws" {
  region  = "us-east-1"
  profile = "Learning"
}

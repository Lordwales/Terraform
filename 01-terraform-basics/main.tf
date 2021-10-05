terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # VERSION IS NOT NEEDED HERE
}

#PLAN

# Object you want to manage in the cloud. first value in qoute is the resource to be managed. second qoute is 
# a refrenced name inside this configuration file.

resource "aws_s3_bucket" "my_bucket" {
  bucket = "lordwales-bucket"  # bucket name on S3
}

#Use ~ terraform plan and terraform apply to execute the file 
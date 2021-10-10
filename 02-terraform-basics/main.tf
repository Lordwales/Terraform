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

#Creating multible IAM Users
resource "aws_iam_user" "my_users" {
  count = 2
  name = "my_terraform_user_${count.index}"
  
}

#Use ~ terraform plan and terraform apply to execute the file 
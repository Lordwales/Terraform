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

resource "aws_default_vpc" "default" {

}

//HTTP Server -> Security Group

//Security Group -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {

  name   = "http_server_sg"
  //vpc_id = "vpc-0aa3b1de2c3ee99a5"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id] 
  subnet_id              = tolist(data.aws_subnet_ids.default_subnets.ids)[0]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y", //install httpd
      "sudo service httpd start",  //start
      "echo Welcome to your new EC2 instance created by Terraform. Server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}
#Use ~ terraform plan and terraform apply to execute the file 
provider "aws" {
  region     = "us-east-1"
#  access_key = ""
#  secret_key = ""
#  token = ""
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo-VPC"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAUBWSDX2ITI3TFAZ7"
  secret_key = "I6gBoB3bR/eKa/u2i8GIpcz0CY4/sdTcRM2WRJzX"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo-VPC"
  }
}

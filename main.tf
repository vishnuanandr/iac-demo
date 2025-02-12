provider "aws" {
  region     = "us-east-1"
  access_key = "AKIATTSKFQ53IVCVDH4U"
  secret_key = "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"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo-VPC"
  }
}

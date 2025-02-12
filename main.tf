# 1. Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name   = "MyVPC"
    Source = var.sources
  }
}

# 2. Create a Subnet inside the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name   = "MySubnet"
    Source = var.sources
  }
}

# 3. Create an Internet Gateway for Public Access
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name   = "MyIGW"
    Source = var.sources
  }
}

# 4. Create a Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name   = "MyRouteTable"
    Source = var.sources
  }
}

# 5. Associate the Route Table with the Subnet
resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# 6. Create a Security Group (Allow SSH)
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (change for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere (change for security)
  }

  tags = {
    Name   = "MySecurityGroup"
    Source = var.sources
  }
}

# 7. Create two EC2 Instance inside the VPC
resource "aws_instance" "my_instance" {
  ami             = "ami-0c614dee691cbbf37" # Change this AMI ID based on your region
  instance_type   = "t2.2xlarge"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name   = "MyEC2Instance1"
    Source = var.sources
  }
}

resource "aws_instance" "my_instance1" {
  ami             = "ami-0c614dee691cbbf37" # Change this AMI ID based on your region
  instance_type   = "t2.2xlarge"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name   = "MyEC2Instance2"
    Source = var.sources
  }
}

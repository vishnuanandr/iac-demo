# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name   = "MyVPC"
    Source = var.sources
  }
}

# Create Two Subnets in Different Availability Zones (Required for ALB)
resource "aws_subnet" "my_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"  # Change to your region's AZ

  tags = {
    Name   = "MySubnet1"
    Source = var.sources
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"  # Change to another AZ

  tags = {
    Name   = "MySubnet2"
    Source = var.sources
  }
}

# Create an Internet Gateway for Public Access
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name   = "MyIGW"
    Source = var.sources
  }
}

# Create a Route Table
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

# Associate Route Table with Subnets
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.my_subnet2.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic (if needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name   = "ALBSecurityGroup"
    Source = var.sources
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (for testing, change for security)
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Allow traffic from ALB only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "EC2SecurityGroup"
    Source = var.sources
  }
}

# Create EC2 Instances
resource "aws_instance" "my_instance1" {
  ami                  = "ami-0c614dee691cbbf37"  # Change based on your region
  instance_type        = "t2.2xlarge"
  subnet_id            = aws_subnet.my_subnet1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd.x86_64
              sudo systemctl start httpd.service
              sudo systemctl enable httpd.service
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              EOF

  tags = {
    Name   = "MyEC2Instance1"
    Source = var.sources
  }
}

resource "aws_instance" "my_instance2" {
  ami                  = "ami-0c614dee691cbbf37"
  instance_type        = "t2.2xlarge"
  subnet_id            = aws_subnet.my_subnet2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd.x86_64
              sudo systemctl start httpd.service
              sudo systemctl enable httpd.service
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              EOF

  tags = {
    Name   = "MyEC2Instance2"
    Source = var.sources
  }
}


# Create an Application Load Balancer (ALB)
resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.my_subnet1.id, aws_subnet.my_subnet2.id]  # ALB needs two subnets

  tags = {
    Name   = "MyALB"
    Source = var.sources
  }
}

# Create a Target Group for the ALB
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name   = "MyTargetGroup"
    Source = var.sources
  }
}

# Register EC2 Instances to the Target Group
resource "aws_lb_target_group_attachment" "instance1" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_instance2.id
  port             = 80
}

# Create an ALB Listener (Forward HTTP Requests to Target Group)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

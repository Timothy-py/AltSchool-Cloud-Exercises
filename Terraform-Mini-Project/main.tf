# CREATE A VPC RESOURCE
resource "aws_vpc" "altschool" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "altschool-vpc"
  }
}

# USE DATA SOURCE TO GET ALL AVAILABILIT ZONES IN A REGION
data "aws_availability_zones" "AZ" {}

# CREATE A PUBLIC SUBNET RESOURCE
resource "aws_subnet" "altschool" {
  count = length(data.aws_availability_zones.AZ.names)

  vpc_id                  = aws_vpc.altschool.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.AZ.names[count.index]

  tags = {
    Name = "altschool-public"
  }
}

# CREATE AN INTERNET GATEWAY RESOUCE
resource "aws_internet_gateway" "altschool" {
  vpc_id = aws_vpc.altschool.id

  tags = {
    Name = "altschool-igw"
  }
}

# CREATE AWS ROUTE TABLE
resource "aws_route_table" "altschool" {
  vpc_id = aws_vpc.altschool.id

  tags = {
    Name = "altschool-rt"
  }
}

# CREATE AWS ROUTE RESOURCE
resource "aws_route" "altschool" {
  route_table_id         = aws_route_table.altschool.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.altschool.id
}

# CREATE ROUTE TABLE ASSOCIATION TO SUBNET
resource "aws_route_table_association" "altschool" {
  count          = 3
  subnet_id      = aws_subnet.altschool[count.index].id
  route_table_id = aws_route_table.altschool.id
}

# CREATE SECURITY GROUP
resource "aws_security_group" "altschool" {
  name        = "altschool_sg"
  description = "Altschool Terraform mini project security group"
  vpc_id      = aws_vpc.altschool.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE EC2 KEY PAIR
resource "aws_key_pair" "altschool" {
  key_name   = "altschool"
  public_key = file("~/.ssh/main_terraform.pub")
}

# CREATE 3 EC2 INSTANCES
resource "aws_instance" "altschool" {
  count = 3

  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.altschool.id
  vpc_security_group_ids = [aws_security_group.altschool.id]
  subnet_id              = aws_subnet.altschool[count.index].id
  # user_data              = file("userdata.tpl")


  tags = {
    Name = "instance-${count.index + 1}"
  }
}


# CREATE ELASTIC LOAD BALANCER
resource "aws_lb" "altschool" {
  name               = "altschool-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.altschool.id]
  subnets            = aws_subnet.altschool.*.id
}

# ADD ALB LISTENER
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.altschool.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool.arn
  }
}


# CREATE TARGET GROUP FOR LOAD BALANCER
resource "aws_lb_target_group" "altschool" {
  name     = "altschool-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.altschool.id
}

# OUTPUT PUBLIC IP to file
output "host-inventory" {
  value       = aws_instance.altschool.*.public_ip
  description = "The public IP addresses of the EC2 instances."
}

# ROUTE53
resource "aws_route53_zone" "altschool" {
  name = "timothyadeyeye.com.ng."
}

# ROUTE53
resource "aws_route53_record" "altschool" {
  zone_id = aws_route53_zone.altschool.zone_id
  name    = "terraform-test.timothyadeyeye.com.ng"
  type    = "A"

  alias {
    name                   = aws_lb.altschool.dns_name
    zone_id                = aws_lb.altschool.zone_id
    evaluate_target_health = true
  }
}
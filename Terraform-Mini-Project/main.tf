# CREATE A VPC RESOURCE
resource "aws_vpc" "altschool_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "altschool-vpc"
  }
}

# CREATE A SUBNET RESOURCE
resource "aws_subnet" "altschool_public_subnet" {
  vpc_id                  = aws_vpc.altschool_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1b"

  tags = {
    Name = "altschool-ps"
  }
}

# CREATE AN INTERNET GATEWAY RESOUCE
resource "aws_internet_gateway" "altschool_internet_gateway" {
  vpc_id = aws_vpc.altschool_vpc.id

  tags = {
    Name = "altschool-igw"
  }
}
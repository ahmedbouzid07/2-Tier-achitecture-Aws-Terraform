# create vpc 

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create an internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# fetch availability zones in our region

data "aws_availability_zones" "available_zones" {}

# create first public subnet
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sub_1a"
  }
}

# create second public subnet
resource "aws_subnet" "pub_sub_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_2b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sub_2b"
  }
}

# Create a public route table for both subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public-rtb"
  }
}

# associate public subnet 1 to public route_table 

resource "aws_route_table_association" "pub-sub-1a-rtb-association" {
  subnet_id      = aws_subnet.pub_sub_1a.id
  route_table_id = aws_route_table.public_route_table.id
}


# associate public subnet 2 to public route_table 

resource "aws_route_table_association" "pub-sub-2b-rtb-association" {
  subnet_id      = aws_subnet.pub_sub_2b.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create first private subnet 

resource "aws_subnet" "pri_sub_3a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_3a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "pri-sub-3a"
  }

}

# Create second private subnet
resource "aws_subnet" "pri_sub_4b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_4b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "pri-sub-4b"
  }
}

# Create first private subnet for database
resource "aws_subnet" "pri_sub_5a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_5a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "pri-sub-5a"
  }
}

# Create second private subnet
resource "aws_subnet" "pri_sub_6b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_6b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "pri-sub-6b"
  }
}

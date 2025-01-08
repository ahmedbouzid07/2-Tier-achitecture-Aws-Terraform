# allocate elastic ip (eip) that will be used for nat-gateway in the first public ip
resource "aws_eip" "eip-nat-a" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-a"
  }
}

# allocate elastic ip (eip) that will be used for nat-gateway in the second pulic ip

resource "aws_eip" "eip-nat-b" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-b"
  }
}

# Create nat gateway in first public subnet
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_1a_id

  tags = {
    Name = "nat-a"
  }

  depends_on = [var.igw_id]
}

# Create nat gateway in first public subnet
resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_2b_id

  tags = {
    Name = "nat-b"
  }

  depends_on = [var.igw_id]
}

# create private route table and add routes through NAT-GW-A
resource "aws_route_table" "pri-rtb-a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a.id
  }

  tags = {
    Name = "Pri-rtb-a"
  }
}

# associate private subnet pri-sub-3a with private route table pri-rtb-a
resource "aws_route_table_association" "pri-sub-3a-with-Pri-rtb-a" {
  subnet_id      = var.pri_sub_3a_id
  route_table_id = aws_route_table.pri-rtb-a.id
}
# associate private subnet pri-sub-5a with private route table pri-rtb-a
resource "aws_route_table_association" "pri-sub-5a-with-Pri-rtb-a" {
  subnet_id      = var.pri_sub_5a_id
  route_table_id = aws_route_table.pri-rtb-a.id
}


# create private route table and add routes through NAT-GW-B
resource "aws_route_table" "pri-rtb-b" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-b.id
  }

  tags = {
    Name = "Pri-rtb-b"
  }
}

# associate private subnet pri-sub-4b with private route table pri-rtb-b
resource "aws_route_table_association" "pri-sub-4b-with-Pri-rtb-b" {
  subnet_id      = var.pri_sub_4b_id
  route_table_id = aws_route_table.pri-rtb-b.id
}
# associate private subnet pri-sub-6b with private route table pri-rtb-b
resource "aws_route_table_association" "pri-sub-6b-with-Pri-rtb-b" {
  subnet_id      = var.pri_sub_6b_id
  route_table_id = aws_route_table.pri-rtb-b.id
}

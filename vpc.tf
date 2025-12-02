data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "blogging_vpc" {
  cidr_block           = var.blogging_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-blogging-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.blogging_vpc.id
  cidr_block              = var.blogging_vpc_public_subnet1_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = { Name = "${var.environment}-public-subnet-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.blogging_vpc.id
  cidr_block              = var.blogging_vpc_public_subnet2_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = { Name = "${var.environment}-public-subnet-2" }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.blogging_vpc.id
  cidr_block        = var.blogging_vpc_private_subnet1_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = { Name = "${var.environment}-private-subnet-1" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.blogging_vpc.id
  cidr_block        = var.blogging_vpc_private_subnet2_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = { Name = "${var.environment}-private-subnet-2" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.blogging_vpc.id

  tags = { Name = "${var.environment}-igw" }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = { Name = "${var.environment}-nat-gw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.blogging_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.environment}-public-rt" }
}
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.blogging_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.environment}-private-rt" }
}
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

output "public_subnets" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnets" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "vpc_id" {
  value = aws_vpc.blogging_vpc.id
}

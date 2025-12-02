provider "aws" {
  region = var.AWS_REGION
}

data "aws_availability_zones" "available" {
  state = "available"
}

# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "blogging_vpc" {
  cidr_block           = var.BLOGGING_VPC_CIDR_BLOCK
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# -------------------------
# PUBLIC SUBNETS
# -------------------------

resource "aws_subnet" "blogging_vpc_public_subnet_1" {
  vpc_id                  = aws_vpc.blogging_vpc.id
  cidr_block              = var.BLOGGING_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-1"
  }
}

resource "aws_subnet" "blogging_vpc_public_subnet_2" {
  vpc_id                  = aws_vpc.blogging_vpc.id
  cidr_block              = var.BLOGGING_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-2"
  }
}

# -------------------------
# PRIVATE SUBNETS
# -------------------------

resource "aws_subnet" "blogging_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.blogging_vpc.id
  cidr_block        = var.BLOGGING_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.ENVIRONMENT}-private-subnet-1"
  }
}

resource "aws_subnet" "blogging_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.blogging_vpc.id
  cidr_block        = var.BLOGGING_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.ENVIRONMENT}-private-subnet-2"
  }
}

# -------------------------
# INTERNET GATEWAY
# -------------------------

resource "aws_internet_gateway" "blogging_igw" {
  vpc_id = aws_vpc.blogging_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-igw"
  }
}

# -------------------------
# NAT GATEWAY + EIP
# -------------------------

resource "aws_eip" "blogging_eip" {
  vpc = true

  depends_on = [aws_internet_gateway.blogging_igw]
}

resource "aws_nat_gateway" "blogging_nat_gw" {
  allocation_id = aws_eip.blogging_eip.id
  subnet_id     = aws_subnet.blogging_vpc_public_subnet_1.id

  depends_on = [aws_internet_gateway.blogging_igw]

  tags = {
    Name = "${var.ENVIRONMENT}-nat-gw"
  }
}

# -------------------------
# ROUTE TABLES
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.blogging_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.blogging_igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.blogging_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.blogging_nat_gw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-private-rt"
  }
}

# -------------------------
# ROUTE TABLE ASSOCIATIONS
# -------------------------

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.blogging_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.blogging_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.blogging_vpc_private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.blogging_vpc_private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

# -------------------------
# OUTPUTS
# -------------------------

output "vpc_id" {
  value = aws_vpc.blogging_vpc.id
}

output "public_subnet1_id" {
  value = aws_subnet.blogging_vpc_public_subnet_1.id
}

output "public_subnet2_id" {
  value = aws_subnet.blogging_vpc_public_subnet_2.id
}

output "private_subnet1_id" {
  value = aws_subnet.blogging_vpc_private_subnet_1.id
}

output "private_subnet2_id" {
  value = aws_subnet.blogging_vpc_private_subnet_2.id
}t_2.id
}

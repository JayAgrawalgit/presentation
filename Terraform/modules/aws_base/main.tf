# vpc -> myvpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    "Name" = "myvpc"
  }
}

# subnet -> public
resource "aws_subnet" "public-sub" {
  for_each = {
    "ap-south-1a" = "10.10.10.0/24"
    "ap-south-1b" = "10.10.20.0/24"
  }
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
}

# subnet -> private
resource "aws_subnet" "private-sub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.10.30.0/24"
  availability_zone = "ap-south-1c"
  tags = {
    "Name" = "private-sub"
  }
}

# internet gatway -> igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "igw"
  }
}

# routing table -> public-rt
resource "aws_route_table" "public-rt" {
  depends_on = [ aws_internet_gateway.igw  ]
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "public-rt"
  }
}

# routing table -> private-rt
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "private-rt"
  }
}

# adding private subnet to private rt
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-sub.id
  route_table_id = aws_route_table.private-rt.id
}


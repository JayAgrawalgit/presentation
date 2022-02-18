# vpc -> myvpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    "Name" = "myvpc"
  }
}

# subnet -> public
resource "aws_subnet" "public-sub" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.10.10.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-sub"
  }
}

# subnet -> private
resource "aws_subnet" "private-sub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.10.20.0/24"
  availability_zone = "ap-south-1b"
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
  depends_on = [aws_internet_gateway.igw]
  vpc_id     = aws_vpc.myvpc.id
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
  depends_on = [
    aws_route_table.private-rt, aws_subnet.private-sub
  ]
}

# adding public subnet to public rt
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.public-rt.id
  depends_on = [
    aws_route_table.public-rt, aws_subnet.public-sub
  ]
}

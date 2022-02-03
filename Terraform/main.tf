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
}

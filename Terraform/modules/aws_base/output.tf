# vpc
output "vpc_id" {
    description = "vpc-id"
    value = aws_vpc.myvpc.id
}

# public-sub
output "public_sub" {
  description = "public sub"
  value = aws_subnet.public-sub.id
}

# private-sub
output "private_sub" {
  description = "private subnets"
  value = aws_subnet.private-sub.id
}

# igw
output "igw" {
    description = "internat gateway"
    value = aws_internet_gateway.igw.id  
}

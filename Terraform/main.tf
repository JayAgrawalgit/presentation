module "aws_base" {
  source = "./modules/aws_base"
}

# elastic ip
resource "aws_eip" "nat-ip" {
  vpc = true
  tags = {
    "Name" = "nat-ip"
  }
}

# nat gateway for private ec2
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id = module.aws_base.private_sub
  tags = {
    "Name" = "nat-gw"
  }
  depends_on = [
    module.aws_base.igw
  ]
}

# security group 
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic to eks"
  vpc_id      = module.aws_base.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.aws_base.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls to eks"
  }
}

 
# iam role for eks
resource "aws_iam_role" "terraform-eks" {
  name               = "terraform-eks"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": [
                  "eks.amazonaws.com"
              ]
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
POLICY
    tags = {
        "owner" = "jay.agrawal"
    }
}

# aws iam role policy attached to eks cluster policy
resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform-eks.name
}

# eks cluster
resource "aws_eks_cluster" "myeks" {
  name     = "my_eks"
  role_arn = aws_iam_role.terraform-eks.arn

  vpc_config {
    subnet_ids         = [
        module.aws_base.public_sub,
        module.aws_base.private_sub
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy
  ]
}



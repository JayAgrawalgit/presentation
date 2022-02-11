# iam role for nods
resource "aws_iam_role" "eks-node-group-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = {
    "owner" = "jay.agrawal"
  }
}

# atached eks worker node policy to iam role
resource "aws_iam_role_policy_attachment" "worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

# attached aws eks cli policy to iam
resource "aws_iam_role_policy_attachment" "eks-cli-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

# attached iam role to ec2 container registry readonly
resource "aws_iam_role_policy_attachment" "eks-ec2-container-readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}

# eks node group
resource "aws_eks_node_group" "nodes-grp" {
  cluster_name    = aws_eks_cluster.myeks.name
  node_group_name = "nodes-grp"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn

  subnet_ids = [module.aws_base.public_sub]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker-node-policy,
    aws_iam_role_policy_attachment.eks-cli-policy,
    aws_iam_role_policy_attachment.eks-ec2-container-readonly,
  ]
}

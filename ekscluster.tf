# -------------------------------------------------------
# EKS Cluster
# -------------------------------------------------------
resource "aws_eks_cluster" "aws_eks" {
  name     = "${var.ENVIRONMENT}-blogging-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(
      module.vpc.public_subnets,
      module.vpc.private_subnets
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

  tags = {
    Name        = "${var.ENVIRONMENT}-blogging-eks-cluster"
    Environment = var.ENVIRONMENT
  }
}

# -------------------------------------------------------
# EKS Managed Node Group
# -------------------------------------------------------
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "${var.ENVIRONMENT}-blogging-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  # Worker nodes MUST be in private subnets
  subnet_ids = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name        = "${var.ENVIRONMENT}-blogging-nodegroup"
    Environment = var.ENVIRONMENT
  }
}

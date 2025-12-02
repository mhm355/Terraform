resource "aws_eks_cluster" "blogging_eks" {
  name     = "${var.environment}-blogging-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(
      aws_subnet.public_1.id != "" ? [aws_subnet.public_1.id] : [],
      aws_subnet.public_2.id != "" ? [aws_subnet.public_2.id] : [],
      aws_subnet.private_1.id != "" ? [aws_subnet.private_1.id] : [],
      aws_subnet.private_2.id != "" ? [aws_subnet.private_2.id] : []
    )
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.service_policy,
  ]

  tags = {
    Name        = "${var.environment}-blogging-eks-cluster"
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "blogging_nodegroup" {
  cluster_name    = aws_eks_cluster.blogging_eks.name
  node_group_name = "${var.environment}-blogging-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]

  instance_types = var.instance_types

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.blogging_node_sg.id]
  }

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly,
  ]

  tags = {
    Name        = "${var.environment}-blogging-nodegroup"
    Environment = var.environment
  }
}

# OIDC provider: required for IRSA (used later)
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.blogging_eks.name
  depends_on = [aws_eks_cluster.blogging_eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.blogging_eks.name
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_issuer.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# helper to fetch OIDC thumbprint
data "tls_certificate" "eks_issuer" {
  url = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}

output "cluster_endpoint" {
  value = aws_eks_cluster.blogging_eks.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.blogging_eks.certificate_authority[0].data
}

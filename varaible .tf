variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "blogging-tf-eks-demo"
}

variable "AWS_REGION" {
  description = "AWS Region for EKS deployment"
  type        = string
  default     = "eu-west-1"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name (Development / Staging / Production)"
  type        = string
  default     = "development"
}

variable "blogging_vpc_cidr_block" {
  description = "CIDR block for the Blogging VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "blogging_vpc_public_subnet1_cidr_block" {
  description = "CIDR block for Public Subnet 1"
  type        = string
  default     = "10.0.101.0/24"
}

variable "blogging_vpc_public_subnet2_cidr_block" {
  description = "CIDR block for Public Subnet 2"
  type        = string
  default     = "10.0.102.0/24"
}

variable "blogging_vpc_private_subnet1_cidr_block" {
  description = "CIDR block for Private Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "blogging_vpc_private_subnet2_cidr_block" {
  description = "CIDR block for Private Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "blogging-tf-eks-demo"
}

variable "node_group_desired_size" {
  type    = number
  default = 1
}
variable "node_group_min_size" {
  type    = number
  default = 1
}
variable "node_group_max_size" {
  type    = number
  default = 2
}

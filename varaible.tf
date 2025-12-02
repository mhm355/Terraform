variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}

variable "BLOGGING_VPC_CIDR_BLOCK" {
  description = "CIDR block for the Blogging VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "BLOGGING_VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {
  description = "CIDR block for Public Subnet 1"
  type        = string
  default     = "10.0.101.0/24"
}

variable "BLOGGING_VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {
  description = "CIDR block for Public Subnet 2"
  type        = string
  default     = "10.0.102.0/24"
}

variable "BLOGGING_VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {
  description = "CIDR block for Private Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "BLOGGING_VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {
  description = "CIDR block for Private Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ENVIRONMENT" {
  description = "Environment name (e.g. Development, Staging, Production)"
  type        = string
  default     = "Development"
}

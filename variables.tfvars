aws_region = "us-east-1"

environment = "development"

blogging_vpc_cidr_block = "10.0.0.0/16"

blogging_vpc_public_subnet1_cidr_block  = "10.0.101.0/24"
blogging_vpc_public_subnet2_cidr_block  = "10.0.102.0/24"

blogging_vpc_private_subnet1_cidr_block = "10.0.1.0/24"
blogging_vpc_private_subnet2_cidr_block = "10.0.2.0/24"

cluster_name = "blogging-tf-eks-demo"

node_group_desired_size = 1
node_group_min_size     = 1
node_group_max_size     = 2

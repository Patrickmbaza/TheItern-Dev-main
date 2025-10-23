# provider "aws" {
#   region = "us-east-1"
# }

# # VPC
# resource "aws_vpc" "eks_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "eks-vpc"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.eks_vpc.id

#   tags = {
#     Name = "eks-igw"
#   }
# }

# # Route Table for Public Subnets
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.eks_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "eks-public-route-table"
#   }
# }

# # Public Subnet 1
# resource "aws_subnet" "public_subnet_1" {
#   vpc_id                  = aws_vpc.eks_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-1"
#   }
# }

# # Public Subnet 2
# resource "aws_subnet" "public_subnet_2" {
#   vpc_id                  = aws_vpc.eks_vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-2"
#   }
# }

# # Associate Route Table with Subnets
# resource "aws_route_table_association" "public_subnet_1" {
#   subnet_id      = aws_subnet.public_subnet_1.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "public_subnet_2" {
#   subnet_id      = aws_subnet.public_subnet_2.id
#   route_table_id = aws_route_table.public_rt.id
# }

# # Security Group for EKS Cluster
# resource "aws_security_group" "eks_sg" {
#   vpc_id = aws_vpc.eks_vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "eks-sg"
#   }
# }

# # IAM Role for EKS Cluster
# resource "aws_iam_role" "eks_cluster_role" {
#   name = "eks-cluster-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# # Create EKS Cluster
# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "my-eks-cluster"
#   role_arn = aws_iam_role.eks_cluster_role.arn

#   vpc_config {
#     subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
#     security_group_ids = [aws_security_group.eks_sg.id]
#   }

#   depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
# }

# # IAM Role for Worker Nodes
# resource "aws_iam_role" "node_group_role" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "worker_node_policy" {
#   role       = aws_iam_role.node_group_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "cni_policy" {
#   role       = aws_iam_role.node_group_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "container_registry_policy" {
#   role       = aws_iam_role.node_group_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

# # Worker Node Group
# resource "aws_eks_node_group" "eks_nodes" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "eks-node-group"
#   node_role_arn   = aws_iam_role.node_group_role.arn
#   subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   instance_types = ["t3.medium"]

#   remote_access {
#     ec2_ssh_key = "PatrickKP" # Replace with your SSH key
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.worker_node_policy,
#     aws_iam_role_policy_attachment.cni_policy,
#     aws_iam_role_policy_attachment.container_registry_policy
#   ]
# }

# # Output
# output "cluster_endpoint" {
#   value = aws_eks_cluster.eks_cluster.endpoint
# }

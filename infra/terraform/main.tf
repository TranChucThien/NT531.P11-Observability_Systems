terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # access_key = var.access_key
  # secret_key = var.secret_key
  # token = var.token
  # shared_credentials_files = [ var.credentials_file ]
}

locals {
  prod_cluster_name = "production-environment"
  prod_node_group_name = "production-nodes"
  vpc_id = var.vpc_id
  subnet_ids = ["subnet-03609e1568ecf1b2a" , "subnet-0b00572f11de29f3e"]
  iam_role_arn = var.iam_role_arn
}

# EKS Cluster provisioning
resource "aws_eks_cluster" "production_cluster" {
  name     = local.prod_cluster_name
  role_arn = local.iam_role_arn

  vpc_config {
    subnet_ids = local.subnet_ids
  }

  version = "1.29" 
}


# EKS Node Group
resource "aws_eks_node_group" "prod_node_group" {
  cluster_name    = local.prod_cluster_name
  node_group_name = local.prod_node_group_name
  node_role_arn    = local.iam_role_arn
  subnet_ids       = local.subnet_ids

  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [ aws_eks_cluster.production_cluster ]
}


# EKS Add-ons
resource "aws_eks_addon" "coredns" {
  cluster_name = local.prod_cluster_name
  addon_name = "coredns"
  addon_version = "v1.11.1-eksbuild.4"
  depends_on = [ aws_eks_cluster.production_cluster, aws_eks_node_group.prod_node_group ]
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = local.prod_cluster_name
  addon_name = "kube-proxy"
  addon_version = "v1.29.0-eksbuild.1"
  depends_on = [ aws_eks_cluster.production_cluster ]
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = local.prod_cluster_name
  addon_name = "vpc-cni"
  addon_version = "v1.16.0-eksbuild.1"
  depends_on = [ aws_eks_cluster.production_cluster ]
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = local.prod_cluster_name
  addon_name = "eks-pod-identity-agent"
  addon_version = "v1.2.0-eksbuild.1"
  depends_on = [ aws_eks_cluster.production_cluster ]
}

# EC2 for Splunk Server
resource "aws_instance" "ec2_splunk" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.small"
  key_name = "public-ec2-key"

  subnet_id = "subnet-09f008b76583d8cae"
  vpc_security_group_ids = [ "sg-0d681723d5517857d" ]
  tags = {
    Name = "Splunk Server"
  }
}

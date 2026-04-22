# -------------------------------
# VPC (your existing VPC)
# -------------------------------
data "aws_vpc" "selected" {
  id = "vpc-020631af178df81d3"
}

# -------------------------------
# EKS Cluster
# -------------------------------
resource "aws_eks_cluster" "akshay-cluster-v01" {
  name     = "akshay-cluster-v01"
  version  = "1.33"
  role_arn = data.aws_iam_role.example.arn   # coming from iam.tf

  vpc_config {
    subnet_ids = [
      "subnet-07a3789bc64a438df",
      "subnet-08d783ccbd207e146"
    ]
  }
}

# -------------------------------
# Outputs
# -------------------------------
output "endpoint" {
  value = aws_eks_cluster.akshay-cluster-v01.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.akshay-cluster-v01.certificate_authority[0].data
}

# -------------------------------
# Node Group
# -------------------------------
resource "aws_eks_node_group" "node_grp" {
  cluster_name    = aws_eks_cluster.akshay-cluster-v01.name
  node_group_name = "pc-node-group"
  node_role_arn   = data.aws_iam_role.worker.arn   # coming from iam.tf

  subnet_ids = [
    "subnet-07a3789bc64a438df",
    "subnet-08d783ccbd207e146"
  ]

  capacity_type  = "ON_DEMAND"
  disk_size      = 30
  instance_types = ["t3.medium"]

  labels = {
    env = "dev"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

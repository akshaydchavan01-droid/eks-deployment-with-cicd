# -------------------------------
# VPC (your existing VPC)
# -------------------------------
data "aws_vpc" "selected" {
  id = "vpc-0862211fae4a6daf4"
}

# -------------------------------
# EKS Cluster
# -------------------------------
resource "aws_eks_cluster" "akshay-cluster-v01" {
  name     = "akshay-cluster-v01"
  version  = "1.29"
  role_arn = data.aws_iam_role.example.arn   # coming from iam.tf

  vpc_config {
    subnet_ids = [
      "subnet-01287583dac06eae7",
      "subnet-0a77e63e5fc311562"
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
    "subnet-01287583dac06eae7",
    "subnet-0a77e63e5fc311562"
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

# -------------------------------
# VPC (your existing VPC)
# -------------------------------
data "aws_vpc" "selected" {
  id = "vpc-0d09ee699cc84cc8f"
}

# -------------------------------
# EKS Cluster
# -------------------------------
resource "aws_eks_cluster" "akshay_cluster" {
  name     = "akshay-cluster-v01"
  version  = "1.35"   # ✅ supported version
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [
      "subnet-0563897eb2258addb",
      "subnet-0378c45c056a86558"
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

# -------------------------------
# Outputs
# -------------------------------
output "endpoint" {
  value = aws_eks_cluster.akshay_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.akshay_cluster.certificate_authority[0].data
}

# -------------------------------
# Node Group
# -------------------------------
resource "aws_eks_node_group" "node_grp" {
  cluster_name    = aws_eks_cluster.akshay_cluster.name
  node_group_name = "pc-node-group"
  node_role_arn   = aws_iam_role.worker.arn

  subnet_ids = [
    "subnet-0563897eb2258addb",
    "subnet-0378c45c056a86558"
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

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

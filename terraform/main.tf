provider "aws" {
  region = "ap-south-1"
}

# VPC with public subnets (for public node group)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "aman-devsecops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  map_public_ip_on_launch = true
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    owner  = "aman"
    project = "aman-devsecops-project"
  }
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "aman-devsecops-eks"
  cluster_version = "1.32"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]  # Secure later
  cluster_endpoint_private_access      = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # Pod Identity (no OIDC/IRSA)
  enable_irsa = false

  eks_managed_node_groups = {
    public = {
      name           = "aman-ng-public"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      # 20GB EBS root volume
      disk_size = 20

      # Public networking
      public_ip = true

      # SSH access
      key_name = "DevSecOps-Project-Key"

      # IAM policies matching your eksctl config
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy   = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        ALBIngressController       = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"  
        ExternalDNS                = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"        
      }

      labels = {
        owner         = "aman"
        app           = "devsecops-project"
      }

      tags = {
        "node-type"  = "public-worker-node"
        "managed-by" = "terraform"
        owner        = "aman"
        project      = "aman-devsecops-project"
      }
    }
  }

  # Cluster tags
  tags = {
    owner  = "aman"
    project = "aman-devsecops-project"
  }
}

resource "aws_eks_access_entry" "my_admin" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = "arn:aws:iam::185137893823:role/jenkins-agent-role"
  kubernetes_groups = ["my-admin"]
}
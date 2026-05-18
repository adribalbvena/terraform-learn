module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name = "myapp-eks-cluster"
  kubernetes_version = "1.33"

  subnet_ids = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  endpoint_public_access = true # Allow access to the EKS API server from the public internet
  enable_cluster_creator_admin_permissions = true # Grant admin permissions to the user who creates the cluster
  
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    dev = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }

  tags = {
    environment = "development"
    application = "myapp"

  }

}
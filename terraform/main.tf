module "network_info" {
  source = "./modules/network-info"
  vpc_id = var.vpc_id
}

module "web_security" {
  source = "./modules/web-security"
  vpc_id = var.vpc_id
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "capstone-eks"
  cluster_role_arn   = "arn:aws:iam::393080455637:role/CapstoneEKSClusterRole"
  node_role_arn      = "arn:aws:iam::393080455637:role/CapstoneEKSNodeRole"
  kubernetes_version = "1.34"
  subnet_ids         = module.network_info.subnet_ids
}

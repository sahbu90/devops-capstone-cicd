resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["16.176.131.138/32"]
  }

  tags = {
    Project     = "DevOps-Capstone"
    Environment = "Learning"
  }
}

resource "aws_ec2_tag" "eks_cluster" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_elb" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

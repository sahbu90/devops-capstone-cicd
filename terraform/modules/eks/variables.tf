variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.34"
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  type        = string
}

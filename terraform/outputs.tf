output "existing_vpc_id" {
  description = "ID of the existing VPC"
  value       = module.network_info.vpc_id
}

output "existing_vpc_cidr" {
  description = "CIDR block of the existing VPC"
  value       = module.network_info.vpc_cidr
}

output "existing_subnet_ids" {
  description = "Subnet IDs of the existing VPC"
  value       = module.network_info.subnet_ids
}

output "existing_security_group_ids" {
  description = "Security Group IDs in the existing VPC"
  value       = module.network_info.security_group_ids
}

output "existing_security_group_details" {
  description = "Details of Security Groups in the existing VPC"
  value       = module.network_info.security_group_details
}

output "managed_web_security_group_id" {
  description = "ID of the Terraform-managed web Security Group"
  value       = module.web_security.security_group_id
}

output "managed_web_security_group_name" {
  description = "Name of the Terraform-managed web Security Group"
  value       = module.web_security.security_group_name
}

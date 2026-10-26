output "security_group_id" {
  description = "ID of the Terraform-managed web security group"
  value       = aws_security_group.web.id
}

output "security_group_name" {
  description = "Name of the Terraform-managed web security group"
  value       = aws_security_group.web.name
}

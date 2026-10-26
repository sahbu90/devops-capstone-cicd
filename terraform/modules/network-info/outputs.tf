output "vpc_id" {
  description = "ID of the inspected VPC"
  value       = data.aws_vpc.existing.id
}

output "vpc_cidr" {
  description = "CIDR block of the inspected VPC"
  value       = data.aws_vpc.existing.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs in the inspected VPC"
  value       = data.aws_subnets.existing.ids
}

output "security_group_ids" {
  description = "Security Group IDs in the inspected VPC"
  value       = data.aws_security_groups.existing.ids
}

output "security_group_details" {
  description = "Security Group IDs, names, and descriptions in the inspected VPC"

  value = {
    for id, sg in data.aws_security_group.details : id => {
      id          = sg.id
      name        = sg.name
      description = sg.description
    }
  }
}

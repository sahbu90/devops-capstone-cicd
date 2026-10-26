variable "aws_region" {
  description = "AWS region for the DevOps Capstone"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  description = "ID of the existing VPC to reference"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the web security group will belong"
  type        = string
}

variable "name" {
  description = "Name of the managed web security group"
  type        = string
  default     = "capstone-web-sg"
}

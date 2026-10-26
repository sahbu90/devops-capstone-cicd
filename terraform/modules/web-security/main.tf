
resource "aws_security_group" "web" {
  name        = var.name
  description = "Terraform-managed web security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS web traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.name
    ManagedBy = "Terraform"
    Project   = "my-devops-capstone"
  }
}


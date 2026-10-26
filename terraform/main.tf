module "network_info" {
  source = "./modules/network-info"
  vpc_id = var.vpc_id
}

module "web_security" {
  source = "./modules/web-security"
  vpc_id = var.vpc_id
}

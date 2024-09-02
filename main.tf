module "vpc" {
  source               = "./vpc"
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source                = "./securityGroups"
  publicSubnetCidrBlock = tolist(module.vpc.publicSubnetCidrBlock)
  vpc_id                = module.vpc.nginxGiteaVpcId
}

module "ec2" {
  source                        = "./ec2"
  nginxGiteaSgId                = module.security_group.nginxGiteaSecurityGroupId
  nginxGiteaSubnetId            = tolist(module.vpc.nginxGiteaPublicSubnetId)[0]
  user_data_install_gitea_nginx = templatefile("./template/ec2_gitea_nginx.sh", {})
}
module "vpc" {
  source               = "./vpc"
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "sgs" {
  source                = "./sgs"
  publicSubnetCidrBlock = tolist(module.vpc.publicSubnetCidrBlock)
  vpc_id                = module.vpc.nginxGiteaVpcId
}

module "ec2_instance" {
  source                        = "./ec2_instance"
  nginxGiteaSgId                = module.sgs.nginxGiteaSecurityGroupId
  nginxGiteaSubnetId            = tolist(module.vpc.nginxGiteaPublicSubnetId)[0]
  user_data_install_gitea_nginx = file("ec2_gitea.sh")
}

variable "user_data_install_gitea_nginx" {}
variable "nginxGiteaSgId" {}
variable "nginxGiteaSubnetId" {}

resource "aws_instance" "nginxGiteaEc2Instance" {
  ami           = "ami-05c3e698bd0cffe7e"
  instance_type = "t2.micro"
  key_name      = "terraform_nav"
  associate_public_ip_address = true
  user_data     = var.user_data_install_gitea_nginx
  vpc_security_group_ids = [var.nginxGiteaSgId]
  subnet_id = var.nginxGiteaSubnetId
  metadata_options {
    http_endpoint = "enabled" 
    http_tokens   = "required" 
  }

  tags = {
    Name = "nginxGiteaEc2Instance"
  }
}

resource "aws_key_pair" "terraform_nav_public_key" {
  key_name   = "terraform_nav"
  public_key = "${file("terraform_nav.pub")}"
}
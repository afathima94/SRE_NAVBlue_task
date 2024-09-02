variable "vpc_id" {}
variable "publicSubnetCidrBlock" {}

output "nginxGiteaSecurityGroupId" {
  value = aws_security_group.nginxGiteaSecurityGroup.id
}

resource "aws_security_group" "nginxGiteaSecurityGroup" {
  vpc_id = var.vpc_id

  tags = {
    Name = "nginxGiteaSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.nginxGiteaSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.nginxGiteaSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "HTTPS" {
  security_group_id = aws_security_group.nginxGiteaSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ec2nginxGitea" {
  security_group_id = aws_security_group.nginxGiteaSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.nginxGiteaSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
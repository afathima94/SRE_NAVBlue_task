variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}

output "nginxGiteaVpcId" {
  value = aws_vpc.nginxGiteaVpc.id
}

output "publicSubnetCidrBlock" {
  value = aws_subnet.nginxGiteaVpcPublicSubnet.*.cidr_block
}

output "nginxGiteaPublicSubnetId" {
  value = aws_subnet.nginxGiteaVpcPublicSubnet.*.id
}

resource "aws_vpc" "nginxGiteaVpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "nginxGiteaVpc"
  }
}

resource "aws_subnet" "nginxGiteaVpcPublicSubnet" {
  vpc_id = aws_vpc.nginxGiteaVpc.id
  count = length(var.cidr_public_subnet)
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "nginxGiteaVpcPublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "nginxGiteaInternetGateway" {
  vpc_id = aws_vpc.nginxGiteaVpc.id

  tags = {
    Name = "nginxGiteaInternetGateway"
  }
}

resource "aws_route_table" "nginxGiteaPublicSubnetRouteTable" {
  vpc_id = aws_vpc.nginxGiteaVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginxGiteaInternetGateway.id
  }

  tags = {
    Name = "nginxGiteaPublicSubnetRouteTable"
  }
}

resource "aws_route_table_association" "nginxGiteaPublicSubnetRouteTableAssociation" {
  route_table_id = aws_route_table.nginxGiteaPublicSubnetRouteTable.id
  count = length(aws_subnet.nginxGiteaVpcPublicSubnet)
  subnet_id = aws_subnet.nginxGiteaVpcPublicSubnet[count.index].id
}
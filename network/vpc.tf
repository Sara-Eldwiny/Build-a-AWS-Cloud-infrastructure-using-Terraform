#create vpc
resource "aws_vpc" "main" {
  cidr_block       = var.Vcidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.commenname}main"
  }
}
#create public subnet
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Vpublic_cidr1
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
   tags = {
    Name = "${var.commenname}public"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Vpublic_cidr2
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
   tags = {
    Name = "${var.commenname}public"
  }
}
#create private subnet
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Vprivate_cidr1
  availability_zone = "${var.region}a"
   tags = {
    Name = "${var.commenname}private"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.Vprivate_cidr2
  availability_zone = "${var.region}b"
   tags = {
    Name = "${var.commenname}private"
  }
}
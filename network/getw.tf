resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.commenname}main_gw"
  }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "gw NAT"
  }
}
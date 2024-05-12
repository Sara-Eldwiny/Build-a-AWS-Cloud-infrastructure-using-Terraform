resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.Vpubrouttable_cidr
    gateway_id = aws_internet_gateway.gw.id
  }
   tags = {
    Name = "pubroute"
  }
}
resource "aws_route_table" "privateroutetable" {
  vpc_id = aws_vpc.main.id
   tags = {
    Name = "privroute"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.publicroutetable.id
}
resource "aws_route_table_association" "prev" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privateroutetable.id
}
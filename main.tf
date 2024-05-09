
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "MySubnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"  
  gateway_id             = aws_internet_gateway.my_igw.id 
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PrivateRouteTable"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "ssh_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSHSecurityGroup"
  }
}

resource "aws_security_group" "internal_ssh_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  tags = {
    Name = "InternalSSHSecurityGroup"
  }
}

resource "aws_instance" "bastion" {
  ami           = "339712919177"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id

  security_groups = [aws_security_group.internal_ssh_sg.name]

  tags = {
    Name = "BastionInstance"
  }
}

resource "aws_instance" "application" {
  ami           = "339712919177"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id  

  security_groups = [aws_security_group.internal_ssh_sg.name]

  tags = {
    Name = "ApplicationInstance"
  }
}



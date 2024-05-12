data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 owners = ["099720109477"]
}

resource "aws_instance" "application" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.machine_type
  subnet_id     = module.network.subnetpriv1.id
  vpc_security_group_ids = [aws_security_group.secure2.id]
  key_name  = aws_key_pair.key.key_name
  tags = {
    Name = "${var.commenname}application"
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.machine_type
  subnet_id     = module.network.subnetpub1.id
  vpc_security_group_ids = [aws_security_group.secure1.id]
  key_name  = aws_key_pair.key.key_name
  tags = {
    Name = "${var.commenname}bastion" 
  }
  provisioner  "local-exec"{
    command =  "echo ${self.public_ip} > inventory"
  }
  user_data = <<-EOF
    #!/bin/bash
    echo '${tls_private_key.key.private_key_pem}' > /home/ubuntu/key.pem
    chmod 400 key.pem
    chown ubuntu:ubuntu key.pem
  EOF

}
resource "aws_key_pair" "key" {
  key_name   = "${var.commenname}key"
  public_key = tls_private_key.key.public_key_openssh
}
resource "local_file" "private_key_file" {
  content  = tls_private_key.key.private_key_pem
  filename = "key.pem"
}
resource "tls_private_key" "key" {
  algorithm   = "RSA"
  rsa_bits    = 2048
}

output "ssh_private_key_path" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "ssh_public_key" {
  value     = tls_private_key.key.public_key_openssh
}

# resource "null_rersource" "myresource"{
#   provisioner "local-exec"
#   {
#     command =  "echo ${self.public_ip} > inventory"
#   }
# }
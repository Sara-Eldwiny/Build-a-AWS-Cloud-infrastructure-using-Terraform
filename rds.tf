resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "${var.commenname}my-db-subnet-group"
  subnet_ids = [module.network.subnetpriv1.id,module.network.subnetpriv2.id]  
  tags = {
    Name = "${var.commenname}My DB Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "${var.commenname}my-rds-securitygr"
  vpc_id = module.network.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [var.Vcidr] 
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [var.Vpubrouttable_cidr]
  }
}

resource "aws_db_instance" "my_db_instance" {
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 10
  identifier         = "${var.commenname}my-db-instance"
  username           = "admin"
  password           = "admin123"
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_elasticache_subnet_group" "example" {
  name       = "${var.commenname}my-cache-subnet"
  subnet_ids = [module.network.subnetpriv1.id]
}

resource "aws_security_group" "elasticache_sg" {
  name = "${var.commenname}my-elasticache-sg"
  vpc_id = module.network.vpc_id

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = [var.Vcidr]  # Replace with your allowed IP address
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [var.Vpubrouttable_cidr]
  }
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "${var.commenname}cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.example.name
  security_group_ids = [aws_security_group.elasticache_sg.id]
}
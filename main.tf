module "vpc" {
  source = "./vpc"
}

module "ecr" {
  source = "./ecr"

  repository_name      = "my-ecr-repo"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  keep_last_images     = 30

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "alb" {
  source = "./alb"

  name               = "my-alb"
  internal           = false
  security_group_ids = [aws_security_group.alb.id]
  subnet_ids         = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id

  target_group_name = "my-target-group"
  target_group_port = 80
  health_check_path = "/"

  certificate_arn = var.certificate_arn

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "s3" {
  source = "./s3"

  bucket_name     = "my-s3-bucket"
  acl             = "private"
  versioning      = true
  expiration_days = 90

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "bastion" {
  source = "./bastion"

  ami_id             = var.bastion_ami_id
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [aws_security_group.bastion.id]
  key_name           = var.key_name
  root_volume_size   = 8

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "rds" {
  source = "./rds"

  db_subnet_group_name = "my-db-subnet-group"
  subnet_ids           = module.vpc.private_subnets
  identifier           = "my-rds"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp3"
  kms_key_id           = var.kms_key_id

  db_name  = "mydb"
  username = var.db_username
  password = var.db_password
  port     = 3306

  security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  skip_final_snapshot       = false
  final_snapshot_identifier = "my-rds-final-snapshot"

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "elasticache" {
  source = "./elasticache"

  subnet_group_name    = "my-elasticache-subnet-group"
  subnet_ids           = module.vpc.private_subnets
  cluster_id           = "my-elasticache"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379

  security_group_ids = [aws_security_group.elasticache.id]

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

resource "aws_security_group" "elasticache" {
  name        = "elasticache-sg"
  description = "Security group for ElastiCache"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

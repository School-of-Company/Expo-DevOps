resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "main" {
  identifier           = var.identifier
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  storage_type        = var.storage_type
  storage_encrypted   = true
  kms_key_id          = var.kms_key_id

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = var.tags
} 
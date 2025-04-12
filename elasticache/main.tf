resource "aws_elasticache_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = var.cluster_id
  engine              = var.engine
  engine_version      = var.engine_version
  node_type           = var.node_type
  num_cache_nodes     = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                = var.port
  security_group_ids  = var.security_group_ids
  subnet_group_name   = aws_elasticache_subnet_group.main.name

  tags = var.tags
} 
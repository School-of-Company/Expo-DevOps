resource "aws_elasticache_subnet_group" "expo" {
  name       = "expo-cache-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "expo" {
  name   = "expo-cache-params"
  family = "valkey8"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

resource "aws_elasticache_replication_group" "expo" {
  replication_group_id       = "expo-cache"
  description                = "Expo application cache"
  node_type                  = "cache.t3.small"
  num_cache_clusters         = 2
  port                       = 6379
  parameter_group_name       = aws_elasticache_parameter_group.expo.name
  subnet_group_name          = aws_elasticache_subnet_group.expo.name
  security_group_ids         = [var.security_group_id]
  automatic_failover_enabled = true
  multi_az_enabled          = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = {
    Name = "expo-cache"
  }
} 
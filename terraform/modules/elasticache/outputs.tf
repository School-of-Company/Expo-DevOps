output "primary_endpoint" {
  description = "The primary endpoint of the ElastiCache cluster"
  value       = aws_elasticache_replication_group.expo.primary_endpoint_address
}

output "reader_endpoint" {
  description = "The reader endpoint of the ElastiCache cluster"
  value       = aws_elasticache_replication_group.expo.reader_endpoint_address
}

output "replication_group_id" {
  description = "The ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.expo.id
} 
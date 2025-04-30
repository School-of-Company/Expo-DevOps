output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.expo.endpoint
}

output "db_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.expo.port
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.expo.db_name
} 
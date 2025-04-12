output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.bastion.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.endpoint
}

output "elasticache_endpoint" {
  description = "Endpoint of the ElastiCache cluster"
  value       = module.elasticache.endpoint
} 
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.expo-bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.expo-bucket.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.expo-bucket.bucket_regional_domain_name
}
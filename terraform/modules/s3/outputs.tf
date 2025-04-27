output "image_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.expo-image.id
}

output "image_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.expo-image.arn
}

output "image_bucket_regional_domain_name" {
  description = "The regional domain name of the image S3 bucket"
  value       = aws_s3_bucket.expo-image.bucket_regional_domain_name
}

output "qr_bucket_regional_domain_name" {
  description = "The regional domain name of the QR S3 bucket"
  value       = aws_s3_bucket.expo-qr.bucket_regional_domain_name
}
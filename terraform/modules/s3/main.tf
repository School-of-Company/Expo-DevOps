resource "aws_s3_bucket" "expo-bucket" {
  bucket = "${var.name}-QR-bucket"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "expo-bucket" {
  bucket = aws_s3_bucket.expo-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "expo-bucket" {
  bucket = aws_s3_bucket.expo-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.expo-bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
} 
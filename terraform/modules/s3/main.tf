resource "aws_s3_bucket" "expo-image" {
  bucket = "${var.name}-bucket"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "expo-image" {
  bucket = aws_s3_bucket.expo-image.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "expo-image" {
  bucket = aws_s3_bucket.expo-image.id
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
        Resource  = "${aws_s3_bucket.expo-image.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket" "expo-qr" {
  bucket = "expo-qr-bucket"
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "expo-qr" {
  bucket = aws_s3_bucket.expo-qr.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "expo-qr" {
  bucket = aws_s3_bucket.expo-qr.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "expo-qr" {
  bucket = aws_s3_bucket.expo-qr.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "expo-qr" {
  bucket = aws_s3_bucket.expo-qr.id
  policy = data.aws_iam_policy_document.expo-qr.json
}

data "aws_iam_policy_document" "expo-qr" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.expo-qr.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
} 
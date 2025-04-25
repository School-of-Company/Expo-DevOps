resource "aws_acm_certificate" "expo-acm" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# Only create validation resource if wait_for_validation is true
resource "aws_acm_certificate_validation" "expo-acm-validation" {
  count = var.wait_for_validation ? 1 : 0

  certificate_arn         = aws_acm_certificate.expo-acm.arn
  validation_record_fqdns = [for record in aws_acm_certificate.expo-acm.domain_validation_options : record.resource_record_name]
}

# Create a data source to get the certificate status
data "aws_acm_certificate" "expo-acm" {
  domain   = var.domain_name
  statuses = ["ISSUED", "PENDING_VALIDATION"]
  depends_on = [aws_acm_certificate.expo-acm]
}

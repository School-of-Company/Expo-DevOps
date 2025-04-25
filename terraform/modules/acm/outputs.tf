output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = data.aws_acm_certificate.expo-acm.arn
}

output "certificate_status" {
  description = "The status of the certificate"
  value       = data.aws_acm_certificate.expo-acm.status
}

output "certificate_domain_validation_options" {
  description = "A list of domain validation options for the certificate"
  value       = aws_acm_certificate.expo-acm.domain_validation_options
}

output "validation_record_fqdns" {
  description = "A list of FQDNs that should be used for DNS validation"
  value       = [for record in aws_acm_certificate.expo-acm.domain_validation_options : record.resource_record_name]
}

output "validation_record_values" {
  description = "A list of values that should be used for DNS validation"
  value       = [for record in aws_acm_certificate.expo-acm.domain_validation_options : record.resource_record_value]
}

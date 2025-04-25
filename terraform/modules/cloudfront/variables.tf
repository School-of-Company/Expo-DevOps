variable "name" {
  description = "Name prefix for the CloudFront distribution"
  type        = string
}

variable "s3_origin_domain" {
  description = "Domain name of the S3 origin"
  type        = string
}

variable "alb_origin_domain" {
  description = "Domain name of the ALB origin"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 
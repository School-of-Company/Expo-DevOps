variable "certificate_arn" {
  description = "ARN of the SSL certificate for ALB"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for bastion host"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for RDS encryption"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
} 
variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0d5bb3742db8fc264"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "expo-key"
}

variable "domain_name" {
  description = "The domain name for which the certificate should be issued"
  type        = string
  default     = "startup-expo.kr"
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = ["*.startup-expo.kr"]
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}



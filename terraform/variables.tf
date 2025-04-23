variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0d5bb3742db8fc264"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the bastion host"
  type        = string
  default = "expo-key"
}



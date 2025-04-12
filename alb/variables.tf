variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs for the load balancer"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
} 
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "Access control list for the bucket"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Whether to enable versioning"
  type        = bool
  default     = true
}

variable "expiration_days" {
  description = "Number of days until objects expire"
  type        = number
  default     = 90
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
} 
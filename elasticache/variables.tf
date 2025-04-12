variable "subnet_group_name" {
  description = "Name of the subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the subnet group"
  type        = list(string)
}

variable "cluster_id" {
  description = "Cluster identifier"
  type        = string
}

variable "engine" {
  description = "Name of the cache engine"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Version number of the cache engine"
  type        = string
  default     = "6.x"
}

variable "node_type" {
  description = "Instance type for the cache nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Name of the parameter group"
  type        = string
  default     = "default.redis6.x"
}

variable "port" {
  description = "Port number on which the cache accepts connections"
  type        = number
  default     = 6379
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
} 

variable "api_url" {
  description = "API URL for the application"
  type        = string
  default     = "https://api.craftista.com"
}

variable "app_env" {
  description = "Application environment"
  type        = string
  default     = "production"
}

variable "log_level" {
  description = "Log level for the application"
  type        = string
  default     = "info"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key for external services"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
  sensitive   = true
}

variable "replica_count" {
  description = "Number of application replicas"
  type        = number
  default     = 3
}

variable "image_name" {
  description = "Docker image name"
  type        = string
  default     = "craftista"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "craftista.yourdomain.com"
}

variable "cluster_name" {
  description = "Cluster name used in generated resource names."
  type        = string
  default     = "iron"
}

variable "b2_bucket_name" {
  description = "Globally unique private B2 bucket used as the Flux source."
  type        = string
  default     = "reonokiy-iron-flux"
}

variable "b2_region" {
  description = "Backblaze B2 region, for example us-west-004."
  type        = string
  default     = "us-west-004"
}

variable "b2_s3_endpoint" {
  description = "S3-compatible B2 endpoint without scheme. Defaults from b2_region."
  type        = string
  default     = null
}

variable "b2_object_prefix" {
  description = "Object prefix published by GitHub Actions and fetched by Flux."
  type        = string
  default     = "clusters/iron/"

  validation {
    condition     = endswith(var.b2_object_prefix, "/")
    error_message = "b2_object_prefix must end with a slash."
  }
}

variable "github_owner" {
  description = "GitHub owner or organization that contains the repository."
  type        = string
  default     = "reonokiy"
}

variable "github_repository" {
  description = "GitHub repository name, without the owner."
  type        = string
  default     = "iron"
}

output "b2_bucket_name" {
  description = "B2 bucket used by Flux."
  value       = b2_bucket.flux_config.bucket_name
}

output "b2_object_prefix" {
  description = "Object prefix published by GitHub Actions and fetched by Flux."
  value       = var.b2_object_prefix
}

output "b2_s3_endpoint" {
  description = "S3-compatible B2 endpoint without scheme."
  value       = local.b2_s3_endpoint
}

output "github_actions_secret_names" {
  description = "GitHub Actions repository secrets managed by Terraform."
  value = [
    github_actions_secret.b2_bucket.secret_name,
    github_actions_secret.b2_endpoint.secret_name,
    github_actions_secret.b2_region.secret_name,
    github_actions_secret.b2_key_id.secret_name,
    github_actions_secret.b2_application_key.secret_name,
  ]
}

output "flux_b2_bucket" {
  description = "B2 bucket used by Flux."
  value       = b2_bucket.flux_config.bucket_name
}

output "flux_b2_endpoint" {
  description = "S3-compatible B2 endpoint used by Flux."
  value       = local.b2_s3_endpoint
}

output "flux_b2_region" {
  description = "B2 region used by Flux."
  value       = var.b2_region
}

output "flux_b2_prefix" {
  description = "Object prefix published by GitHub Actions and fetched by Flux."
  value       = var.b2_object_prefix
}

output "flux_b2_key_id" {
  description = "B2 read key ID used by Flux."
  value       = b2_application_key.flux_read.application_key_id
  sensitive   = true
}

output "flux_b2_application_key" {
  description = "B2 read application key used by Flux."
  value       = b2_application_key.flux_read.application_key
  sensitive   = true
}

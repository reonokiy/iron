resource "b2_bucket" "flux_config" {
  bucket_name = var.b2_bucket_name
  bucket_type = "allPrivate"

  bucket_info = {
    cluster    = var.cluster_name
    managed_by = "terraform"
    purpose    = "flux-source"
  }

  lifecycle_rules {
    file_name_prefix                                       = var.b2_object_prefix
    days_from_starting_to_canceling_unfinished_large_files = 1
  }
}

resource "b2_application_key" "github_actions" {
  key_name     = "${var.cluster_name}-github-actions-b2-sync"
  capabilities = local.github_actions_capabilities
  bucket_ids   = [b2_bucket.flux_config.bucket_id]
  name_prefix  = var.b2_object_prefix
}

resource "b2_application_key" "flux_read" {
  key_name     = "${var.cluster_name}-flux-b2-read"
  capabilities = local.flux_read_capabilities
  bucket_ids   = [b2_bucket.flux_config.bucket_id]
}

resource "github_actions_secret" "b2_bucket" {
  repository  = var.github_repository
  secret_name = "B2_BUCKET"
  value       = b2_bucket.flux_config.bucket_name
}

resource "github_actions_secret" "b2_endpoint" {
  repository  = var.github_repository
  secret_name = "B2_ENDPOINT"
  value       = local.b2_s3_endpoint
}

resource "github_actions_secret" "b2_region" {
  repository  = var.github_repository
  secret_name = "B2_REGION"
  value       = var.b2_region
}

resource "github_actions_secret" "b2_key_id" {
  repository  = var.github_repository
  secret_name = "B2_KEY_ID"
  value       = b2_application_key.github_actions.application_key_id
}

resource "github_actions_secret" "b2_application_key" {
  repository  = var.github_repository
  secret_name = "B2_APPLICATION_KEY"
  value       = b2_application_key.github_actions.application_key
}

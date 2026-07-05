output "namespace" {
  description = "Namespace containing Flux controllers and bootstrap resources."
  value       = var.namespace
}

output "secret_name" {
  description = "Kubernetes Secret holding B2 read credentials."
  value       = kubernetes_secret.b2_credentials.metadata[0].name
}

output "flux_release_name" {
  description = "Helm release that installs Flux controllers and CRDs."
  value       = helm_release.flux2.name
}

output "bootstrap_release_name" {
  description = "Helm release that installs the Flux B2 source resources."
  value       = helm_release.iron_bootstrap.name
}

output "bucket_source_name" {
  description = "Flux Bucket source name."
  value       = var.bucket_source_name
}

output "kustomization_name" {
  description = "Flux Kustomization name."
  value       = var.kustomization_name
}

output "b2_prefix" {
  description = "B2 object prefix consumed by Flux."
  value       = local.b2.flux_b2_prefix
}

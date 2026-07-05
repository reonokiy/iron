output "cluster_id" {
  description = "Civo Kubernetes cluster ID."
  value       = civo_kubernetes_cluster.iron.id
}

output "cluster_name" {
  description = "Civo Kubernetes cluster name."
  value       = civo_kubernetes_cluster.iron.name
}

output "cluster_status" {
  description = "Civo Kubernetes cluster status."
  value       = civo_kubernetes_cluster.iron.status
}

output "cluster_ready" {
  description = "Whether Civo reports the Kubernetes cluster as ready."
  value       = civo_kubernetes_cluster.iron.ready
}

output "api_endpoint" {
  description = "Kubernetes API endpoint."
  value       = civo_kubernetes_cluster.iron.api_endpoint
}

output "dns_entry" {
  description = "Civo DNS entry for the Kubernetes cluster."
  value       = civo_kubernetes_cluster.iron.dns_entry
}

output "master_ip" {
  description = "Civo Kubernetes master IP."
  value       = civo_kubernetes_cluster.iron.master_ip
}

output "network_id" {
  description = "Civo network ID used by the cluster."
  value       = local.network_id
}

output "firewall_id" {
  description = "Civo firewall ID used by the cluster."
  value       = local.firewall_id
}

output "node_pool_instance_names" {
  description = "Instance names in the managed node pool."
  value       = civo_kubernetes_cluster.iron.pools[0].instance_names
}

output "kubeconfig_path" {
  description = "Local kubeconfig path written by Terraform."
  value       = local_sensitive_file.kubeconfig.filename
}

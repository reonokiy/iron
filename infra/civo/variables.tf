variable "cluster_name" {
  description = "Civo Kubernetes cluster name."
  type        = string
  default     = "iron"
}

variable "civo_region" {
  description = "Civo region for the Kubernetes cluster."
  type        = string
  default     = "phx1"
}

variable "cluster_type" {
  description = "Civo Kubernetes cluster type. Valid values are k3s or talos."
  type        = string
  default     = "k3s"

  validation {
    condition     = contains(["k3s", "talos"], var.cluster_type)
    error_message = "cluster_type must be either k3s or talos."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version to install. Null lets Civo choose the current default."
  type        = string
  default     = null
}

variable "cni" {
  description = "CNI to install for k3s clusters. Null lets Civo choose the default."
  type        = string
  default     = null

  validation {
    condition     = var.cni == null || contains(["cilium", "flannel"], var.cni)
    error_message = "cni must be null, cilium, or flannel."
  }
}

variable "applications" {
  description = "Comma-separated Civo marketplace applications to install during cluster creation."
  type        = string
  default     = null
}

variable "network_id" {
  description = "Existing Civo network ID to use. Null creates and manages a network."
  type        = string
  default     = null
}

variable "network_label" {
  description = "Label for the managed Civo network when network_id is null."
  type        = string
  default     = "iron"
}

variable "firewall_id" {
  description = "Existing Civo firewall ID to use. Null creates and manages a firewall."
  type        = string
  default     = null

  validation {
    condition     = var.firewall_id == null || var.network_id != null
    error_message = "network_id must be set when firewall_id is set so the cluster and firewall use the same existing network."
  }
}

variable "firewall_name" {
  description = "Name for the managed Civo firewall when firewall_id is null."
  type        = string
  default     = "iron-k8s"
}

variable "firewall_create_default_rules" {
  description = "Whether Civo should create the provider default firewall rules."
  type        = bool
  default     = true
}

variable "node_pool_label" {
  description = "Label for the primary Civo Kubernetes node pool."
  type        = string
  default     = "main"
}

variable "node_size" {
  description = "Civo Kubernetes node size."
  type        = string
  default     = "g4s.kube.xsmall"
}

variable "node_count" {
  description = "Number of nodes in the primary node pool."
  type        = number
  default     = 3
}

variable "public_ip_node_pool" {
  description = "Whether the primary node pool should belong to the public IP node pool."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to attach to the Civo Kubernetes cluster."
  type        = list(string)
  default     = ["terraform", "iron"]
}

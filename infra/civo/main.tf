resource "civo_network" "iron" {
  count = var.network_id == null ? 1 : 0

  label  = var.network_label
  region = var.civo_region
}

resource "civo_firewall" "iron" {
  count = var.firewall_id == null ? 1 : 0

  name                 = var.firewall_name
  network_id           = local.network_id
  region               = var.civo_region
  create_default_rules = var.firewall_create_default_rules
}

resource "civo_kubernetes_cluster" "iron" {
  name               = var.cluster_name
  region             = var.civo_region
  cluster_type       = var.cluster_type
  kubernetes_version = var.kubernetes_version
  cni                = var.cni
  applications       = var.applications
  network_id         = local.network_id
  firewall_id        = local.firewall_id
  tags               = local.tags
  write_kubeconfig   = false

  pools {
    label               = var.node_pool_label
    size                = var.node_size
    node_count          = var.node_count
    public_ip_node_pool = var.public_ip_node_pool
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

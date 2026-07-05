locals {
  network_id  = var.network_id != null ? var.network_id : civo_network.iron[0].id
  firewall_id = var.firewall_id != null ? var.firewall_id : civo_firewall.iron[0].id
  tags        = length(var.tags) > 0 ? join(" ", var.tags) : null
}

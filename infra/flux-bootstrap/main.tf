resource "helm_release" "flux2" {
  name             = "flux2"
  repository       = var.flux_chart_repository
  chart            = "flux2"
  version          = var.flux_chart_version
  namespace        = var.namespace
  create_namespace = true
  atomic           = true
  wait             = true
  timeout          = 600

  values = [
    yamlencode({
      installCRDs        = var.flux_install_crds
      logLevel           = var.flux_log_level
      watchAllNamespaces = var.flux_watch_all_namespaces

      imageAutomationController = {
        create = var.flux_image_controllers_enabled
      }
      imageReflectionController = {
        create = var.flux_image_controllers_enabled
      }
    }),
  ]
}

resource "kubernetes_secret" "b2_credentials" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
  }

  data = {
    accesskey = local.b2.flux_b2_key_id
    secretkey = local.b2.flux_b2_application_key
  }

  type = "Opaque"

  depends_on = [
    helm_release.flux2,
  ]
}

resource "helm_release" "iron_bootstrap" {
  name      = "iron-flux-bootstrap"
  chart     = "${path.module}/charts/iron-flux-bootstrap"
  namespace = var.namespace
  atomic    = true
  wait      = true
  timeout   = 300

  values = [
    yamlencode({
      secret = {
        name = var.secret_name
      }

      bucket = {
        name       = var.bucket_source_name
        provider   = "generic"
        interval   = var.bucket_interval
        bucketName = local.b2.flux_b2_bucket
        endpoint   = local.b2.flux_b2_endpoint
        region     = local.b2.flux_b2_region
        prefix     = local.b2.flux_b2_prefix
        timeout    = var.bucket_timeout
      }

      kustomization = {
        name          = var.kustomization_name
        interval      = var.kustomization_interval
        retryInterval = var.kustomization_retry_interval
        timeout       = var.kustomization_timeout
        path          = var.kustomization_path
        prune         = true
        wait          = true
      }
    }),
  ]

  depends_on = [
    helm_release.flux2,
    kubernetes_secret.b2_credentials,
  ]
}

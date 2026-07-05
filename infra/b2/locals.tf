locals {
  b2_s3_endpoint = coalesce(var.b2_s3_endpoint, "s3.${var.b2_region}.backblazeb2.com")

  github_actions_capabilities = [
    "listBuckets",
    "listFiles",
    "readFiles",
    "writeFiles",
  ]

  flux_read_capabilities = [
    "listBuckets",
    "listFiles",
    "readFiles",
  ]
}

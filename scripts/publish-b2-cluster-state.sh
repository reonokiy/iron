#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: publish-b2-cluster-state.sh [--source clusters/iron] [--prefix clusters/iron] [--revision REV] [--dry-run]

Renders the cluster kustomization to one YAML object and publishes it to B2.
Each release is written under a revisioned path first. The stable B2
kustomization entrypoint is uploaded last, so Flux only switches after the
complete rendered object is present.

Required environment variables:

  B2_BUCKET
  B2_ENDPOINT
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION
EOF
}

source_dir="clusters/iron"
prefix="clusters/iron"
revision="${GITHUB_SHA:-}"
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      source_dir="${2:-}"
      shift 2
      ;;
    --prefix)
      prefix="${2:-}"
      shift 2
      ;;
    --revision)
      revision="${2:-}"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

required_env() {
  local name="$1"

  if [[ -z "${!name:-}" ]]; then
    echo "Missing required environment variable: ${name}" >&2
    exit 1
  fi
}

if [[ -z "$source_dir" || -z "$prefix" ]]; then
  echo "source and prefix must not be empty." >&2
  exit 1
fi

prefix="${prefix%/}"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

publish_dir="${work_dir}/${prefix}"
mkdir -p "$publish_dir"

kubectl kustomize "$source_dir" >"${work_dir}/rendered.yaml"

if [[ -z "$revision" ]]; then
  revision="$(sha256sum "${work_dir}/rendered.yaml" | awk '{print $1}')"
fi

if [[ ! "$revision" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "revision may only contain letters, numbers, dots, underscores, and dashes." >&2
  exit 1
fi

release_dir="${publish_dir}/releases/${revision}"
mkdir -p "$release_dir"
cp "${work_dir}/rendered.yaml" "${release_dir}/rendered.yaml"

cat >"${publish_dir}/kustomization.yaml" <<'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
YAML
printf '  - releases/%s/rendered.yaml\n' "$revision" >>"${publish_dir}/kustomization.yaml"

if [[ "$dry_run" == true ]]; then
  kubectl kustomize "$publish_dir" >/dev/null
  echo "Rendered B2 publish bundle under ${publish_dir}"
  exit 0
fi

required_env B2_BUCKET
required_env B2_ENDPOINT
required_env AWS_ACCESS_KEY_ID
required_env AWS_SECRET_ACCESS_KEY
required_env AWS_DEFAULT_REGION

aws_common_args=(
  --endpoint-url "https://${B2_ENDPOINT}"
  --content-type text/yaml
  --no-progress
)

aws s3 cp \
  "${release_dir}/rendered.yaml" \
  "s3://${B2_BUCKET}/${prefix}/releases/${revision}/rendered.yaml" \
  "${aws_common_args[@]}"

aws s3 cp \
  "${publish_dir}/kustomization.yaml" \
  "s3://${B2_BUCKET}/${prefix}/kustomization.yaml" \
  "${aws_common_args[@]}"

echo "Published rendered cluster state revision ${revision} to s3://${B2_BUCKET}/${prefix}/kustomization.yaml"

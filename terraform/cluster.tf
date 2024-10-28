resource "helm_release" "cnpg" {
  name = "cloudnative-pg"

  repository = "https://cloudnative-pg.github.io/charts"
  chart      = "cloudnative-pg"
}

resource "kubectl_manifest" "cluster" {
  depends_on = [helm_release.cnpg]

  yaml_body = <<YAML
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cluster-pgsql
spec:
  instances: 3
  storage:
    size: 1Gi
YAML
}

resource "helm_release" "cnpg" {
  depends_on = [kind_cluster.cluster]

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
  imageName: ghcr.io/cloudnative-pg/postgresql:16.4
  instances: 3
  storage:
    size: 1Gi
  bootstrap:
    initdb:
      database: masuperbase
      owner: jcvd
YAML
}


resource "kubectl_manifest" "alpine_pod" {
  depends_on = [kind_cluster.cluster]

  yaml_body = <<YAML
apiVersion: v1
kind: Pod
metadata:
  name: alpine
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command: ['sh', '-c', 'apk update && apk add postgresql16-client && tail -f /dev/null']
YAML
}

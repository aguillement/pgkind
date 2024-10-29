resource "kind_cluster" "cluster" {
  name           = "postgres"
  wait_for_ready = true
}

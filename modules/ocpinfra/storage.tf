#################################################
# Block Storage for OCP Infrastructure  node
#################################################
resource "ibm_is_volume" "infra_docker_volume" {
  count          = "${var.infra_count}"
  name           = "${var.infra_docker_volume_prefix}-${random_id.random_name.hex}-${count.index}"
  profile        = "5iops-tier"
  zone           = "${var.cloud_zone}"
  capacity       = "${var.infra_docker_volume_size}"
  resource_group = "${var.resource_group}"
}

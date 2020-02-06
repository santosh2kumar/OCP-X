#################################################
# Block Storage for Worker node
#################################################
resource "ibm_is_volume" "worker_docker_volume" {
  count          = "${var.worker_count}"
  name           = "${var.worker_docker_volume_prefix}-${random_id.random_name.hex}-${count.index}"
  profile        = "5iops-tier"
  zone           = "${var.cloud_zone}"
  capacity       = "${var.worker_docker_volume_size}"
  resource_group = "${var.resource_group}"
}

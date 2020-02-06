#################################################
# Block Storage for Master node
#################################################
resource "ibm_is_volume" "master_docker_volume" {
  count          = "${var.master_count}"
  name           = "${var.master_docker_volume_prefix}-${random_id.random_name.hex}-${count.index}"
  profile        = "5iops-tier"
  zone           = "${var.cloud_zone}"
  capacity       = "${var.master_docker_volume_size}"
  resource_group = "${var.resource_group}"
}

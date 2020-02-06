##
##  Resource Definitions Associated with the OCP Worker Node
##
resource "random_id" "random_name" {
  byte_length = 4
}

#
# Define the ocp Worker node 
# --------------------------
resource "ibm_is_instance" "worker" {
    resource_group = "${var.resource_group}"
    depends_on  = ["ibm_is_volume.worker_docker_volume"]
    count       = "${var.worker_count}"
    name        = "${var.worker_hostname_prefix}-${var.worker_hostname}-${random_id.random_name.hex}-${count.index}"
    image       = "${var.worker_image_id}"
    profile     = "${var.worker_profile_id}"

    primary_network_interface = {
        subnet = "${var.vpc_subnet_id}"
    }

    vpc         = "${var.vpc_id}"
    zone        = "${var.cloud_zone}"
    keys        = ["${var.ssh_key_id}"]

    timeouts {
        create  = "90m"
        delete  = "30m"
    } # end of timeout
# attach a volume -- 
    volumes     = ["${element(ibm_is_volume.worker_docker_volume.*.id,count.index)}"]
} # end of resource def 

#
# Note: since we are running TF "outside" the GEN 2 cloud -- we need all VSIs to have an Floating IP assigned so that they can be connected to by TF
#
# Assign Floating IP to it
# -------------------------
resource "ibm_is_floating_ip" "worker_fip" {
    name        = "${var.worker_fip_name}-${count.index}"
    count       = "${var.worker_count}"
    target      = "${element(ibm_is_instance.worker.*.primary_network_interface.0.id,count.index)}"
    resource_group = "${var.resource_group}"
}
#

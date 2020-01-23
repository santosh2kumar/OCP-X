##
##  Resource Definitions Associated with the OCP infrastructure  Node
##
resource "random_id" "random_name" {
  byte_length = 4
}

#
# Define the ocp infra node 
# --------------------------
resource "ibm_is_instance" "infra" {
    depends_on  = ["ibm_is_volume.infra_docker_volume"]
    count       = "${var.infra_count}"
    name        = "${var.infra_hostname_prefix}-${var.infra_hostname}-${random_id.random_name.hex}-${count.index}"
    image       = "${var.infra_image_id}"
    profile     = "${var.infra_profile_id}"

    primary_network_interface = {
        subnet  = "${var.vpc_subnet_id}"
    }

    vpc         = "${var.vpc_id}"
    zone        = "${var.cloud_zone}"
    keys        = ["${var.ssh_key_id}"]

    timeouts {
        create  = "90m"
        delete  = "30m"
    } # end of timeout
# attach a volume -- 
    volumes     = ["${element(ibm_is_volume.infra_docker_volume.*.id,count.index)}"]
} # end of resource def 

#
# Note: since we are running TF "outside" the GEN 2 cloud -- we need all VSIs to have an Floating IP assigned so that they can be connected to by TF
#
# Assign Floating IP to it
# -------------------------
resource "ibm_is_floating_ip" "infra_fip" {
    name        = "${var.infra_fip_name}-${count.index}"
    count       = "${var.infra_count}"
    target      = "${element(ibm_is_instance.infra.*.primary_network_interface.0.id,count.index)}"
}
#

##
##  Resource Definitions Associated with the OCP Master Node
##
resource "random_id" "random_name" {
  byte_length = 4
}

#
# Define the ocp master node 
# --------------------------
resource "ibm_is_instance" "master" {
    depends_on  = ["ibm_is_volume.master_docker_volume"]
    count       = "${var.master_count}"
    name        = "${var.master_hostname_prefix}-${var.master_hostname}-${random_id.random_name.hex}-${count.index}"
    image       = "${var.master_image_id}"
    profile     = "${var.master_profile_id}"

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
    volumes     = ["${element(ibm_is_volume.master_docker_volume.*.id,count.index)}"]
} # end of resource def 

#
# Note: since we are running TF "outside" the GEN 2 cloud -- we need all VSIs to have an Floating IP assigned so that they can be connected to by TF
#
# Assign Floating IP to it
# -------------------------
resource "ibm_is_floating_ip" "master_fip" {
    name        = "${var.master_fip_name}-${count.index}"
    count       = "${var.master_count}"
    target      = "${element(ibm_is_instance.master.*.primary_network_interface.0.id,count.index)}"
}
#

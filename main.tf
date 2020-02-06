#
# This is the "top level" 
#
##
# Establish some common resources
#

##
module "VirtualPrivateCloud" {
    source              = "./modules/VPC"
    cloud_zone          = "${var.ibmcloud_zone}"
    vpc_name            = "${var.vpc_name}"
    subnet_name         = "${var.subnet_name}"
    public_ssh_key      = "${var.public_ssh_string}"
    ssh_key_label       = "${var.ssh_key_label}"
    ipv4_cidr_block     = "${var.ipv4_cidr_block}"
    resource_group      = "${var.resource_group}"
}

#
# Create the OCP Master Node(s) 
#
module "OCPmaster_node"  {
    source                      = "./modules/ocpmaster"
    cloud_zone                  = "${var.ibmcloud_zone}"
    master_count                = "${var.master["count"]}"
    master_hostname_prefix      = "${var.hostname_prefix}"
    master_hostname             = "${var.master["name"]}"
    master_image_id             = "${var.image_id}"
    master_profile_id           = "${var.master["profile_id"]}"
    master_fip_name             = "${var.master["fip_name"]}"
    master_docker_volume_prefix = "${var.docker_volume_prefix}-master"
    master_docker_volume_size   = "${var.docker_volume_size}"
    vpc_id                      = "${module.VirtualPrivateCloud.vpc_id}"
    vpc_subnet_id               = "${module.VirtualPrivateCloud.vpc_subnet_id}"
    ssh_key_id                  = "${module.VirtualPrivateCloud.ssh_key_id}"
    resource_group              = "${var.resource_group}"
}

#
# Create the OCP Infrastructure  Node(s) 
#
module "OCPinfra_node"  {
    source                      = "./modules/ocpinfra"
    cloud_zone                  = "${var.ibmcloud_zone}"
    infra_count                 = "${var.infra["count"]}"
    infra_hostname_prefix       = "${var.hostname_prefix}"
    infra_hostname              = "${var.infra["name"]}"
    infra_image_id              = "${var.image_id}"
    infra_profile_id            = "${var.infra["profile_id"]}"
    infra_fip_name              = "${var.infra["fip_name"]}"
    infra_docker_volume_prefix  = "${var.docker_volume_prefix}-infra"
    infra_docker_volume_size    = "${var.docker_volume_size}"
    vpc_id                      = "${module.VirtualPrivateCloud.vpc_id}"
    vpc_subnet_id               = "${module.VirtualPrivateCloud.vpc_subnet_id}"
    ssh_key_id                  = "${module.VirtualPrivateCloud.ssh_key_id}"
    resource_group              = "${var.resource_group}"
}

#
# Create the OCP Worker Node(s) 
#
module "OCPworker_node"  {
    source                      = "./modules/ocpworker"
    cloud_zone                  = "${var.ibmcloud_zone}"
    worker_count                = "${var.worker["count"]}"
    worker_hostname_prefix      = "${var.hostname_prefix}"
    worker_hostname             = "${var.worker["name"]}"
    worker_image_id             = "${var.image_id}"
    worker_profile_id           = "${var.worker["profile_id"]}"
    worker_fip_name             = "${var.worker["fip_name"]}"
    worker_docker_volume_prefix = "${var.docker_volume_prefix}-worker"
    worker_docker_volume_size   = "${var.docker_volume_size}"
    vpc_id                      = "${module.VirtualPrivateCloud.vpc_id}"
    vpc_subnet_id               = "${module.VirtualPrivateCloud.vpc_subnet_id}"
    ssh_key_id                  = "${module.VirtualPrivateCloud.ssh_key_id}"
    resource_group              = "${var.resource_group}"
}

#
module "OCPPrepare_nodes"  {
    source                      = "./modules/ocpprepare"
    master_count                = "${var.master["count"]}"
    master_private_ips          = "${module.OCPmaster_node.master_private_ip}"
    master_public_ips           = "${module.OCPmaster_node.master_public_ip}"
    master_hosts                = "${module.OCPmaster_node.master_hostname}"
    infra_count                 = "${var.infra["count"]}"
    infra_private_ips           = "${module.OCPinfra_node.infra_private_ip}"
    infra_public_ips            = "${module.OCPinfra_node.infra_public_ip}"
    infra_hosts                 = "${module.OCPinfra_node.infra_hostname}"
    worker_count                = "${var.worker["count"]}"
    worker_private_ips          = "${module.OCPworker_node.worker_private_ip}"
    worker_public_ips           = "${module.OCPworker_node.worker_public_ip}"
    worker_hosts                = "${module.OCPworker_node.worker_hostname}"
    domain_name                 = "${var.domain_name}"
    private_ssh_key             = "${var.private_ssh_string}"
    public_ssh_key              = "${var.public_ssh_string}"
    rhel_subscription_username  = "${var.rhel_subscription_username}"
    rhel_subscription_password  = "${var.rhel_subscription_password}"
    subscription_pool_list      = "${var.subscription_pool_list}"
    docker_volume_size          = "${var.docker_volume_size}"
}

#
module "OCPInstall_ocp"  {
    source                      = "./modules/ocpinstall"
    master_count                = "${var.master["count"]}"
    prepare_complete            = "${module.OCPPrepare_nodes.prepare_complete}"
    master_public_ips           = "${module.OCPmaster_node.master_public_ip}"
    master_hostname             = "${element(module.OCPmaster_node.master_hostname, 0)}"
    rhel_username               = "${var.rhel_username}"
    private_ssh_key             = "${var.private_ssh_string}"
    public_ssh_key              = "${var.public_ssh_string}"
    ocp_admin_username          = "${var.ocp_admin_username}"
    ocp_admin_password          = "${var.ocp_admin_password}"
}

#
# Cloud Related 
#
ibmcloud_api_key    = "myIBMCloudAPIKey"
ibmcloud_generation = "2"
ibmcloud_region     = "us-south"
ibmcloud_zone       = "us-south-3"

#
# VPC Related 
#
vpc_name            = "yussuf-tf-pvc"
subnet_name         = "yussuf-tf-sn"
ipv4_cidr_block     = "10.240.128.0/24"

resource_group      = "default"
# this is the corresponding private key file to be used for the SSH
# Public key path is calculated as ${private_ssh_key}.pub
private_ssh_key     = "id_rsa" 
ssh_key_label       = "yussuf-tfssh"
rhel_username       = "root"

# VSI Common
image_id            = "9a6aed49-d4f7-4464-9056-0e0223d2a2f0"
hostname_prefix     = "yussuf"
docker_volume_prefix = "yussuf-vol"
docker_volume_size  = "50"

#
#
master = {name = "master", profile_id = "bx2-2x8", fip_name = "master-x-fip", count = "1"}
infra = {name = "infra", profile_id = "bx2-2x8", fip_name = "infra-x-fip", count = "1"}
worker = {name = "worker", profile_id = "bx2-2x8", fip_name = "worker-x-fip", count = "1"}
domain_name = "IBM-OpenShift.cloud"

# RHEL Registeration
rhel_subscription_username  = ""
rhel_subscription_password  = ""
subscription_pool_list      = ["mysubscriptionpoolID"]

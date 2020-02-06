
variable "master_hostname" {
    default = "def_in_ocpinstall"
}

variable "master_count" {
    default = "1"
}

variable "master_public_ips" {
    type = "list"
    default = []
}

variable "prepare_complete" {
    default = "false"
}

variable "rhel_username" {
    default = "root"
}

variable "private_ssh_key" {
    default = "id_rsa"
}

variable "public_ssh_key" {
    default = "public_key"
}

variable "ocp_admin_username" {
    default = "admin"
}

variable "ocp_admin_password" {
    default = "test123"
}

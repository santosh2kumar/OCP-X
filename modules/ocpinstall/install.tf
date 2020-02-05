#################################################
# Install Openshift
#################################################

resource "null_resource" "deploy_cluster_wait" {
    provisioner "local-exec" {
        command = "echo Preparation status is ${var.prepare_complete}"
    }
}
#
# Kick off the Ansible playbooks - on the primary master only --  that will install OCP
#
# Give this step plenty of time (timeout) because depending on the number of nodes being initialized, it may take longer
#
#
resource "null_resource" "deploy_cluster" {
    depends_on = ["null_resource.deploy_cluster_wait"]

    connection {
        type        = "ssh"
        #user        = "${var.rhel_username}"
        user        = "root"
        host        = "${element(var.master_public_ips,0)}"
        private_key = "${var.private_ssh_key}"
        agent       = "false"
        timeout     = "60m"
    }

    provisioner "remote-exec" {
        inline = [
            "ansible-playbook -i ~/inventory.cfg /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml",
            "ansible-playbook -i ~/inventory.cfg /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml",
        ]
    }
}

#################################################
# Perform post-install configurations for Openshift
#
# (1) set the OCP console login  user / password on all masters 
#
#
##  
#################################################
resource "null_resource" "post_deploy_cluster" {
    depends_on      = ["null_resource.deploy_cluster"]
    count           = "${var.master_count}"

    connection {
        type        = "ssh"
        #user       = "${var.rhel_username}"
        user        = "root"
        host        = "${element(var.master_public_ips,count.index)}"
        private_key = "${var.private_ssh_key}"
        agent       = "false"
        timeout     = "15m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /etc/origin/master",
            "sudo htpasswd -cb /etc/origin/master/htpasswd ${var.ocp_admin_username} ${var.ocp_admin_password}",
        ]
    }
}

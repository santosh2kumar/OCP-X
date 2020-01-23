
data "template_file" "rhel_init" {
    template = "${file("${path.module}/scripts/prepare.tpl")}"

    vars {
        rhel_user_name          = "${var.rhel_subscription_username}"
        rhel_password           = "${var.rhel_subscription_password}"
        subscription_pool_list  = "${join(" ",var.subscription_pool_list)}"
        docker_volume_size      = "${var.docker_volume_size}"
        }
}

resource "null_resource" "rhel_init" {
    count           = "${var.master_count + var.infra_count + var.worker_count}"
    connection {
        type        = "ssh"
        #user        = "${var.rhel_username}"
        user        = "root"
        host        = "${element(concat(var.master_public_ips,var.infra_public_ips,var.worker_public_ips),count.index)}"
        private_key = "${file(var.private_ssh_key)}"
        agent       = "false"
        timeout     = "60m"
    }
    provisioner "file" {
        source      = "${var.private_ssh_key}.pub"
        destination = "$HOME/.ssh/id_rsa.pub"
    }
    provisioner "file" {
        source      = "${var.private_ssh_key}"
        destination = "$HOME/.ssh/id_rsa"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod 600 $HOME/.ssh/id_rsa",
        ]
    }
    provisioner "remote-exec" {
        inline = [
            "${data.template_file.rhel_init.rendered}",
        ]
    }
    provisioner "remote-exec" {
        on_failure = "continue"
        inline = [
            "sudo systemctl reboot"
        ]
    }
    provisioner "remote-exec" {
        when = "destroy"
        inline = [
            "sudo subscription-manager unregister",
            "sudo subscription-manager remove --all",
        ]
    }
    # Populate /etc/hosts file
    provisioner "file" {
        content     = "${join("\n", concat(data.template_file.master_host_file_template.*.rendered, data.template_file.infra_host_file_template.*.rendered, data.template_file.worker_host_file_template.*.rendered))}"
        destination = "/etc/hosts"
    }
}

resource "null_resource" "openshift_init" {
    depends_on    = ["null_resource.rhel_init"]
    count           = "1"
    connection {
        type        = "ssh"
        #user        = "${var.rhel_username}"
        user        = "root"
        host        = "${element(var.master_public_ips, 0)}"
        private_key = "${file(var.private_ssh_key)}"
        agent       = "false"
        timeout     = "60m"
    }
    # Populate inventory file
    provisioner "file" {
        content     = "${data.template_file.ose_inventory.rendered}"
        destination = "~/inventory.cfg"
    }
}

# Create inventory file
data "template_file" "master_block" {
    count       = "${var.master_count}"
    template    = "$${master_hostname} openshift_ip=$${master_ip} openshift_node_group_name='node-config-master'"
    vars {
        master_ip       = "${element(var.master_private_ips, count.index)}"
        master_hostname = "${element(var.master_hosts, count.index)}.${var.domain_name}"
    }
}

data "template_file" "infra_block" {
    count       = "${var.infra_count}"
    template    = "$${infra_hostname} openshift_ip=$${infra_ip} openshift_node_group_name='node-config-infra'"
    vars {
        infra_ip        = "${element(var.infra_private_ips, count.index)}"
        infra_hostname  = "${element(var.infra_hosts, count.index)}.${var.domain_name}"
    }
}

data "template_file" "compute_block" {
    count       = "${var.worker_count}"
    template    = "$${worker_hostname} openshift_ip=$${worker_ip} openshift_node_group_name='node-config-compute'"
    vars {
        worker_ip       = "${element(var.worker_private_ips, count.index)}"
        worker_hostname = "${element(var.worker_hosts, count.index)}.${var.domain_name}"
    }
}

# Create the new Inventory file with master node info.
data "template_file" "ose_inventory" {
    template    = "${file("${path.module}/scripts/inventory.cfg.tpl")}"
    vars {
        master_block    = "${join("\n", data.template_file.master_block.*.rendered)}"
        compute_block   = "${join("\n", data.template_file.compute_block.*.rendered)}"
        infra_block     = "${join("\n", data.template_file.infra_block.*.rendered)}"
#bps test 11/01        master_hostname = "${element(var.master_hosts, 0)}.${element(var.master_public_ips, 0)}.nip.io"
        master_hostname = "${element(var.master_hosts, 0)}"
        master_hn_only  = "${element(var.master_hosts, 0)}"
#bps test 11/01        subdomain       = "apps.${element(var.master_hosts, 0)}.${element(var.master_public_ips, 0)}.nip.io"
        subdomain       = "apps.${element(var.master_hosts, 0)}"
        rhn_username    = "${var.rhel_subscription_username}"
        rhn_password    = "${var.rhel_subscription_password}"
        domain_name     = "${var.domain_name}"
        cc_hostname     = "${element(var.infra_hosts, 0)}.${var.domain_name}"
  }
}

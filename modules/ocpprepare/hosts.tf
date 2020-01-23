# Create host file
data "template_file" "master_host_file_template" {
    count       = "${var.master_count}"
    template    = "$${master_ip} $${master_hostname} $${master_hostname_domain} "
    vars {
        master_ip               = "${element(var.master_private_ips, count.index)}"
        master_hostname         = "${element(var.master_hosts, count.index)}"
        master_hostname_domain  = "${element(var.master_hosts, count.index)}.${var.domain_name}"
    }
}

data "template_file" "infra_host_file_template" {
    count       = "${var.infra_count}"
    template    = "$${infra_ip} $${infra_hostname} $${infra_hostname_domain} "
    vars {
        infra_ip                = "${element(var.infra_private_ips, count.index)}"
        infra_hostname          = "${element(var.infra_hosts, count.index)}"
        infra_hostname_domain   = "${element(var.infra_hosts, count.index)}.${var.domain_name}"
    }
}

data "template_file" "worker_host_file_template" {
    count       = "${var.worker_count}"
    template    = "$${worker_ip} $${worker_hostname} $${worker_hostname_domain} "
    vars {
        worker_ip               = "${element(var.worker_private_ips, count.index)}"
        worker_hostname         = "${element(var.worker_hosts, count.index)}"
        worker_hostname_domain  = "${element(var.worker_hosts, count.index)}.${var.domain_name}"
    }
}

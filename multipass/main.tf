locals {
  kube_pki = yamldecode(file("killer-sh-cks/pki.yaml")).pki
  cluster_certs = {
    for clusters, certs in local.kube_pki : clusters => certs
    if clusters == var.cluster_name
  }

  cloud_init_vars = {
    cks_killer_enable = var.cks_killer_enable
    cluster_certs     = local.cluster_certs
    ssh_key           = var.ssh_key
    hostname          = var.name
    cluster_name      = var.cluster_name
    role              = var.role
    fqdn              = "${var.name}.${var.domain_name}"
    image             = var.image
    k8s_version       = var.k8s_version
  }
  user_data = templatefile("scripts/cloud-init.yaml", local.cloud_init_vars)
}

resource "local_file" "cloud_init" {
  content  = local.user_data
  filename = "scripts/init/cloud_init_${var.name}.yaml"
}

resource "shell_script" "cluster_instance" {
  lifecycle_commands {
    create = "scripts/create.py"
    delete = "scripts/delete.py"
  }
  environment = {
    MULTIPASS_NAME  = var.name
    MULTIPASS_MEM   = var.mem
    MULTIPASS_DISK  = var.disk
    MULTIPASS_CPU   = var.cpu
    MULTIPASS_IMAGE = var.image
    #recreates on cloud init change
    cloud_init = base64encode(local_file.cloud_init.content)

  }
  interpreter = ["/usr/bin/python3", ]

  depends_on = [local_file.cloud_init]
}

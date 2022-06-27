resource "null_resource" "restore_cluster" {
  for_each = {
    for controllers, values in local.instances : controllers => values.hostname
    if values.role == "controller" && local.environment.restore_cluster == true
  }
  triggers = {
    controller_name = each.key
    cluster_name    = local.server[each.key].cluster_name
  }

  provisioner "local-exec" {
    command     = <<-EOT
    multipass transfer cluster-data/${self.triggers.cluster_name}.tar.gz \
    ${self.triggers.controller_name}:${self.triggers.cluster_name}.tar.gz
    EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [module.multipass, null_resource.join_workers]
}

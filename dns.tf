resource "null_resource" "etc_hosts" {
  for_each = local.server
  triggers = {
    name      = each.key
    etc_hosts = local.etc_hosts
  }

  provisioner "local-exec" {
    command     = <<-EOT
    multipass exec ${each.key} -- sh -c  "echo '${local.etc_hosts}' | sudo tee /etc/hosts"
    EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [module.multipass, null_resource.init_controllers, null_resource.join_workers, null_resource.restore_cluster]
}

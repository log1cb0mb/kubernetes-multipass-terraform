resource "null_resource" "local_dns" {
  triggers = {
    name        = var.name
    ip          = shell_script.cluster_instance.output.ip
    domain_name = var.domain_name
  }
  provisioner "local-exec" {
    command     = "echo ${shell_script.cluster_instance.output.ip} ${var.name}.${var.domain_name} | sudo tee -a /etc/hosts > /dev/null"
    interpreter = ["bash", "-c"]
  }
  provisioner "local-exec" {
    when    = destroy
    command = "sudo sed -i '' '/${self.triggers.name}.${self.triggers.domain_name}/d' /etc/hosts"
  }
}

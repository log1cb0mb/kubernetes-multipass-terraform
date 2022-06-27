resource "null_resource" "init_controllers" {
  for_each = {
    for controllers, values in local.instances : controllers => values.hostname
    if values.role == "controller"
  }
  triggers = {
    controller_name = each.key
    cluster_name    = local.server[each.key].cluster_name
  }

  provisioner "local-exec" {
    command     = <<-EOT
    multipass exec ${self.triggers.controller_name} -- \
    sh -c 'sudo kubeadm init --kubernetes-version=${local.environment.k8s_version}'
    multipass exec ${self.triggers.controller_name} -- \
    sh -c 'sudo cat $KUBECONFIG' > ./scripts/init/${self.triggers.cluster_name}.yaml
    multipass exec ${self.triggers.controller_name} -- \
    sh -c 'sudo kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=${local.environment.k8s_version}'
    EOT
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm ./scripts/init/${self.triggers.cluster_name}.yaml"
  }
  depends_on = [module.multipass]
}

resource "null_resource" "join_workers" {
  for_each = {
    for workers, values in local.instances : workers => values.hostname
    if values.role == "worker" && values.cluster_name == values.cluster_name
  }
  triggers = {
    worker_name  = each.key
    cluster_name = local.server[each.key].cluster_name
  }

  provisioner "local-exec" {
    command     = <<-EOT
    multipass exec ${self.triggers.worker_name} -- \
    sh -c "echo '$KUBECONFIG' | sudo tee /etc/kubernetes/admin.conf"
    multipass exec ${self.triggers.worker_name} -- \
    sh -c 'sudo echo $(sudo kubeadm token create --print-join-command) | sudo sh'
    EOT
    interpreter = ["bash", "-c"]
    environment = { KUBECONFIG = file("./scripts/init/${self.triggers.cluster_name}.yaml") }
  }
  depends_on = [null_resource.init_controllers]
}

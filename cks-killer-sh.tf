resource "null_resource" "cks_killer_env" {
  count = local.environment.cks_killer_enable ? 1 : 0
  triggers = {
    kubeconfig = local.kubeconfig
  }

  provisioner "local-exec" {
    command     = <<-EOT
    multipass exec terminal -- sh -c "mkdir .kube"
    multipass exec terminal -- sh -c "echo '${local.kubeconfig}' | tee .kube/config  > /dev/null"
    multipass transfer killer-sh-cks/cluster1-db.tar.gz cluster1-master1:cluster1-db.tar.gz
    multipass transfer killer-sh-cks/cluster2-db.tar.gz cluster2-master1:cluster2-db.tar.gz
    EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [null_resource.join_workers]
}

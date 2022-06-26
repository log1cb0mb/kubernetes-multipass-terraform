locals {
  environment = yamldecode(file("config.yaml")).environment
  server      = yamldecode(file("config.yaml")).servers
  instances = {
    for instance, name in module.multipass : instance => name
  }

  etc_hosts_vars = {
    instances         = local.instances
    cks_killer_enable = try(local.environment.cks_killer_enable != "", false) ? local.environment.cks_killer_enable : false
    terminal_ip       = try(local.instances["terminal"].ip != "", false) ? local.instances["terminal"].ip : ""
    ingress_ip        = try(local.instances["cluster1-worker1"].ip != "", false) ? local.instances["cluster1-worker1"].ip : ""
  }
  kubeconfig_vars = {
    cluster1_api_ip = try(local.instances["cluster1-master1"].ip != "", false) ? local.instances["cluster1-master1"].ip : ""
    cluster2_api_ip = try(local.instances["cluster2-master1"].ip != "", false) ? local.instances["cluster2-master1"].ip : ""
  }
  etc_hosts  = templatefile("scripts/hosts.tpl", local.etc_hosts_vars)
  kubeconfig = sensitive(templatefile("killer-sh-cks/kubeconfig.yaml", local.kubeconfig_vars))
}

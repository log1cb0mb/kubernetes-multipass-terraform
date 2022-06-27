locals {
  environment = yamldecode(file("config.yaml")).environment
  server      = yamldecode(file("config.yaml")).servers
  instances = {
    for instance, name in module.multipass : instance => name
  }

  etc_hosts_vars = {
    instances         = local.instances
  }
  etc_hosts  = templatefile("scripts/hosts.tpl", local.etc_hosts_vars)
}

module "multipass" {
  source            = "./multipass"
  name              = each.key
  for_each          = local.server
  role              = try(local.server[each.key].role != "", false) ? local.server[each.key].role : var.role
  cpu               = try(local.server[each.key].cpu != "", false) ? local.server[each.key].cpu : var.cpu
  mem               = try(local.server[each.key].mem != "", false) ? local.server[each.key].mem : var.mem
  disk              = try(local.server[each.key].disk != "", false) ? local.server[each.key].disk : var.disk
  cluster_name      = try(local.server[each.key].cluster_name != "", false) ? local.server[each.key].cluster_name : var.cluster_name
  domain_name       = try(local.server[each.key].domain_name != "", false) ? local.server[each.key].domain_name : var.domain_name
  image             = try(local.server[each.key].image != "", false) ? local.server[each.key].image : var.image
  k8s_version       = try(local.environment.k8s_version != "", false) ? local.environment.k8s_version : var.k8s_version
  restore_cluster   = try(local.environment.restore_cluster != "", false) ? local.environment.restore_cluster : var.restore_cluster
  ssh_key           = try(local.environment.ssh_key != "", false) ? local.environment.ssh_key : var.ssh_key
}

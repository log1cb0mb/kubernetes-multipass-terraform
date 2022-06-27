output "ip" {
  value = shell_script.cluster_instance.output.ip
}

output "hostname" {
  value = shell_script.cluster_instance.output.name
}

output "role" {
  value = var.role
}

output "cluster_name" {
  value = var.cluster_name
}

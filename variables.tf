
variable "cpu" {
  default = "2"
}
variable "mem" {
  default = "2G"
}
variable "disk" {
  default = "8G"
}
variable "domain_name" {
  default = "multipass"
}
variable "image" {
  default = "20.04"
}
variable "k8s_version" {
  default = "1.23.1"

}
variable "cluster_name" {
  default = ""

}
variable "restore_cluster" {
  default = false
}
variable "ssh_key" {
  default = ""

}
variable "role" {
  default = ""

}

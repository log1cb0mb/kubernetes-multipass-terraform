# killer-multipass-terraform

An easy declarative way to spin up Kubernetes clusters on Multipass Ubuntu instances using Terraform. The project also includes an option to spin up a Killer-Shell CKS Exam Simulator environment. Included in project: CKS 1.23 version but users who have access to their exam simulator can retrieve data from clusters in simulator and spin up local clusters using this project.

The logic used for bringing up kubernetes clusters running CKS Killer Shell environment can essentially be applied to restoring any kubernetes cluster data. There may be some changes required depending on the target kubernetes cluster envrionment for e.g environment specific kubernetes parameters.

## Requirements

- Terraform
- Multipass
- Python

## Required config sample

```yaml
environment:
  k8s_version: "1.23.1"
  cks_killer_enable: true # Bring up CKS Killer-sh kubernetes environment
  ssh_key: "<ssh public key for instances>"
servers:
  # Instances naming mutually exclusive to cks_killer_enable  environment
  # For self-manage instances/kubernetes environment
  # (cks_killer_enable not defined or false), instance names can be any
  cluster1-master1:
    cluster_name: cluster1
    role: controller
    image: 20.04
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
  cluster1-worker1:
    cluster_name: cluster1
    role: worker
    image: 20.04
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
  cluster1-worker2:
    cluster_name: cluster1
    role: controller
    image: 20.04
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
  cluster2-master1:
    cluster_name: cluster2
    role: controller
    image: 20.04
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
  cluster2-worker1:
    cluster_name: cluster2
    role: worker
    image: 20.04
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
  terminal:
    role: bastion
    cpu: 2
    mem: 2G
    disk: 5G
    domain_name: whatever
```

## CKS Killer Shell Instructions

## TODO

- Update readme
- ~~Install Falco and AppArmor~~
- Change packages arch to be more general instead of ARM
- Setup gviser/runsc
- Setup docker registry on bastion host
- Load private registry images used in environment
- Fix pod network connectivity issue with killer-sh environment
- Add feature for HA control plane

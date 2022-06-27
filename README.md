# killer-multipass-terraform

An easy declarative way to spin up Kubernetes clusters on Multipass Ubuntu instances using Terraform. The project also includes an option to spin up a Killer-Shell CKS Exam Simulator environment. Included in project: CKS 1.23 version but users who have access to their exam simulator can retrieve data from clusters in simulator and spin up local clusters using this project.

The logic used for bringing up kubernetes clusters running CKS Killer Shell environment can essentially be applied to restoring any kubernetes cluster data. There may be some changes required depending on the target kubernetes cluster envrionment for e.g environment specific kubernetes parameters.

## Requirements

- Terraform
- Multipass
- _Other stuff that might popup in errors. I am sure you'll figure it out...I believe in you!_

## Buckle up!

Create `config.yaml` declaring cluster topology. Specify instances spec as per requirement.

```yaml
##Config Sample
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

### Liven up Terraform

```bash
terraform init
```

### Make magic happen

```bash
terraform apply
```

### When tired or free up precious little resources on system or just start over

```bash
terraform destroy
```

## CKS Killer-Shell

The data from recent CKS 1.23 environment already included under `killer-sh-cks` which is used to bring up Kubernetes clusters and restore environment.

Stayed Tuned: Will add instructions later regarding how to pull up environment data and use that instead (_or NOT..we'll see..I am busy!_)

## TODO

- Update CKS Killer-shell blah blah
- Fix pod network connectivity issue with killer-sh environment (this one's a biyatch!)
- Change packages arch to be more general instead of just ARM
- Setup gviser/runsc
- Setup docker registry on bastion host
- Load private registry images used in environment
- Add feature for HA control plane (fuhgedaboutit)

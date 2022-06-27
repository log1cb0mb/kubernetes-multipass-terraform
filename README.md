# kubernetes-multipass-terraform

An easy declarative way to spin up Kubernetes clusters on Multipass Ubuntu instances using Terraform. The project also includes an option to spin up Kubernetes clusters and restore data from an existing cluster provided that certain requirements are met.

## Requirements

- Terraform
- Multipass
- _Other stuff that might popup in errors. I am sure you'll figure it out...I believe in you!_

&nbsp;

## Buckle up!

Create `config.yaml` declaring cluster topology. Specify instances spec as per requirement.

### Bastion host

A dedicated terminal/bastion instance can also be created when instance role set to `bastion` that includes additional packages installed:

- docker
- podman
- K9s
- kubectl/kubeadm/kubelet

### Config sample

```yaml
environment:
  k8s_version: "1.23.1"
  restore_cluster: false # Bring up existing Kubernetes cluster (Ubuntu/Debian)
  ssh_key: "<ssh public key for instances>"
servers:
  # Instances naming mutually exclusive to restore_cluster property
  # WHen restoring existing cluster, instances naming should match
  # exactly the cluster nodes being restored
  # When restore_cluster not defined or false, instance names can be any
  # for new/empty clusters
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

### When tired or need to free up precious little resources on system or just start over

```bash
terraform destroy
```

> KUBECONFIG environment variable pointing to `/etc/kubernetes/admin.conf` on controller/worker instances so tools for e.g `kubectl` can be used straight away with sudo directory on controllers/worker instances. If terminal/bastion is created then transfer `kubeconfig` under default `ubuntu` user on terminal/bastion instance. After kubernetes cluster is initialized, cluster `kubeconfig` is copied to  `scripts/init/<cluster_name>.yaml` so can used locally as well.

&nbsp;

## Restoring existing cluster

Following content required from existing cluster:

- Kubernetes cluster CA Certificate and Key
  
  - Two files `ca.crt` and `ca.key` are stored by default stored under `/etc/kubernetes/pki` on a controller node
  - Encode certificate and key contents:

    ```bash
    echo "<content>" | base64
    ```

  - Create `cluster-data/pki.yaml` file using format used in `cluster-data/pki-sample.yaml` file
    > **Important: cluster name should match exactly to what is specified under `config.yaml` for the nodes.**

- ETCD snapshot

  - Pull ETCD snapshot from any of the controller nodes or from where ETCD API endpoint is reachable. Example:

    ```bash
    ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt 
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save <cluster_name>.db
    ```

  - Compress DB file:

    ```bash
    tar -cvzf <cluster_name>.tar.gz <cluster_name>.db
    ```

    > **Important: Both DB and tarball filenames have to match to `cluster_name` specified under `config.yaml`**

  - Copy tarball under `cluster-data/`

  - Now back to Making magic happen step and Voilà!

## TODO

- Change packages arch to be more general instead of just ARM (_Not everyone is ridiculously rich to own an Apple Silicon or poor enough to run this on Raspberry Pi_)
- Setup docker registry on bastion host
- Add feature for HA control plane (_fuhgedaboutit_)

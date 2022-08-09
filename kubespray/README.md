# Cluster: Kubespray

1. Install AWS CLI and set keys in `.env`.
1. Subscribe to Alma Linux at <https://aws.amazon.com/marketplace/pp/prodview-mku4y3g4sjrye>.
1. Run `deploy-infrastructure.sh` to deploy a target environment in AWS using
   Terraform as configured in `kubespray/contrib/terraform/aws`.
1. Run `deploy-cluster.sh` to install the cluster.

When finished a kubeconfig file will be written to
`inventory/cluster/artifacts/admin.conf`. It will use the internal IP address of
an API server; replace that with the DNS name of the network load balancer
provisioned by kubespray. Finally, point your KUBECONFIG env var there.

```bash
## set clusters[0].cluster.server to `https://${lb_hostname}:6443/`
export KUBECONFIG=inventory/cluster/artifacts/admin.conf
lb_hostname=$(aws elbv2 describe-load-balancers --output json | jq -r '.LoadBalancers[0].DNSName')
lb_name=https://${lb_hostname}:6443/
## TODO(test): cat "${KUBECONFIG}" | sed "s/(^.*server: ).*$/\1${lb_name}/" > ${KUBECONFIG}
kubectl get pods -A
```

## Test

Mount inventory and SSH key into container with preinstalled environment, then
execute playbook in that context. For example:

```bash
podman run --rm -it \
    --mount type=bind,source=kubespray/inventory/cluster,dst=/inventory,relabel=shared \
    --mount type=bind,source=.ssh/id_rsa,dst=/root/.ssh/id_rsa,relabel=shared \
        quay.io/kubespray/kubespray:v2.19.0 \
            bash

# when prompted, enter (for example):
ansible-playbook cluster.yml \
    -i /inventory/hosts.ini \
    --private-key /root/.ssh/id_rsa \
    --become --become-user=root \
    -e "kube_version=v1.23.7" \
    -e "ansible_user=ec2-user"
```

## Fixes

- Set `kube_version` to working version, see `inventory/cluster/group_vars/k8s_cluster/k8s-cluster.yml`.
    - To verify availability of kubeadm releases check for e.g.
`https://storage.googleapis.com/kubernetes-release/release/v1.24.1/bin/linux/amd64/kubeadm`.

### For kubeadm v1.24.x

- In file `/etc/containerd/config.toml` set `SystemdCgroup = true`. Initial setting is `systemdCgroup = true`.
- In file `/etc/kubernetes/kubelet.env` comment out `--network-config` and other CNI flags removed in v1.24.
- In file `/etc/kubernetes/manifests/kube-apiserver.yaml` remove `--insecure-port` which was removed in v1.24.

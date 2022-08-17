# OpenShift on AWS with Installer-Provisioned Infrastructure (IPI)

## Use

1. Install [AWS CLI][] and [openshift-install][] CLI.
1. Set AWS access key secrets in `.env`.
1. Get a pull secret for Red Hat container registries from <https://console.redhat.com/openshift/downloads#tool-pull-secret>. Set this as `OPENSHIFT_PULL_SECRET` in `.env`.
1. Set up a subdomain in AWS ([docs](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html)). Set its name as `BASE_DOMAIN` in `.env`.
1. Set `CLUSTER_NAME` and `AWS_REGION` in `.env` or rely on defaults.
1. Review cluster config in `install-config.yaml.tpl`.
1. Run `deploy.sh` to install cluster.

Run `destroy.sh` to destroy the cluster and AWS resources.

## Info

Cluster state will be saved in this repo at `temp/_workdir`. Rename or move this
directory to retain it so that you can later destroy the cluster or get
credentials for it. `deploy.sh` simply overwrites any existing state.

To find credentials for cluster, open `./temp/_workdir/auth` from the repo root.
For example, set `export KUBECONFIG=${root_dir}/temp/_workdir/auth/kubeconfig`
and then use `kubectl` or `oc` as usual.

To uninstall cluster, run `openshift-install destroy cluster --dir
./temp/_workdir`. Adjust to point to a renamed/moved workdir.

Cluster will be accessible at this URL:
`https://console-openshift-console.apps.${CLUSTER_NAME}.${BASE_DOMAIN}`, e.g.
`https://console-openshift-console.apps.ipi.aws.joshgav.com/`.

[AWS CLI]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[openshift-install]: https://console.redhat.com/openshift/downloads#tool-x86_64-openshift-install

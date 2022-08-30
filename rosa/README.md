# Red Hat OpenShift on AWS (ROSA)

Provision [Red Hat OpenShift Service on AWS
(ROSA)](https://aws.amazon.com/rosa/) instances.

Begin from and manage clusters at <https://console.redhat.com/openshift>.

## Deploy cluster

1. Install [AWS][] and [rosa][] CLIs and [jq](https://stedolan.github.io/jq/).
1. Set AWS access key secrets [as environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) in `.env`.
1. Get a token for Red Hat's cloud console from <https://console.redhat.com/openshift/token/rosa/> and set it as `REDHAT_ACCOUNT_TOKEN` in `.env`.
1. Set a CLUSTER_NAME in `.env` or rely on the default `rosa1`.
1. Run `deploy.sh`.

## Use cluster

`deploy.sh` will provision IAM roles and a cluster; and publish API and Console
URLs and username and password to stdout. Use the URLs and credentials to login
with the `oc` CLI as follows:

```bash
oc login "${api_server_url}" --username cluster-admin --password "${cluster_admin_password}"

## for example:
oc login https://api.rosa1.n9km.p1.openshiftapps.com:6443 \
   --username cluster-admin --password HRppn-5IKNZ-oZHQh-XbbQ2
```

[AWS]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[rosa]: https://console.redhat.com/openshift/downloads#tool-rosa
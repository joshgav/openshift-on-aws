# Red Hat OpenShift on AWS (ROSA)

Manage clusters at <https://console.redhat.com/openshift>.

1. Install [AWS CLI][] and [rosa][] CLI.
1. Set AWS access key secrets in `.env`.
1. Get a token for Red Hat cloud console from <https://console.redhat.com/openshift/token/rosa/>. Set this as `REDHAT_ACCOUNT_TOKEN` in `.env`.
1. Set a CLUSTER_NAME in `.env` or rely on the default ("rosa1").
1. Run `deploy.sh`.

At the end an admin user will be created and the password will be printed to
stdout. The API and Console URLs will also be printed. Use these to login via
CLI as follows:

```bash
oc login "https://API_URL" --username cluster-admin --password "PASSWORD"

## for example:
oc login https://api.rosa1.n9km.p1.openshiftapps.com:6443 \
   --username cluster-admin --password HRppn-5IKNZ-oZHQh-XbbQ2
```

[AWS CLI]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[rosa]: https://console.redhat.com/openshift/downloads#tool-rosa
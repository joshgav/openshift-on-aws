# OpenShift on AWS with User-Provisioned Infrastructure (UPI)

Deploy OpenShift by a) preparing manifests and embedding them in Ignition
configs and b) configuring cloud infrastructure (machines) to bootstrap using
these configs.

Unlike installer-provisioned infrastructure, with UPI the human installer must
configure the machines and pass them Ignition configs.

## Run

The `deploy.sh` script does the following:

1. Generate OpenShift manifests and Ignition configs. Extract custom cluster name.
1. Parameterize and orchestrate a series of CloudFormation stack deployments.
1. Finalize cluster installation using `openshift-install wait-for`.

To quickly destroy the cluster, run `destroy.sh` to delete the created
CloudFormation stacks in reverse order of creation.

## Resources

- [Starting doc](https://docs.openshift.com/container-platform/4.10/installing/installing_aws/installing-aws-user-infra.html)
- [Troubleshooting installations](https://docs.openshift.com/container-platform/4.10/support/troubleshooting/troubleshooting-installations.html)
- CFN templates for AWS UPI: <https://github.com/openshift/installer/tree/master/upi/aws/cloudformation>
    - [Official docs](https://docs.openshift.com/container-platform/4.10/installing/installing_aws/installing-aws-user-infra.html#installation-cloudformation-vpc_installing-aws-user-infra)
    - [GitHub docs](https://github.com/openshift/installer/blob/master/docs/user/aws/install_upi.md)

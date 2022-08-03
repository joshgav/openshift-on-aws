#! /usr/bin/env bash

this_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
root_dir=$(cd ${this_dir}/.. && pwd)
if [[ -f ${this_dir}/.env ]]; then source ${this_dir}/.env; fi

ssh_key_path=${root_dir}/.ssh
mkdir -p "${ssh_key_path}"

if [[ ! -e "${ssh_key_path}/id_rsa" ]]; then
    ssh-keygen -t rsa -b 4096 -C "user@openshift" -f "${ssh_key_path}/id_rsa" -N ''
fi

echo "INFO: aws sts get-caller-identity"
aws sts get-caller-identity

workdir=${root_dir}/temp/_workdir
if [[ -d ${workdir} ]]; then rm -rf ${workdir}; fi
mkdir -p ${workdir}

export SSH_PUBLIC_KEY="$(cat ${ssh_key_path}/id_rsa.pub)"
cat ${this_dir}/install-config.yaml.tpl | envsubst 1> ${workdir}/install-config.yaml

openshift-install create cluster --dir ${workdir}

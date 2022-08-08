function fix_stack_name {
    local original_name=${1}

    echo "${original_name}" | sed -E 's/^[0-9]{2}_//' | sed -E 's/[_]/-/g'
}

## creates stack named ${stack_name} if it does not exist
## expects to find file cfn/${stack_name}_cfn.yaml and cfn/${stack_name}_cfn-parameters.json
##     in caller's directory
function ensure_stack {
    local stack_name=${1}
    local stack_dir=${2}

    ## priority order: stack_dir, this_dir, "."
    if [[ -z "${stack_dir}" ]]; then stack_dir=${this_dir:-'.'}; fi

    stack_short_name=$(fix_stack_name "${stack_name}")
    aws cloudformation describe-stacks --stack-name ${stack_short_name} &> /dev/null
    if [[ $? == 254 ]]; then
        echo "INFO: creating cfn stack ${stack_short_name} in dir ${stack_dir}"
        aws cloudformation create-stack --stack-name "${stack_short_name}" \
            --template-body "file://${stack_dir}/${stack_name}.yaml" \
            --parameters "file://${stack_dir}/${stack_name}_params.json" \
            --capabilities CAPABILITY_NAMED_IAM
    else
        echo "INFO: using existing cfn stack ${stack_short_name}"
    fi
}

## waits till stack is ready to continue
function await_stack {
    local stack_name=${1}

    stack_short_name=$(fix_stack_name "${stack_name}")
    done=false
    while ! ${done}; do
        status=$(aws cloudformation describe-stacks --stack-name ${stack_short_name} --output json | \
            jq -r '.Stacks[].StackStatus')
        if [[ "${status}" == 'CREATE_COMPLETE' ]]; then
            done=true
            echo "INFO: stack created"
        else
            echo "INFO: awaiting stack creation..."
            sleep 2
        fi
    done
}

function get_value_from_outputs {
    local stack_outputs=${1}
    local key=${2}

    echo "${stack_outputs}" | jq -r ".[] | select(.OutputKey == \"${key}\") | .OutputValue"
}

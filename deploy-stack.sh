#!/bin/bash

function region_set_continue() {
    echo "AWS_REGION is ${AWS_REGION}"
}

function region_not_set_exit() {
    echo "AWS_REGION is not set"
    return -1
}

function role_found_continue() {
    echo "You're good. IAM role IS valid."
}

function role_not_found_exit() {
    echo "IAM role NOT valid. DO NOT PROCEED."
    return -1
}

# Remove local credentials
rm -vf ${HOME}/.aws/credentials

cd ~/environment

# Setup workspace
curl -sSL https://raw.githubusercontent.com/aws-samples/one-observability-demo/main/PetAdoptions/envsetup.sh | bash -s stable

export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region

test -n "$AWS_REGION" && region_set_continue || region_not_set_exit
aws sts get-caller-identity --query Arn | grep observabilityworkshop-admin -q && role_found_continue || role_not_found_exit

# Initialize the application dependencies
cd workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack
npm install

# Bootstrap CDK
cdk bootstrap

EKS_ADMIN_ARN=$(../../getrole.sh)

echo -e "\nRole \"${EKS_ADMIN_ARN}\" will be part of system:masters group\n"

if [ -z $CONSOLE_ROLE_ARN ]; then echo -e "\nEKS Console access will be restricted\n"; else echo -e "\nRole \"${CONSOLE_ROLE_ARN}\" will have access to EKS Console\n"; fi

# Deploy application components
cdk deploy --context admin_role=$EKS_ADMIN_ARN Services --context dashboard_role_arn=$CONSOLE_ROLE_ARN --require-approval never
cdk deploy Applications --require-approval never

aws eks update-kubeconfig --name PetSite --region $AWS_REGION
kubectl get nodes                              

aws ssm get-parameter --name '/petstore/petsiteurl'  | jq -r .Parameter.Value

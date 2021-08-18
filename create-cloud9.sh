#!/bin/bash

curl -O https://raw.githubusercontent.com/aws-samples/one-observability-demo/main/cloud9-cfn.yaml

aws cloudformation create-stack --stack-name C9-Observability-Workshop --template-body file://cloud9-cfn.yaml --capabilities CAPABILITY_NAMED_IAM

aws cloudformation wait stack-create-complete --stack-name C9-Observability-Workshop

echo -e "Cloud9 Instance is Ready!!\n\n"

echo "Execute the below snippet in a terminal tab in the Cloud9 workspace."

export CONSOLE_ROLE_ARN=$(aws sts get-caller-identity --query Arn)

echo "
export CONSOLE_ROLE_ARN=${CONSOLE_ROLE_ARN}
curl -O https://raw.githubusercontent.com/iamsouravin/aws-observability-workshop-helpers/main/deploy-stack.sh
. ./deploy-stack.sh"
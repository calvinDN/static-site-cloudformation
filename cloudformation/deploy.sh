#!/usr/bin/env bash
set -e

export DOMAIN_NAME=calvindn.com
export STACK_NAME=calvindncom
export AWS_PROFILE=calvindn
export SITE_DIR="../node_modules/calvindn.com/resources/html/"

aws --profile $AWS_PROFILE cloudformation create-stack --stack-name $STACK_NAME --template-body file://sample-site-s3.template.yml --capabilities CAPABILITY_IAM --parameters ParameterKey=DomainName,ParameterValue=$DOMAIN_NAME

aws --profile $AWS_PROFILE cloudformation wait stack-create-complete

export SITE_URL=`aws --profile $AWS_PROFILE cloudformation describe-stacks --stack-name $STACK_NAME --query Stacks[0].Outputs[1].OutputValue --output text`

export S3_URL=`aws --profile $AWS_PROFILE cloudformation describe-stacks --stack-name $STACK_NAME --query Stacks[0].Outputs[0].OutputValue --output text`

aws --profile $AWS_PROFILE s3 cp $SITE_DIR s3://$DOMAIN_NAME/ --recursive

echo "Setup complete. Site URL: $SITE_URL"

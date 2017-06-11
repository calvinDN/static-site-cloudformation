#!/usr/bin/env bash
set -e

export DOMAIN_NAME=calvindn.com
export STACK_NAME=calvindncom
export AWS_PROFILE=calvindn

aws --profile $AWS_PROFILE cloudformation delete-stack --stack-name $STACK_NAME

aws --profile $AWS_PROFILE cloudformation wait stack-delete-complete --stack-name $STACK_NAME

aws --profile $AWS_PROFILE s3 rb s3://$DOMAIN_NAME --force
aws --profile $AWS_PROFILE s3 rb s3://www.$DOMAIN_NAME --force

echo 'Teardown complete.'

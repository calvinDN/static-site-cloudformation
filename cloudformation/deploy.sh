#!/usr/bin/env bash

export STACK_NAME=sample-site
export S3_BUCKET=sample-site-calvindn
export AWS_PROFILE=calvindn

aws --profile $AWS_PROFILE cloudformation create-stack --stack-name $STACK_NAME --template-body file://sample-site-s3.template.yml --capabilities CAPABILITY_IAM --parameters ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET

aws --profile $AWS_PROFILE cloudformation wait stack-create-complete

export SITE_URL=`aws --profile $AWS_PROFILE cloudformation describe-stacks --stack-name $STACK_NAME --query Stacks[0].Outputs[1].OutputValue --output text`

export S3_URL=`aws --profile $AWS_PROFILE cloudformation describe-stacks --stack-name $STACK_NAME --query Stacks[0].Outputs[0].OutputValue --output text`

aws --profile $AWS_PROFILE s3 cp ../site/ s3://$S3_BUCKET/ --recursive 

echo "Setup complete. Site URL: $SITE_URL"

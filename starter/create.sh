#!/bin/bash

# Usage: ./create.sh <stack-name> <template-file> <parameters-file>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <stack-name> <template-file> <parameters-file>"
    exit 1
fi

STACK_NAME=$1
TEMPLATE_FILE=$2
PARAMETERS_FILE=$3

aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters file://$PARAMETERS_FILE \
    --capabilities CAPABILITY_NAMED_IAM \
    --region us-east-1

echo "Creating stack: $STACK_NAME"
echo "Waiting for stack creation to complete..."

aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --region us-east-1

echo "Stack $STACK_NAME created successfully!"

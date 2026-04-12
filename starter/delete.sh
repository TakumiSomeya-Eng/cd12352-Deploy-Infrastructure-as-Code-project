#!/bin/bash

# Usage: ./delete.sh <stack-name>

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <stack-name>"
    exit 1
fi

STACK_NAME=$1

# S3バケットを空にする（udagram-appスタックの場合）
if [ "$STACK_NAME" = "udagram-app" ]; then
    echo "Emptying S3 bucket before deletion..."
    BUCKET_NAME=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query "Stacks[0].Outputs[?OutputKey=='S3BucketName'].OutputValue" \
        --output text \
        --region us-east-1)
    
    if [ -n "$BUCKET_NAME" ]; then
        aws s3 rm s3://$BUCKET_NAME --recursive
        echo "S3 bucket $BUCKET_NAME emptied."
    fi
fi

aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region us-east-1

echo "Deleting stack: $STACK_NAME"
echo "Waiting for stack deletion to complete..."

aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --region us-east-1

echo "Stack $STACK_NAME deleted successfully!"

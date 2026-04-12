# Udacity Cloud DevopsEngineer Course
# Project: Deploy a high-availability web app using CloudFormation
# Takumi Someya 

## Architecture Overview
This project deploys a high-availability web application on AWS using CloudFormation.
The infrastructure is split into two independent stacks:

1. **Network Stack** - VPC, Subnets, Internet Gateway, NAT Gateways
2. **Application Stack** - EC2, Auto Scaling, Load Balancer, S3

## Prerequisites

- AWS CLI installed and configured
- Bash environment (Git Bash on Windows)

## Spin up instructions

### 1. Deploy Network Stack
```bash
./create.sh udagram-network network.yml network-parameters.json
```

### 2. Upload static content to S3
```bash
aws s3 cp index.html s3://udagram-static-content-2026/index.html
```

### 3. Deploy Application Stack
```bash
./create.sh udagram-app udagram.yml udagram-parameters.json
```

### 4. Get the Load Balancer URL
```bash
aws cloudformation describe-stacks \
    --stack-name udagram-app \
    --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerURL'].OutputValue" \
    --output text
```

## Tear down instructions

### 1. Delete Application Stack first (empties S3 automatically)
```bash
./delete.sh udagram-app
```

### 2. Delete Network Stack
```bash
./delete.sh udagram-network
```

## Other considerations

- NAT Gateways incur hourly charges - delete stacks when not in use
- EC2 instances are deployed in private subnets for security
- Static content is served from S3 via EC2 instances running nginx
- The Load Balancer URL is exported as an output of the application stack

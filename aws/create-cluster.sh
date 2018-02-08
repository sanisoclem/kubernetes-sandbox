#!/bin/bash
set -e

export CLUSTER_NAME=sanisoclem-04
export BUCKET_NAME=${CLUSTER_NAME}-k8s-state-store
export KOPS_STATE_STORE=s3://$BUCKET_NAME
export NAME=${CLUSTER_NAME}.k8s.local

aws configure           # Use your new access and secret key here
aws iam list-users      # you should see a list of all your IAM users here

# for kops
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)


# create an s3 bucket for config

aws s3api create-bucket --bucket "$BUCKET_NAME" --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1

# enable versioning 
 aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled


#aws ec2 describe-availability-zones --region ap-southeast-1

 kops create cluster --zones ap-southeast-1a ${NAME}
 kops update cluster ${NAME} --yes

# create dashboard
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.8.1.yaml

// gets user password
#kops get secrets kube --type secret -oplaintext
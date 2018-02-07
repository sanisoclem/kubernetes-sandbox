#!/bin/bash

$CLUSTER_NAME = "sanisoclem-k8s"

aws configure           # Use your new access and secret key here
aws iam list-users      # you should see a list of all your IAM users here

# for kops
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)


# create an s3 bucket for config

aws s3api create-bucket --bucket "${CLUSTER_NAME}-state-store" \
     --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1

# enable versioning 
 aws s3api put-bucket-versioning --bucket "${CLUSTER_NAME}-state-store" \
     --versioning-configuration Status=Enabled


export KOPS_STATE_STORE=s3://${CLUSTER_NAME}-state-store
export NAME=$CLUSTER_NAME

#aws ec2 describe-availability-zones --region ap-southease-1

 kops create cluster --zones ap-southeast-1a ${CLUSTER_NAME}
 kops update cluster ${CLUSTER_NAME} --yes

# create dashboard
kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.8.1.yaml

// gets user password
kops get secrets kube --type secret -oplaintext
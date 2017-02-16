#
# Allocates and associates an EIP to the JIRA EC2 instance
# and then starts the instance
#

#!/bin/bash

echo ">>> Retrieving JIRA instance-id"
INSTANCE_ID=`aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.Tags[].Value=="JIRA") | .InstanceId'`
echo "instance-id: $INSTANCE_ID"

if [[ -z "$INSTANCE_ID" ]]
then
  echo "Failed to retrieve JIRA instance-id. Exiting."
  exit 1
fi

echo ">>> Allocating Elastic IP"
RESP=`aws ec2 allocate-address`
echo "$RESP"
ALLOCATION_ID=`echo $RESP | jq -r '.AllocationId'`
PUBLIC_IP=`echo $RESP | jq -r '.PublicIp'`
echo "allocation-id: $ALLOCATION_ID"
echo "public-ip: $PUBLIC_IP"

if [[ -z "$ALLOCATION_ID" ]]
then
  echo "IP allocation failed. Exiting."
  exit 1
fi

echo ">>> Associating $PUBLIC_IP with $INSTANCE_ID"
aws ec2 associate-address --allocation-id=$ALLOCATION_ID --instance-id=$INSTANCE_ID

echo ">>> Starting JIRA instance"
aws ec2 start-instances --instance-ids $INSTANCE_ID

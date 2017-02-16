#
# Disassociates and releases the EIP on the JIRA EC2 instance
# and then stops the EC2 instance
#

#!/bin/bash

echo ">>> Retrieving JIRA instance-id"
INSTANCE_ID=`aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.Tags[].Value="JIRA") | .InstanceId'`
echo "instance-id: $INSTANCE_ID"

if [[ -z "$INSTANCE_ID" ]]
then
  echo "Failed to retrieve JIRA instance-id. Exiting."
  exit 1
fi

echo ">>> Retrieving allocation and association id"
RESP=`aws ec2 describe-addresses`
ALLOC_ID=`echo $RESP | jq -r '.Addresses[] | select(.InstanceId="$INSTANCE_ID") | .AllocationId'`
ASSOC_ID=`echo $RESP | jq -r '.Addresses[] | select(.InstanceId="$INSTANCE_ID") | .AssociationId'`
echo "allocation-id: $ALLOC_ID"
echo "association-id: $ASSOC_ID"

echo ">>> Disassociating Elastic IP"
aws ec2 disassociate-address --association-id $ASSOC_ID

echo ">>> Releasing Elastic IP"
aws ec2 release-address --allocation-id $ALLOC_ID

echo ">>> Stopping JIRA instance"
aws ec2 stop-instances --instance-ids $INSTANCE_ID

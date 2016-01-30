#!/bin/bash

SHA1=$1
ACCOUNT=$2
EB_BUCKET=elasticbeanstalk-us-east-1-$ACCOUNT

# Deploy image to Docker Hub
docker push $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/cmsbl/webapp:$SHA1

# Create new Elastic Beanstalk version
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json

sed "s/<ACCOUNT>/$ACCOUNT/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
sed "s/<TAG>/$SHA1/" < $DOCKERRUN_FILE > $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE \
  --region us-east-1

aws elasticbeanstalk create-application-version \
  --application-name webapp \
  --version-label $SHA1 \
  --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment \
  --environment-name webapp \
  --version-label $SHA1 \
  --region us-east-1

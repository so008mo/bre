docker run --rm -it \
     -v $(pwd):/deploy \
     -e AWS_REGION=us-east-1 \
     -e AWS_DEFAULT_REGION=us-east-1 \
     -e AWS_ACCESS_KEY_ID=`aws configure get aws_access_key_id` \
     -e AWS_SECRET_ACCESS_KEY=`aws configure get aws_secret_access_key` \
     -e AWS_SESSION_TOKEN=`aws configure get aws_session_token` \
     211613195758.dkr.ecr.us-east-1.amazonaws.com/deploy-utils:release "$@"
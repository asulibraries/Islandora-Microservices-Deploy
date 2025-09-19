#!/bin/bash
set -e

# Useage: ./build_images.sh [AWS_ACCOUNT_ID] [AWS_PROFILE]
# If AWS_ACCOUNT_ID is provided, the script will attempt to log in to ECR and push images.
# AWS_PROFILE is optional and defaults to 'default'.

# Check for AWS Account ID argument and login if provided
PUSH_TO_ECR=false
AWS_ACCOUNT_ID="$1"
if [ -n "$AWS_ACCOUNT_ID" ]; then
  PUSH_TO_ECR=true

  # Optional: Set AWS profile (default is 'default')
  AWS_PROFILE="default"
  if [ -n "$2" ]; then
    AWS_PROFILE="$2"
  fi

  # Login
  echo "Logging into AWS ECR with account $AWS_ACCOUNT_ID with profile $AWS_PROFILE."
  AWS_REGION="us-west-2"
  aws ecr get-login-password --region "$AWS_REGION" --profile "$AWS_PROFILE" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
  if [ $? -ne 0 ]; then
    echo "ECR login failed. Exiting."
    exit 1
  fi
fi

# Base tag prefix
PREFIX="islandora"

for dir in */ ; do
  # Remove trailing slash
  dirname=$(basename "$dir")

  # Check if the directory has a Dockerfile
  if [ -f "$dir/Dockerfile" ]; then
    echo "Building image for $dirname..."
    docker build -t "${PREFIX}/${dirname}:latest" "$dir"

    # Push to ECR if enabled
    if [ "$PUSH_TO_ECR" = false ]; then
      continue
    fi

    # Create ECR repository if it doesn't exist
    if ! aws ecr describe-repositories --repository-names "${PREFIX}/${dirname}" --region "$AWS_REGION" --profile "$AWS_PROFILE" >/dev/null 2>&1; then
      echo "ECR repository ${PREFIX}/${dirname} does not exist. Creating..."
      aws ecr create-repository --repository-name "${PREFIX}/${dirname}" --region "$AWS_REGION" --profile "$AWS_PROFILE"
    fi

    docker tag "${PREFIX}/${dirname}:latest" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PREFIX}/${dirname}:latest"

    ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PREFIX}/${dirname}"
    docker push "${ECR_REPO}:latest"
  else
    echo "Skipping $dirname (no Dockerfile found)"
  fi
done
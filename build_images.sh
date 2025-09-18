#!/bin/bash
set -e

# Set ECR repository URI (replace with your AWS Account ID and region)
AWS_ACCOUNT_ID="$1"
if [ -z "$AWS_ACCOUNT_ID" ]; then
  echo "Usage: $0 <AWS_ACCOUNT_ID>"
  exit 1
fi

# Optional: Set AWS profile (default is 'default')
AWS_PROFILE="default"
if [ -n "$2" ]; then
  AWS_PROFILE="$2"
fi

AWS_REGION="us-west-2"
aws ecr get-login-password --region "$AWS_REGION" --profile "$AWS_PROFILE" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
if [ $? -ne 0 ]; then
  echo "ECR login failed. Exiting."
  exit 1
fi

# Base tag prefix (optional, change as needed)
PREFIX="islandora"

for dir in */ ; do
  # Remove trailing slash
  dirname=$(basename "$dir")

  # Check if the directory has a Dockerfile
  if [ -f "$dir/Dockerfile" ]; then
    echo "Building image for $dirname..."
    docker build -t "${PREFIX}/${dirname}:latest" "$dir"

    # Create ECR repository if it doesn't exist
    if ! aws ecr describe-repositories --repository-names "${PREFIX}/${dirname}" --region "$AWS_REGION" --profile "$AWS_PROFILE" >/dev/null 2>&1; then
      echo "ECR repository ${PREFIX}/${dirname} does not exist. Creating..."
      aws ecr create-repository --repository-name "${PREFIX}/${dirname}" --region "$AWS_REGION" --profile "$AWS_PROFILE"
    fi

    docker tag "${PREFIX}/${dirname}:latest" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PREFIX}/${dirname}:latest"
    # Push the image to ECR
    ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PREFIX}/${dirname}"
    docker push "${ECR_REPO}:latest"
  else
    echo "Skipping $dirname (no Dockerfile found)"
  fi
done
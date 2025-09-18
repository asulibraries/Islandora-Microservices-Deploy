#!/bin/bash
set -e

# Base tag prefix (optional, change as needed)
PREFIX="islandora"

for dir in */ ; do
  # Remove trailing slash
  dirname=$(basename "$dir")

  # Check if the directory has a Dockerfile
  if [ -f "$dir/Dockerfile" ]; then
    echo "Building image for $dirname..."
    docker build -t "${PREFIX}/${dirname}:latest" "$dir"
  else
    echo "Skipping $dirname (no Dockerfile found)"
  fi
done

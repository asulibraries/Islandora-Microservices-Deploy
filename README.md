# Islandora Microservices Deployment

This repository contains scripts and configuration files to deploy Islandora microservices.

Most of the components are taken directly from the [Lehigh University Libraries docker builds repository](https://github.com/lehigh-university-libraries/docker-builds).

You can build all the images using the `build_images.sh` script.

Useage: `./build_images.sh [AWS_ACCOUNT_ID] [AWS_PROFILE]`  
If `AWS_ACCOUNT_ID` is provided, the script will attempt to log in to ECR and push images.  
`AWS_PROFILE` is optional and defaults to `default`.

A `docker-compose.yml` is included for local testing.

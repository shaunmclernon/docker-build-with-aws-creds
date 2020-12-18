#!/usr/bin/env bash
DOCKER_BUILDKIT=1 docker build -t your_image --secret id=aws,src=$HOME/.aws/credentials .
#!/bin/bash
# Rebuild script
# This is meant to be run on a regular basis to make sure everything works with
# the latest version of scripts.

set -e

CREDENTIALS="$HOME/.tribus-docker-credentials.sh"

if [ ! -f "$CREDENTIALS" ]; then
  echo "Please create $CREDENTIALS and add to it:"
  echo "DOCKERHUB=hub.tribus.studio"
  echo "DOCKERHUBUSER=xxx"
  echo "DOCKERHUBPASS=xxx"
  exit;
else
  source "$CREDENTIALS";
fi

PROJECT=jenkins-helm
DATE=`date '+%Y-%m-%d-%H-%M-%S-%Z'`
MAJORVERSION='1'
VERSION='1.0'

./test.sh

# Start by getting the latest version of the official drupal image
docker pull jenkins/jenkins:lts-alpine-jdk21
# Rebuild the entire thing
docker build --no-cache -t "$DOCKERHUB"/"$PROJECT":"$VERSION" .
docker build -t "$DOCKERHUB"/"$PROJECT":"$MAJORVERSION" .
docker build -t "$DOCKERHUB"/"$PROJECT":"$MAJORVERSION".$DATE .
docker build -t "$DOCKERHUB"/"$PROJECT":"$VERSION".$DATE .
docker login "$DOCKERHUB" -u"$DOCKERHUBUSER" -p"$DOCKERHUBPASS"
docker push "$DOCKERHUB"/"$PROJECT":"$VERSION"
docker push "$DOCKERHUB"/"$PROJECT":"$MAJORVERSION"
docker push "$DOCKERHUB"/"$PROJECT":"$VERSION"."$DATE"
docker push "$DOCKERHUB"/"$PROJECT":"$MAJORVERSION"."$DATE"
# No longer using the latest tag, use the major version tag instead.

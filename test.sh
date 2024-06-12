set -e
docker pull jenkins/jenkins:lts-alpine-jdk21
docker build -t local-tribus-jenkins-helm-image .

docker run --rm --entrypoint /bin/bash local-tribus-jenkins-helm-image -c 'echo "helm version" && helm version && echo "kubectl" && kubectl && echo "doctl version" && doctl version && echo "All done!"'

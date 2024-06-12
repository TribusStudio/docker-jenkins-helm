FROM jenkins/jenkins:lts-alpine-jdk21
USER root
COPY docker-resources /docker-resources
RUN /docker-resources/build.sh && rm -rf /docker-resources
USER jenkins

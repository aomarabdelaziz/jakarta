#!/bin/bash

docker build -t maven-builder -f Dockerfile.mavenBuilder .
docker run --rm -v "/home/abdelaziz-omar/Desktop/isfp-test/tomcat10-jakartaee9/target/":/app/target maven-builder
docker build -t helloworld-app . 
docker run -d -p 8080:8080 helloworld-app 
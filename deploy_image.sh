#!/bin/bash

if [ $# -ne 3 ];then
    echo "Usage: $0 <production|staging> <frontend|hello> <version>"
    exit
fi

namespace=$1
application=$2
version=$3

if [ "${application}" == "hello" ]; then
    image="hello=gcr.io/google-samples/hello-go-gke"
fi

if [ "${application}" == "frontend" ]; then
    image="nginx=gcr.io/google-samples/hello-frontend"
fi

kubectl set image deployment/${application} ${image}:${version} --namespace=${namespace}

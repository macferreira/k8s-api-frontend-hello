#!/bin/bash

prod="production"
stag="staging"

apply_hpa() {
    kubectl apply -f ./backend/backend-hpa.yaml -f ./frontend/frontend-hpa.yaml
}

apply_resource_quotas() {
    kubectl apply -f ./environments/staging/staging-resource-quota.yaml --namespace=$stag
}

create_namespace() {
    kubectl get namespace $1 > /dev/null
    if [ $? = 1 ]
        then
            kubectl create namespace $1
        else
            echo -e "namespace $1 already exists skipping create"
    fi
}

create_namespaces() {
    create_namespace $prod
    create_namespace $stag
}

create_resources() {
    kubectl create -f ./backend/backend-deployment.yaml \
                   -f ./frontend/frontend-deployment.yaml \
                   -f ./backend/backend-service.yaml \
                   -f ./frontend/frontend-service.yaml \
                   --namespace=$1
}

delete_resources() {

    for i in $prod $stag
    do
        delete_resource_if_exists "deployment" "hello" $i
        delete_resource_if_exists "deployment" "frontend" $i
        delete_resource_if_exists "service" "hello" $i
        delete_resource_if_exists "service" "frontend" $i
    done
}

delete_resource_if_exists() {
    kubectl get $1 $2 --namespace=$3 > /dev/null
    if [ $? = 0 ]
        then
            kubectl delete $1 $2 --namespace=$3
        else
            echo -e "$1 $2 on namespace $3 does not exists, skipping delete"
    fi
}

delete_resources
create_namespaces
create_resources $stag
create_resources $prod
apply_resource_quotas
apply_hpa

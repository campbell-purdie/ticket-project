#!/bin/bash
echo "Applying Deployments"
minikube start 
eval $(minikube docker-env)
docker build -t frontend:latest ..
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml

kubectl apply -f mysql-pvc.yml
kubectl apply -f mysql-deployment.yml
kubectl apply -f mysql-service.yml

kubectl apply -f phpmyadmin-deployment.yml
kubectl apply -f phpmyadmin-service.yml

kubectl create configmap nginx-config --from-file=nginx.conf -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml


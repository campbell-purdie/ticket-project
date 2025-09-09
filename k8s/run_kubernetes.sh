#!/bin/bash
echo "Applying Deployments"
minikube start 
eval $(minikube docker-env)
docker build -t frontend:latest ..


echo "Deploying mySQL"
kubectl create configmap mysql-initdb --from-file=../transport/transport.sql -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -f mysql-pvc.yml
kubectl apply -f mysql-deployment.yml
kubectl apply -f mysql-service.yml
kubectl wait --for=condition=Ready pod -l app=mysql --timeout=120s

echo "Deploying Frontend"
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
kubectl wait --for=condition=Ready pod -l app=frontend --timeout=120s


echo "Deploying PHPMyAdmin"
kubectl apply -f phpmyadmin-deployment.yml
kubectl apply -f phpmyadmin-service.yml

echo "Deploying Nginx TLS secret"
kubectl delete secret localhost-tls --ignore-not-found
kubectl create secret tls localhost-tls --cert=../proxy/ssl/localhost.crt --key=../proxy/ssl/localhost.key

echo "Deploying Nginx"
kubectl create configmap nginx-config --from-file=default.conf -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml
kubectl wait --for=condition=Ready pod -l app=mysql --timeout=60s

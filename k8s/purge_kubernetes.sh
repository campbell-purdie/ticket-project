#!/bin/bash
echo "Killing Processes"
kubectl delete pvc --all --all-namespaces
kubectl delete configmap --all --all-namespaces
kubectl delete all  --all --all-namespaces
minikube stop

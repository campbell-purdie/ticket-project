#!/bin/bash
echo "Port-Forwarding Nginx-Service to 8888"
kubectl port-forward --address 0.0.0.0 svc/nginx-service 8888:443



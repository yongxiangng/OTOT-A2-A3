echo running start script...

echo creating clusters...
kind create cluster --name kind-1 --config ../../k8s/kind/cluster-config.yaml

kubectl cluster-info
kubectl get nodes

echo creating deployment
kubectl apply -f ../../k8s/manifests/k8s/backend-service.yaml

kubectl get po -l app=backend -o wide

echo creating service...
kubectl apply -f ../../k8s/manifests/k8s/service.yaml

kubectl describe svc backend

echo creating ingress controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl -n ingress-nginx get deploy 

echo creating ingress...
kubectl apply -f ../../k8s/manifests/k8s/ingress.yaml

echo testing curl
curl localhost/

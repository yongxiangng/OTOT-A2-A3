echo running start script...

echo creating clusters...
kind create cluster --name kind-1 --config ../../k8s/kind/cluster-config.yaml

kubectl cluster-info
kubectl get nodes

echo creating deployment
kubectl apply -f ../../k8s/manifests/k8s/backend-service.yaml

kubectl wait --for=condition=ready deploy --selector=app=backend --timeout=180s

kubectl get po -l app=backend -o wide

echo creating service...
kubectl apply -f ../../k8s/manifests/k8s/service.yaml

kubectl wait --for=condition=ready service --selector=app=backend-service --timeout=90s

kubectl describe svc backend

echo creating ingress controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

kubectl -n ingress-nginx get deploy 

echo creating ingress...
kubectl apply -f ../../k8s/manifests/k8s/ingress.yaml

kubectl wait --for=condition=ready ingress --selector=app=backend-ingress --timeout=90s

sleep 10 # sneaky sleep, instantly curling has issues

echo testing curl
curl localhost/

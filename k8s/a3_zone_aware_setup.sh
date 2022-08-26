echo running start script...

echo creating clusters...
kind create cluster --name kind-1 --config kind/cluster-config.yaml

kubectl cluster-info --context kind-kind-1
kubectl get nodes --context kind-kind-1

echo creating deployment
kubectl apply -f manifests/k8s/backend-service-zone-aware.yaml --context kind-kind-1

kubectl wait --for=condition=ready pod --selector=app=backend-zone-aware --timeout=180s --context kind-kind-1
kubectl get po -l app=backend-zone-aware -o wide --context kind-kind-1

echo creating service...
kubectl apply -f manifests/k8s/service-zone-aware.yaml --context kind-kind-1

kubectl describe svc backend-service-zone-aware --context kind-kind-1
kubectl get svc -l app=backend-zone-aware -o wide --context kind-kind-1

echo creating ingress controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-kind-1

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s --context kind-kind-1
kubectl --namespace ingress-nginx get po -l app.kubernetes.io/component=controller -o wide --context kind-kind-1
kubectl -n ingress-nginx get deploy --context kind-kind-1

echo creating ingress...
kubectl apply -f manifests/k8s/ingress-zone-aware.yaml --context kind-kind-1

kubectl get ingress -l app=backend-zone-aware -o wide --context kind-kind-1

sleep 10 # sneaky sleep, instantly curling has issues

echo testing curl
curl localhost/

kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName' --context kind-kind-1

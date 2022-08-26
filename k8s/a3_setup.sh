echo running script...

echo starting up metrics server...
kubectl apply -f manifests/k8s/metrics-server.yaml --context kind-kind-1
kubectl wait -nkube-system --for=condition=ready pod --selector=k8s-app=metrics-server --timeout=180s --context kind-kind-1
kubectl -nkube-system --selector=k8s-app=metrics-server get deploy --context kind-kind-1

echo starting auto scaling hpa...
kubectl apply -f manifests/k8s/backend-hpa.yaml --context kind-kind-1
kubectl describe hpa --context kind-kind-1

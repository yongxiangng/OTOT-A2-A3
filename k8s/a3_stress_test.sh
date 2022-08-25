kubectl describe hpa --context kind-kind-1

echo curling...

max=100
for i in `seq 1 $max`
do
    curl --silent -o /dev/null localhost
done


kubectl describe hpa --context kind-kind-1

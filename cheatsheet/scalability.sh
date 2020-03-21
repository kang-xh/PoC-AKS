################ Step 1: Get AKS configuration

# get cluster info
kubectl cluster-info
kubectl get node -o wide
kubectl get pod --all-namespaces -o wide

# get vote PoD detials
kubectl get pod --namespace vote -o wide

# scale vote web front PoD number to 2
kubectl scale --replicas=2 deployment vote-web --namespace vote


################ Step 3: redo stress test with scale pod
keep Scale JMeter thread to 500, start to scale pod

kubectl scale --replicas=15 deployment vote-web --namespace vote
watch kubectl get pod --namespace vote -o wide

Some PoD could be Pending due to Insufficient CPU

JMeter can be stopped as we have demo the pod scale. next is to scale agent pool. 

################ Step 4: Scale node pool to 4 so that all Pods can be scheduled. 
# scale AKS worknode.
az account list --output table | grep True
az aks list --output table
az aks scale --resource-group az-rg-kangxh-aks --name kangxhakssea --node-count 4 --nodepool-name agentpool

################ Step 5: Scale in 
kubectl scale --replicas=2 deployment vote-web --namespace vote
az aks scale --resource-group az-rg-kangxh-aks --name kangxhakssea --node-count 2 --nodepool-name agentpool



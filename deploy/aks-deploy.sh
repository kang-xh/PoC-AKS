# run command in WSL

# login with kangxh.com
az cloud set -n AzureCloud
az login --service-principal -u http://msdn-cli-login -p /mnt/c/kangxh/AzureLabs/Certs/msdn/msdn-cli-login.pem --tenant kangxh.com

# update az aks extension
az extension add --name aks-preview
az extension list

# verify resource in core resource group: 
az resource list --resource-group MSDNRGKangxhSEA -o table

# Create aks Resource Group
az group create --name az-rg-kangxh-aks --location southeastasia

# transfer docker image from docker.io/kangxh to kangxhacrsea
az acr login --resource-group az-rg-kangxh-aks --name kangxhacrsea
docker push kangxhacrsea.azurecr.io/task-api:latest
docker push kangxhacrsea.azurecr.io/vote-web:latest

az acr import --name kangxhacrsea --source docker.io/kangxh/task-api:latest --image task-api:latest
az acr import --name kangxhacrsea --source docker.io/kangxh/vote-web:latest --image vote-web:latest
az acr import --name kangxhacrsea --source docker.io/kangxh/kangxh.com:latest --image kangxh.com:latest
az acr import --name kangxhacrsea --source docker.io/kangxh/ibean.org:latest --image ibean.org:latest

# get dependent resource ID
OMSID=$(az monitor log-analytics workspace show --resource-group az-rg-kangxh-core -n kangxhoms --query id -o tsv)
SUBNET=$(az network vnet subnet show --resource-group az-rg-kangxh-core --vnet-name kangxhvnetsea --name aks --query id -o tsv)
PIP=$(az network public-ip show --resource-group  az-rg-kangxh-aks --name kangxhpipseaaks --query id -o tsv)

# Create AKS
az aks create --resource-group az-rg-kangxh-aks \
    --name kangxhakssea \
    --ssh-key-value /home/allenk/github/poc-aks/deploy/id_rsa.pub \
    --admin-username allenk \
    --workspace-resource-id $OMSID \
    --enable-addons monitoring \
    --enable-managed-identity \
    --location southeastasia \
    --vm-set-type VirtualMachineScaleSets  \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET \
    --docker-bridge-address 172.17.0.1/16 \
    --service-cidr   192.168.0.0/24 \
    --dns-service-ip 192.168.0.10 \
    --load-balancer-outbound-ips $PIP \
    --node-resource-group AZRGKangxhAKSResources \
    --nodepool-name b2pool \
    --node-vm-size Standard_B2s \
    --nodepool-labels sku=b2vm \
    --node-osdisk-size 30 \
    --node-count 2 \
    --attach-acr kangxhacrsea

# Add B4 node pool.
az aks nodepool add \
    --resource-group az-rg-kangxh-aks \
    --cluster-name kangxhakssea \
    --name b4pool \
    --node-vm-size Standard_B4ms \
    --labels sku=b4vm \
    --node-osdisk-size 30 \
    --node-count 1

az aks nodepool add \
    --resource-group az-rg-kangxh-aks \
    --cluster-name kangxhakssea \
    --name d8pool \
    --node-vm-size Standard_D8s_v3 \
    --labels sku=d8vm \
    --node-osdisk-size 30 \
    --node-count 1

az aks nodepool add \
    --resource-group az-rg-kangxh-aks \
    --cluster-name kangxhakssea \
    --name f8pool \
    --node-vm-size Standard_F8s_v2 \
    --labels sku=f8vm \
    --node-osdisk-size 30 \
    --node-count 1

az aks nodepool delete --resource-group az-rg-kangxh-aks --cluster-name kangxhakssea --name f8pool
az aks nodepool delete --resource-group az-rg-kangxh-aks --cluster-name kangxhakssea --name b2pool

# donwload kubectl credential
az aks get-credentials --resource-group az-rg-kangxh-aks --name kangxhakssea

# Update b2 & b4 node pool. b2 will run most of time to host web
az aks nodepool update --cluster-name kangxhakssea \
                       --name b2pool \
                       --resource-group az-rg-kangxh-aks \
                       --max-count 3 \
                       --min-count 1 \
                       --mode System 

az aks nodepool update --cluster-name kangxhakssea \
                       --name b4pool \
                       --resource-group az-rg-kangxh-aks \
                       --max-count 3 \
                       --min-count 1 \
                       --mode System 

# scale to min size to save cost.
az aks nodepool scale --cluster-name kangxhakssea --resource-group az-rg-kangxh-aks --name b2pool --node-count 1
az aks nodepool scale --cluster-name kangxhakssea --resource-group az-rg-kangxh-aks --name b4pool --node-count 1

# upgrade aks

az aks get-upgrades --resource-group az-rg-kangxh-aks --name kangxhakssea 
az aks upgrade --resource-group az-rg-kangxh-aks --name kangxhakssea --kubernetes-version 1.16.7

# ensure the Mananged Identity has Contributor access to AKS and AKS Resources group.
#

# Create Ingress Controller first.
kubectl create namespace ingress

helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

# apply the deployment yaml from workloads folder.

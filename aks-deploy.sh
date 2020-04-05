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
az group create --name MSDNRGKangxhSEAAKS --location southeastasia

# Create aks spn
az ad sp create-for-rbac --skip-assignment --name spn-aks-cluster

    {
    "appId": "d5074a3a-9454-4f6d-8c95-6eb6a0a822ab",
    "displayName": "spn-aks-cluster",
    "name": "http://spn-aks-cluster",
    "password": "e2fb009c-7d5e-4215-b968-5b5331e9b337",
    "tenant": "kangxh.com"
    }

# transfer docker image from docker.io/kangxh to kangxhacrsea

# get dependent resource ID
OMSID=$(az monitor log-analytics workspace show --resource-group MSDNRGKangxhSEA -n kangxhloganalyticsea --query id -o tsv)
SUBNET=$(az network vnet subnet show --resource-group MSDNRGKangxhSEA --vnet-name kangxhvnetsea --name aks --query id -o tsv)
PIP=$(az network public-ip show --resource-group  MSDNRGKangxhSEAAKS --name kangxhpipseaaks --query id -o tsv)

# Create AKS
az aks create --resource-group MSDNRGKangxhSEAAKS \
    --name kangxhakssea \
    --ssh-key-value /mnt/c/kangxh/AzureLabs/SSHKey/common/id_rsa.pub \
    --admin-username allenk \
    --workspace-resource-id $OMSID \
    --enable-addons monitoring \
    --enable-managed-identity \
    --service-principal d5074a3a-9454-4f6d-8c95-6eb6a0a822ab \
    --client-secret e2fb009c-7d5e-4215-b968-5b5331e9b337 \
    --location southeastasia \
    --vm-set-type VirtualMachineScaleSets  \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET \
    --docker-bridge-address 172.17.0.1/16 \
    --service-cidr   192.168.0.0/24 \
    --dns-service-ip 192.168.0.10 \
    --load-balancer-outbound-ips $PIP \
    --node-resource-group MSDNRGKangxhSEAAKSResources \
    --nodepool-name b2pool \
    --node-vm-size Standard_B2s \
    --nodepool-labels sku=b2vm \
    --node-osdisk-size 30 \
    --node-count 2 \
    --attach-acr kangxhacrsea

# Add B4 node pool.
az aks nodepool add \
    --resource-group MSDNRGKangxhSEAAKS \
    --cluster-name kangxhakssea \
    --name b4pool \
    --node-vm-size Standard_B4ms \
    --labels sku=b4vm \
    --node-osdisk-size 30 \
    --node-count 2

# donwload kubectl credential
az aks get-credentials --resource-group MSDNRGKangxhSEAAKS --name kangxhakssea

# Update b2 & b4 node pool. b2 will run most of time to host web
az aks nodepool update --cluster-name kangxhakssea \
                       --name b2pool \
                       --resource-group MSDNRGKangxhSEAAKS \
                       --max-count 3 \
                       --min-count 1 \
                       --mode System 

az aks nodepool update --cluster-name kangxhakssea \
                       --name b4pool \
                       --resource-group MSDNRGKangxhSEAAKS \
                       --max-count 5 \
                       --min-count 1 \
                       --mode User 

# scale to min size to save cost.
az aks nodepool scale --cluster-name kangxhakssea --resource-group MSDNRGKangxhSEAAKS --name b2pool --node-count 1
az aks nodepool scale --cluster-name kangxhakssea --resource-group MSDNRGKangxhSEAAKS --name b4pool --node-count 1

# apply the deployment yaml from workloads folder.

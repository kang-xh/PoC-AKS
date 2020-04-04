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

# get dependent resource ID
OMSID=$(az monitor log-analytics workspace show --resource-group MSDNRGKangxhSEA -n kangxhloganalyticsea --query id -o tsv)
SUBNET=$(az network vnet subnet show --resource-group MSDNRGKangxhSEA --vnet-name kangxhvnetsea --name aks --query id -o tsv)

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
    --vm-set-type AvailabilitySet \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET \
    --docker-bridge-address 172.17.0.1/16 \
    --service-cidr   192.168.0.0/24 \
    --dns-service-ip 192.168.0.10 \
    --node-resource-group MSDNRGKangxhSEAAKSResources \
    --nodepool-name b2pool \
    --node-vm-size Standard_B2s \
    --nodepool-labels sku=b2vm \
    --node-osdisk-size 30 \
    --node-count 2 \
    --attach-acr kangxhacrsea





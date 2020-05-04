# setup enviornment to run the web site. static and configurations saved on Azure File Share.

AKS_PERS_STORAGE_ACCOUNT_NAME=kangxhsaseaweb
STORAGE_KEY=

kubectl create ns web
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY -n web


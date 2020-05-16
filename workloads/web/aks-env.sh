# setup enviornment to run the web site. static and configurations saved on Azure File Share.

AKS_PERS_STORAGE_ACCOUNT_NAME=kangxhsaseaweb
STORAGE_KEY=Bh00uv8QSbRXQffdORxVGx5seQT80+t2eWdLRVnREUjtNCjxVoVoBvNFBPQwlguP33k1VJSx7XxpC62vSLJokw==

<<<<<<< HEAD
kubectl create secret generic kangxhsaseaweb-secret --from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY -n web
=======
kubectl create ns web
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY -n web
>>>>>>> 027a07576de101b7739a7fde82e28f2023439279


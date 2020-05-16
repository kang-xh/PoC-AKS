# follow the method in https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15
cd ~/github/poc-aks/workloads/sql
kubectl create ns db
kubectl create secret generic mssql --from-literal=SA_PASSWORD="abcdabcdabcd" -n db

kubectl apply -f pvc.yaml
kubectl apply -f deploy.yaml
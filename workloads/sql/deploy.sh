# follow the method in https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15
cd ~/github/poc-aks/workloads/sql
kubectl create secret generic mssql --from-literal=SA_PASSWORD="defaultdbpassword"

kubectl apply -f pvc.yaml
kubectl apply -f 2019.yaml


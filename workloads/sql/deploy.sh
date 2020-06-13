# follow the method in https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15
cd ~/github/poc-aks/workloads/sql
kubectl create secret generic mssql --from-literal=SA_PASSWORD="defaultdbpassword"

kubectl apply -f pvc.yaml
kubectl apply -f deploy.yaml

# change disk access right for sql 2019 to fix the following error. 

    SQL Server 2019 will run as non-root by default.
    This container is running as user mssql.
    Your master database file is owned by root.
    To learn more visit https://go.microsoft.com/fwlink/?linkid=2099216.
    sqlservr: Unable to open /var/opt/mssql/.system/instance_id: Permission denied (13)
    /opt/mssql/bin/sqlservr: Unable to open /var/opt/mssql/.system//instance_id: Permission denied (13)

connect to 


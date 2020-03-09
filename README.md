### Demo Environment for AKS. 

    AKS deployed in Azure South East Asia. Feature gap can exist between global Azure and sovereign cloud. 

    This PoC is used to demo basic AKS functions, including availability, scalability, CICD. It is also used for other app service backend, like APIM, Application gateway. 


### Folder structure

    Name                Description
    ----------------------------------------------------------------
    ingress             Ingress controller deployment for kubernetes
    jekins              Jekins configuration for CICD
    prometheus          Cluster, PoD, Service monitoring 
    secrets             
    vote                Demo applciation

### Deployment Topology

![aks](images/aks.jpg)
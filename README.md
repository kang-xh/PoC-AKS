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

### Web Site URL Path

    www.kangxh.com                  <--->   web application

    Route by ingress controller
    ngix.kangxh.com\vote            <--->   vote-web service (AKS)
    ngix.kangxh.com\api\votes       <--->   vote-api service (AKS)
    ngix.kangxh.com\api\tasks       <--->   task-api service (AKS)

    Route by apim
    apim.kangxh.com\api\votes       <--->   vote-api service (AKS)
    apim.kangxh.com\api\tasks       <--->   task-api service (AKS)

### Deployment Topology

![aks](images/aks.jpg)
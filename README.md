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

    www.kangxh.com                  <--->   main domain hosted by app service
    vote.kangxh.com                 <--->   vote web site

    vote.kangxh.com/api/votes       <--->   mock vote api
    task.kangxh.com/api/tasks       <--->   task api

    ocr-fr.kangxh.com               <--->   OCR Form Recognizer Label tool. Use Firefox to access. 

    Route by apim, https only
    https://apim.kangxh.com/task/api/tasks       <--->   task-api service (AKS), APIM is normally deleted to save cost.

### Deployment Topology

![aks](images/aks.jpg)
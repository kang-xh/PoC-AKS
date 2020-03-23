### Demo Environment for AKS. 

    AKS deployed in Azure South East Asia. Feature gap can exist between global Azure and sovereign cloud. 

    This PoC is used to demo basic AKS functions, including availability, scalability, CICD. It is also used for other app service backend, like APIM, Application gateway. 


### Folder structure

| name      | usage | Description                                   |
|----       | ----  | ----                                          |
|task       | app   | demo application for api                      |
|vote       | app   | demo application for web + api                |
|ai         | app   | demo app for AI solution                      |
|----       | ----                                                  |
|monitor    | infra | log analytic with aks                         |
|cicd       | infra | CICD with Azure DevOps & Jenkins              |
|cheatsheet | infra | environment setup and demo script             |
|misc       | infra | azure service co-work with aks                |


### Web Site URL Path

    www.kangxh.com                  <--->   main domain hosted by app service
    
    vote.kangxh.com                 <--->   vote web site
    vote.kangxh.com/api/votes       <--->   mock vote api

    task.kangxh.com/api/tasks       <--->   task api
    task.kangxh.com/metrics         <--->   promethues export endpoint

    ocr-fr.kangxh.com               <--->   OCR Form Recognizer Label tool. 

### Deployment Topology

![aks](images/aks.jpg)
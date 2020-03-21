#### This is to run form recognize docker and sample label tool in aks.

##### reference

    docker run -it -p 3000:80 mcr.microsoft.com/azure-cognitive-services/custom-form/labeltool eula=accept

##### environment

    namespace: ai

    POD: 
        ocr-fr-labeltool
        ocr-fr-apiserver

    Svc: 
        labeltool - web portal to use label tool



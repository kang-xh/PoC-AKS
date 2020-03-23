#### This is to run form recognize docker and sample label tool in aks.

##### reference

    docker run -it -p 3000:80 mcr.microsoft.com/azure-cognitive-services/custom-form/labeltool eula=accept

    To run the image in AKS, add args "eula=accept" for deployment spec. 

##### environment

    namespace: ai

    POD: 
        ocr-fr-labeltool

    Svc: 
        ocr-fr-labeltool - ClusterIP

    Ingress:
        ingress-ocr-fr-labeltool - ocr-fr.kangxh.com, port 80

##### Azure Env

    project configuration is saved in the storage account. Token info need to be saved if need to open the project from new client.

    Name: fapiao token
    Key: FYZm9o/Tc8ddQB7gt1+QVN1oJ/327nyuC1F7rYjzpm4=

    kangxhocrseaform
    Endpoint: https://kangxhocrseaform.cognitiveservices.azure.com/
    key:             

    Storage Account: kangxhsaseaai
    container: form
    policy: fullcontrol

    https://kangxhsaseaai.blob.core.windows.net/form?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-03-22T10:30:28Z&st=2020-03-22T02:30:28Z&spr=https&sig=LwbqImVEo3E0G9rb8ayF3n4UEtD2FhPcEs2Re037fL8%3D

    has to use Firefox to access the service. Chrome and Edge reports error about "ImportKey undefined"




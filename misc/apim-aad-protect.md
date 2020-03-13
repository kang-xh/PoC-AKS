### Environment

    - APIM + AKS on Global Azure, South East Asia
    - all the AKS services are internal. 
    - api and web interface is published through AKS ingress controller to kangxh.com.
    - put APIM before aks for API management. 
    - Use Mooncake AAD as authority to protect API access. 

    cons: 
    - API can still be accessed via kangxh.com, like task.kangxh.com/api/tasks, without protection.
    - addtion configuration required in ingress controller to whitelist the IP from APIM to control only APIM request can be routed. 

#### Reference link: 

    https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-scenarios
    https://docs.azure.cn/zh-cn/active-directory/azuread-dev/v1-oauth2-client-creds-grant-flow
    https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad
    https://docs.microsoft.com/en-us/azure/active-directory/develop/delegated-and-app-perms


#### Register an application in Azure AD to represent the API

##### Create application

    apim-kangxh-api-server

    app id:         01ac1528-df5f-4185-9eea-xxxxxxxxxxxx
    tenant id:      99d86385-9b07-4221-9a3a-xxxxxxxxxxxx
    object id:      7c6ba4bb-0687-407f-b153-93b61673f6d2
    Redirect uri:   https://apim-kangxh-api-server-redirect-uri

##### Add Scope in Expose an API. 

    api id: api://01ac1528-df5f-4185-9eea-d73c7130207a, change it to api://kangxh-com-api-tasks
    Consent: admin+user

    api://kangxh-com-api-tasks/Files.Read
    api://kangxh-com-api-tasks/Files.Write

#### Regsitry Client application: 

    apim-kangxh-client-app
    app id:         e1a9a92c-724c-4cfd-bf4f-xxxxxxxxxxxx
    tenant id:      99d86385-9b07-4221-9a3a-xxxxxxxxxxxx
    object id:      aec28554-841d-4b11-892f-5474778f4d10
    Redirect uri:   https://apim-kangxh-client-app-redirect-uri

secret*

    Description:    apim aad protection - validation-JWT PoC - client 1
    Value:          abcdabcdabcdabcdabcdabcdabcdabcd

    Description:    apim aad protection - validation-JWT PoC - client 2
    Value:          abcdabcdabcdabcdabcdabcdabcdabcd

    - secrets can be deployed to different org to control the api access from AAD site. when the right need to be revoked, remove the secret
    - this manangement is from AAD side, no need to change APIM configuration. 
    - another idea for client managment is to use subscription key in APIM. this will offload the managment taks in APIM, instead of AAD.
    
#### Grant permissions in Azure AD

    - This will grant permissions to access the API object in AAD. 
    - As the environment indicates, APIM+AKS deployed in global azure while the app and server ID created in China AAD. there is not any real relationship between them. we just create the object in AAD logically to stands for client and server. 

permission type: 

    Since Delegated permission is used, when authenticate with Client + Secret, no scope claim in the received token

    **Application permissions**. Your client application needs to access the web API directly as itself, without user context. This type of permission requires administrator consent. This permission isn't available for desktop and mobile client applications.

    **Delegated permissions**. Your client application needs to access the web API as the signed-in user, but with access limited by the selected permission. This type of permission can be granted by a user unless the permission requires administrator consent.

#### Summary: 

    the oAUTH 2.0 + AAD + Validation-JWT policy process acutally are divided into to seperate stage: 

    1. authentication/autherization with AAD to get a token using your client logic. 
    2. the autherization happened in seperated AAD env just to locally verify the access right with token issued. 
    3. it does not matter which oauth flow we follow. What APIM need is only a token. 
   
    4. based on what token claims we can get, define your Validation-JWT policy. 

#### NOTE

it is a headache in China to follow the doc as many endpoints are still refer to global end point. be sure to use China endpoint. Make sure to use the same version endpoints. 

v2: 

    OAuth 2.0 authorization endpoint (v2)
    https://login.chinacloudapi.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/oauth2/v2.0/authorize

    OAuth 2.0 token endpoint (v2)
    https://login.chinacloudapi.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/oauth2/v2.0/token

    OpenID Connect metadata document v2
    https://login.chinacloudapi.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/v2.0/.well-known/openid-configuration

v1: 
    OAuth 2.0 authorization endpoint (v1)
    https://login.chinacloudapi.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/oauth2/authorize

    OAuth 2.0 token endpoint (v1)
    https://login.chinacloudapi.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/oauth2/token

    OpenID Connect metadata document v1
    https://login.partner.microsoftonline.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/.well-known/openid-configuration

Sample Policy  

    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="@((string)context.LastError.Message)" require-scheme="Bearer" require-signed-tokens="true">
        <openid-config url="https://login.partner.microsoftonline.cn/99d86385-9b07-4221-9a3a-xxxxxxxxxxxx/.well-known/openid-configuration" />
        <required-claims>
                <claim name="aud" match="all">
                    <value>api://kangxh-com-api-tasks</value>
                </claim>
        </required-claims>
    </validate-jwt>



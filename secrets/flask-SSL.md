### create cert and key pair using my Private Cert. 

    openssl pkcs12 -in wildcard_kangxh_com.pfx -nodes -out wildcard_kangxh_com.pem
    openssl pkcs12 -in wildcard_kangxh_com.pfx -nocerts -nodes -out wildcard_kangxh_com.key

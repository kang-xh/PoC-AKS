### Cert, Key Management 

#### Convert cer pfx to pem format. 
    C:\OpenSSL\bin\openssl pkcs12 -in wildcard_kangxh_com.pfx -nodes -out wildcard_kangxh_com_with_key.pem 
    C:\OpenSSL\bin\openssl x509 -inform der -in wildcard_kangxh_com.cer -out wildcard_kangxh_com_without_key.pem

#### Create key pair
    C:\OpenSSL\bin\openssl pkcs12 -in wildcard_kangxh_com.pfx -nocerts -nodes -out private_pair.key

#### Create private key
    C:\OpenSSL\bin\openssl rsa -in  private_pair.key -out kangxh.com_pri_key.pem

#### Create public key
    C:\OpenSSL\bin\openssl rsa -in  private_pair.key -pubout -out kangxh.com_pub_key.pem

### enable flask SSL
    app.run(ssl_context=('wildcard_kangxh_com_without_key.pem', 'kangxh.com_pri_key.pem'))
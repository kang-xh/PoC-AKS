#### task API

- it is a sample app the show api server in AKS.
- deploy the service behind an internal load balancer and expose with ingress.
- apply aks_prometheus_config_map to tell Azure monitor get mock app metrix at /metrix endpoint.
- view monitor details in monitor catalog.
- task POD will only be scheduled on b2vm
#### vote 

- it is a sample app the show web service with redis cache. it has another container with mock API enabled. 
- in common demo, only the vote-web and vote-db is deployed. for api demo, use /workloads/tasks
- deploy the service behind an internal load balancer and expose with ingress.
- task POD will only be scheduled on b2vm
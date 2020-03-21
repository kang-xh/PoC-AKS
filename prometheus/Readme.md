#### logic
    prometheus server is not required as Azure Monitor is able to scraping metrics data directly and save it to log analytics workspace.

    enable Azure Monitor for container to deploy the omsagent POD to cluster. 

#### Env:

    task-api using prometheus_client to export a fake gauge metrics data: 

    # HELP task_process_time_in_ms Task process time in ms. Random & Fake
    # TYPE task_process_time_in_ms gauge
    task_process_time_in_ms 100.0


#### enabled the capture by ConfigMap under /taks/aks_prometheus_config_map.yaml

    kubectl apply -f aks_prometheus_config_map.yaml

    restart omsagent pod

    kubectl log omsagentxxxx -n kube-system

    ****************Start Prometheus Config Processing********************
    config::configmap container-azm-ms-agentconfig for settings mounted, parsing values for prometheus config map       
    config::Successfully parsed mounted prometheus config map
    config::Successfully passed typecheck for config settings for daemonset
    config::Starting to substitute the placeholders in telegraf conf copy file for daemonset
    config::Successfully substituted the placeholders in telegraf conf file for daemonset
    config::Successfully created telemetry file for daemonset
    ****************End Prometheus Config Processing********************

#### Check capture data in log analytics:

    InsightsMetrics
    | where Namespace == "prometheus" 
    | project Computer , Namespace, Name, Val , TimeGenerated 
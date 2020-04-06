#### Check capture data in log analytics:

    InsightsMetrics
    | where Namespace == "prometheus" 
    | project Computer , Namespace, Name, Val , TimeGenerated 
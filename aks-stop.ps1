# Powershell runbook to stop VMSS instances in AKS deployment to save cost. 
# only keep one b2 node to keep it alive all the time.
# stop all the other node instance.
# do not change AKS nodepool scale, only shutdown the unnecessary VMs

Logout-AzAccount
Login-AzAccount -Environment AzureCloud 

$aksResourceRG = "MSDNRGKangxhSEAAKSResources"

$nodepools = Get-AzVmss -ResourceGroupName $aksResourceRG
foreach ($nodepool in $nodepools)
{
    if ($nodepool.Name -like "aks-b2pool*") 
    {
        for ($i=1; $i -lt $nodepool.Sku.Capacity)
        {
            Stop-AzVmss -ResourceGroupName $aksResourceRG -VMScaleSetName $nodepool.Name -InstanceId "$i" -Force
            $i++
        }
    }
    else
    {
        Stop-AzVmss -ResourceGroupName $aksResourceRG -VMScaleSetName $nodepool.name -Force
    }
}


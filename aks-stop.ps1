# Powershell runbook to stop VMSS instances in AKS deployment to save cost. 
Logout-AzAccount
Login-AzAccount -Environment AzureCloud 

$nodepools = Get-AzVmss -ResourceGroupName MSDNRGKangxhSEAAKSResources
foreach ($nodepool in $nodepools)
{
   Stop-AzVmss -ResourceGroupName MSDNRGKangxhSEAAKSResources -VMScaleSetName $nodepool.name -Force
}

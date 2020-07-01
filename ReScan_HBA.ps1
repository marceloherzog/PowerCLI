Connect-VIServer VCENTER_NAME
$cluster = Get-Cluster -name CLUSTER_NAME
$hostlist = Get-VMHost -location $cluster | Sort-Object
foreach ($myhost in $hostlist) {
 Get-VMHostStorage -VMHost $myhost -RescanAllHba -RescanVmfs
}
Disconnect-VIServer -Confirm:$false

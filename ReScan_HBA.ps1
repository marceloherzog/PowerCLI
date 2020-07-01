Connect-VIServer vim-vm01-vcsa06.oss.timbrasil.com.br
$cluster = Get-Cluster -name FLA04_SILO_IMS_CORE*
$hostlist = Get-VMHost -location $cluster | Sort-Object
foreach ($myhost in $hostlist) {
 Get-VMHostStorage -VMHost $myhost -RescanAllHba -RescanVmfs
}
Disconnect-VIServer -Confirm:$false
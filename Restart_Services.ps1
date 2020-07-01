Connect-VIServer vim-vm01-vcsa10.oss.timbrasil.com.br
$mycluster = Get-Cluster BLM01_AAA
$hostlist = Get-VMHost -Location $mycluster | Sort-Object
foreach ($myhost in $hostlist) {

#$vpxa = Get-VMHost -Name $myhost | Get-VMHostService | where {$_.key -eq 'vpxa'}
#$fdm = Get-VMHost -Name $myhost | Get-VMHostService | where {$_.key -eq 'vmware-fdm'}
#$esxi_shell = Get-VMHost -Name $myhost | Get-VMHostService | where {$_.key -eq 'TSM'}
$ssh = Get-VMHost -Name $myhost | Get-VMHostService | where {$_.key -eq 'TSM-SSH'}

#Restart-VMHostService -HostService $vpxa -Confirm:$false
#Restart-VMHostService -HostService $fdm -Confirm:$false
#Restart-VMHostService -HostService $esxi_shell -Confirm:$false
#Stop-VMHostService -HostService $esxi_shell -Confirm:$false
Stop-VMHostService -HostService $ssh -Confirm:$false

}
Disconnect-VIServer -Confirm:$false

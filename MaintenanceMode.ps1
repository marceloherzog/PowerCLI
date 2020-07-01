#
if ($vccred) { Remove-Variable vccred }
if ($global:DefaultVIServers) { Disconnect-VIServer -Server * -Confirm:$false }

$vccred = Get-Credential -Credential herzog
if (-not $vccred) { Return "Invalid Credential" }

# Variables
$vcenter = "XXX"
$mycluster = "XXX"

Connect-VIServer $vcenter -Credential $vccred | Out-Null
if (-not $?) { Return "Unable to connect to vCenter: Check Reason on Error Message above" }

$lista = Get-VMHost -Location $mycluster | Sort-Object

foreach ( $esxi in $lista ) {
 $hasVM = $esxi | Get-VM
 if ($hasVM.Count -eq 0) {
  Write-Host -ForegroundColor White "Host $($esxi.Name) is empty." -NoNewline
  $option = Read-Host " Put in Maintenance Mode? <Y/N>"
  if ($option -eq "y") {
   $esxi | Set-VMHost -State Maintenance -RunAsync -Confirm:$false
   } #End If Option
  } else {
  Write-Host -ForegroundColor White "Host $($esxi.Name) is not empty. There are $($hasVM.Count) VMs inside"
  } #End If Has VM

  } #End Foreach Host
Disconnect-VIServer -Server $vcenter -Confirm:$false

if ($vccred) { Remove-Variable vccred }
if ($global:DefaultVIServers) { Disconnect-VIServer -Server * -Confirm:$false }

$vccred = Get-Credential -Credential LOGIN
if (-not $vccred) { Return "Invalid Credential" }

$ClusterWildCard = "*CLUSTER_NAME"

$vclist = "VCENTER_LIST"

foreach ($myvc in $vclist) {

  Connect-VIServer $myvc -Credential $vccred | Out-Null
  if (-not $?) { Return "Unable to connect to vCenter: Check Reason on Error Message above" }
  $clusterlist = Get-Cluster -Name $ClusterWildCard | Sort-Object

  foreach ($mycluster in $clusterlist) {
    Write-Host ""
    Write-Host -ForegroundColor DarkGreen "Checking Cluster: " -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkBlue $mycluster.Name -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkGreen " @ $($myvc)" -BackgroundColor Yellow

  foreach ($mycluster in $clusterlist) { 
    $vmlist = Get-VM -Location $mycluster; 
    foreach ($myvm in $vmlist) { 
        if($myvm.ExtensionData.Snapshot) {
            #Write-Host "$($myvm.Name) has snapshot. Would you like to remove it? " -NoNewline
            #$confirm = Read-Host "<Y/N> "
            #if ($confirm -eq "y") {
                $myvm | Get-Snapshot | Sort-Object -Property Created | Select -First 1 | Remove-Snapshot -RemoveChildren -Confirm:$false
            #} else { 
            #    Write-Host "Skipping..."
            #} 
        }
     } 
  }
  #Read-Host "Pressione <ENTER> para continuar..."
  } #End Foreach Cluster

  Disconnect-VIServer -Server $myvc -Confirm:$false
} #End Foreach vCenter

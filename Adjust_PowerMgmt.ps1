if ($vccred) { Remove-Variable vccred }
if ($global:DefaultVIServers) { Disconnect-VIServer -Server * -Confirm:$false }

$vccred = Get-Credential -Credential F8073716
if (-not $vccred) { Return "Invalid Credential" }

$ClusterWildCard = "*UDC*"
$VDSWildCard = "*UDC*"

$vclist = "nfvvm01-vcn-01.timbrasil.nfvi","nfvvm01-vcn-05.timbrasil.nfvi"

foreach ($myvc in $vclist) {

  Connect-VIServer $myvc -Credential $vccred | Out-Null
  if (-not $?) { Return "Unable to connect to vCenter: Check Reason on Error Message above" }
  $clusterlist = Get-Cluster -Name $ClusterWildCard

  foreach ($mycluster in $clusterlist) {
    Write-Host ""
    Write-Host -ForegroundColor DarkGreen "Checking Cluster: " -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkBlue $mycluster.Name -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkGreen " @ $($myvc)" -BackgroundColor Yellow

  $hostlist = Get-VMHost -Location $mycluster | Sort-Object
   foreach ($myhost in $hostlist) {
    
    Write-Host -ForegroundColor Cyan "Verifying Host: " -NoNewline
    Write-Host -ForegroundColor White $myhost.Name -NoNewline
    Write-Host -ForegroundColor Cyan "... " -NoNewline

    $Configured = $myhost.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName
    if ($Configured -ne "static") {
     Write-Host -ForegroundColor Red $Configured
     Write-Host -ForegroundColor Magenta "Rectifying Power Management Policy: " -NoNewline
     $view = (Get-VMHost $myhost | Get-View)
     (Get-View $view.ConfigManager.PowerSystem).ConfigurePowerPolicy(1) | Out-Null
     sleep(1)
     $result = (Get-VMHost $myhost).ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName
     if ($result -eq "static") {
      Write-Host -ForegroundColor Green "High Performance"
      } else {
      Write-Host -ForegroundColor Red "Error: Configuring Power Policy"
      } #End If Result
    } else {
     Write-Host -ForegroundColor Green "High Performance"
    } #End If Validation
    
   } #End Foreach Host

  } #End Foreach Cluster
  Read-Host "Press <ENTER> for next Cluster..."

  Disconnect-VIServer -Server $myvc -Confirm:$false
} #End Foreach vCenter
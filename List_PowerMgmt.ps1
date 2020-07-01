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

    $myhost | Select Name,
    @{ N="CurrentPolicy"; E={$_.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName}},
    @{ N="AvailablePolicies"; E={$_.ExtensionData.config.PowerSystemCapability.AvailablePolicy.ShortName}}
    <#
        $view = (Get-VMHost -Name $myHost.Name | Get-View)
        (Get-View $view.ConfigManager.PowerSystem).ConfigurePowerPolicy(1) | Out-Null
    #>
   } #End Foreach Host

  } #End Foreach Cluster
  Write-Host ""

  Disconnect-VIServer -Server $myvc -Confirm:$false
} #End Foreach vCenter
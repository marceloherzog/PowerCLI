#
if ($vccred) { Remove-Variable vccred }
if ($global:DefaultVIServers) { Disconnect-VIServer -Server * -Confirm:$false }

$vccred = Get-Credential -Credential F8073716

$vclist = "nfvvm01-vcn-01.timbrasil.nfvi","nfvvm01-vcn-02.timbrasil.nfvi","nfvvm01-vcn-03.timbrasil.nfvi", "nfvvm01-vcn-05.timbrasil.nfvi",
          "vim-vm01-vcsa00.oss.timbrasil.com.br", "vim-vm01-vcsa01.oss.timbrasil.com.br", "vim-vm01-vcsa02.oss.timbrasil.com.br", 
          "vim-vm01-vcsa03.oss.timbrasil.com.br", "vim-vm01-vcsa04.oss.timbrasil.com.br", "vim-vm01-vcsa05.oss.timbrasil.com.br", 
          "vim-vm01-vcsa06.oss.timbrasil.com.br", "vim-vm01-vcsa07.oss.timbrasil.com.br", "vim-vm01-vcsa08.oss.timbrasil.com.br", 
          "vim-vm01-vcsa09.oss.timbrasil.com.br", "vim-vm01-vcsa10.oss.timbrasil.com.br"

$ClusterWildCard = "*"

foreach ($myvc in $vclist) {

  Connect-VIServer $myvc -Credential $vccred | Out-Null
  if (-not $?) { Return "Unable to connect to vCenter: Check Reason on Error Message above" }

  $clusterlist = Get-Cluster -Name $ClusterWildCard | Sort-Object

  foreach ($mycluster in $clusterlist) {
    Write-Host ""
    Write-Host -ForegroundColor DarkGreen "Checking Cluster: " -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkBlue $mycluster.Name -BackgroundColor Yellow -NoNewline
    Write-Host -ForegroundColor DarkGreen " @ $($myvc)" -BackgroundColor Yellow

    $esxilist = Get-VMHost -Location $mycluster | Sort-Object

    foreach ($myesxi in $esxilist) {

      write-host -ForegroundColor Cyan $myesxi.name -NoNewline
      write-host " ... " -NoNewline

        Get-VMHostFirmware -VMHost $myesxi

 

    } #End Foreach ESXi


  } #End Foreach Cluster
 
  Disconnect-VIServer -Server $myvc -Confirm:$false

} #End Foreach vCenter
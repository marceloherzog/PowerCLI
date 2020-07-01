#
if ($vccred) { Remove-Variable vccred }
if ($global:DefaultVIServers) { Disconnect-VIServer -Server * -Confirm:$false }

$vccred = Get-Credential -Credential herzog

$vclist = "XXX","XXX"

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

      $esxcli = Get-EsxCli -VMHost $myesxi -V2
<#
      $esxcliargs = $esxcli.system.account.add.CreateArgs()
      $esxcliargs.Item('description') = 'Administrator'
      $esxcliargs.Item('id') = "offline"
      $esxcliargs.Item('password') = "XXX"
      $esxcliargs.Item('passwordconfirmation') = "XXX"
      $esxcli.system.account.add.Invoke($esxcliargs) | Out-Null

      $esxcliper = $esxcli.system.permission.set.CreateArgs()
      $esxcliper.id = $esxcliargs.id
      $esxcliper.group = "false"
      $esxcliper.role = "Admin"
      $esxcli.system.permission.set.Invoke($esxcliper)

      $esxcliper = $esxcli.system.permission.unset.CreateArgs()
      $esxcliper.id = $esxcliargs.id
      $esxcli.system.permission.unset.Invoke($esxcliper)

      $esxclirem = $esxcli.system.account.remove.CreateArgs()
      $esxclirem.id = $esxcliargs.id
      $esxcli.system.account.remove.Invoke($esxclirem)

      if ($?) {
        Write-Host -ForegroundColor Green "OK" -NoNewline
       } else {
        Write-Host -ForegroundColor Red "Failed" -NoNewline
      } #End If

      Remove-Variable esxcliargs
#>
      $esxcliargs = $esxcli.system.account.set.CreateArgs()
      $esxcliargs.Item('description') = 'Administrator'
      $esxcliargs.Item('id') = 'root'
      $esxcliargs.Item('password') = 'XXX'
      $esxcliargs.Item('passwordconfirmation') = 'XXX'
      $esxcli.system.account.set.Invoke($esxcliargs) | Out-Null

      if ($?) {
        Write-Host -ForegroundColor Green "OK"
       } else {
        Write-Host -ForegroundColor Red "Failed"
      } #End If

      Remove-Variable esxcliargs
      Remove-Variable esxcli

    } #End Foreach ESXi


  } #End Foreach Cluster
 
  Disconnect-VIServer -Server $myvc -Confirm:$false

} #End Foreach vCenter

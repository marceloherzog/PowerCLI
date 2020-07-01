Connect-VIServer VCENTER_NAME
$mycluster = CLUSTER_NAME
$hostlist = Get-VMHost -Location $mycluster | Sort-Object
# NTP Servers Array
 $NTPServers = ""
foreach ($myhost in $hostlist) {

$ntpsrvs = $myhost.ExtensionData.Config.DateTimeInfo.NtpConfig.Server
    foreach ($ntp in $ntpsrvs) {
     Remove-VMHostNtpServer -NtpServer $ntp -VMHost $myhost -Confirm:$false
    }

foreach ($ntpsrv in $NTPServers) {
 Add-VMHostNtpServer -VMHost $myhost -NtpServer $ntpsrv -Confirm:$false
 }

}
Disconnect-VIServer -Confirm:$false

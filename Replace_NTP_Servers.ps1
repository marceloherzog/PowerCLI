Connect-VIServer vim-vm01-vcsa06.oss.timbrasil.com.br
$mycluster = Get-Cluster FLA01_SILO_IMS_SBC_01
$hostlist = Get-VMHost -Location $mycluster | Sort-Object
# NTP Servers Array
 $NTPServers = "10.216.96.174","10.192.12.200","10.221.6.229","10.223.49.160"
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
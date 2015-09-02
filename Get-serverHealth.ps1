$eserver = 'e1.ktehnika.local'

Get-ServerHealth $eserver | ?{$_.HealthSetName -eq "ActiveSync"}

Invoke-MonitoringProbe ActiveSync\ActiveSyncCTPProbe -Server $eserver | Format-List
Invoke-MonitoringProbe -Identity ActiveSync.Protocol\ActiveSyncSelfTestProbe -Server $eserver
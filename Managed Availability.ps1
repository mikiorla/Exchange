
#http://blogs.technet.com/b/exchange/archive/2013/06/13/what-did-managed-availability-just-do-to-this-service.aspx

$server = 'E1'

Get-HealthReport -Identity $server | ? AlertValue -EQ Unhealthy

Get-ServerHealth -Identity $server

#Recovery Action Log -> Microsoft.Exchange.ManagedAvailability/RecoveryActions
#Event 500 indicates that a recovery action has begun.
# Event 501 indicates that the action that was taken has completed
$RecoveryActionResultsEvents = Get-WinEvent –ComputerName $server -LogName Microsoft-Exchange-ManagedAvailability/RecoveryActionResults
$RecoveryActionResultsXML = ($RecoveryActionResultsEvents | Foreach-object -Process {[XML]$_.toXml()}).event.userData.eventXml


#Finding the Monitor that Triggers a Responder
#Health Set is a grouping of related Monitors

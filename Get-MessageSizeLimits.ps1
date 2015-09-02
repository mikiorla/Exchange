
$user = Read-host "Enter username to check"

Write-host 'Organizational limits - Transport Config' -ForegroundColor Yellow -NoNewline
Get-TransportConfig | ft MaxReceiveSize, MaxSendSize, MaxRecipientEnvelopeLimit
#Get-TransportRule


Write-host 'Receive Connector limits'  -ForegroundColor Yellow -NoNewline
Get-ReceiveConnector -Server e1 | ft Name,MaxHeaderSize,MaxMessageSize,MaxRecipientsPerMessage

Write-host 'Send Connector limits'  -ForegroundColor Yellow -NoNewline
Get-SendConnector | ft Name,MaxHeaderSize,MaxMessageSize,MaxRecipientsPerMessage

Write-host 'Server limits - Transport Service'  -ForegroundColor Yellow -NoNewline
Get-TransportService | ft PickupDirectoryMaxHeaderSize,PickupDirectoryMaxRecipientsPerMessage

if ($user)
{
Write-host 'User limits '$user -ForegroundColor Yellow -NoNewline
Get-Mailbox $user | ft MaxSendSize,MaxReceiveSize,RecipientLimits
}
else {Write-host 'User limits not checked!' -ForegroundColor Yellow -NoNewline}
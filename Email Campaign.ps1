#email compaing

#created Transport rule, not neccesery
#Wait for QMAIL Reply

#create AutoReply message on Qmail
#_________________________________
#get-MailboxAutoReplyConfiguration -Identity qmail
#Set-MailboxAutoReplyConfiguration -Identity qmail -ExternalMessage "Thank you for reply!" -AutoReplyState:enabled

#EWS API
#_______
#http://www.nuget.org/packages/Microsoft.Exchange.WebServices/

<# Create new contact
$paramsMailContact = @{
Name = 'Milan Orlovic KT365'
Alias='milanKT365'
OrganizationalUnit='OU=it-cs.rs,DC=ktehnika,DC=local'
ExternalEmailAddress='milan@kt.rs'
}
New-MailContact @paramsMailContact
#>

#$contacts = Get-MailContact | ? {$_.WhenCreated -lt '1/1/2014'} #created before 2014
$contacts = Get-MailContact
$emailSubject =  "Verifyng email address"
$REemailSubject = 'Re: Verifyng email address'

foreach ($contact in $contacts)
{
$Error.Clear()
Send-MailMessage -To $contact.WindowsEmailAddress -Subject $emailSubject -Body "Please reply to this message!" -SmtpServer e1 -From qmail@ktehnika.co.rs
$Error

#add email address to log file
}

#region check mailbox Qmail for messages with Subject

$email    = "qmail@ktehnika.co.rs"
$username = "qmail"
$password = "user pass"
$domain   = "ktehnika"

$asembly = 'D:\_scripts\EWS\Microsoft.Exchange.WebServices.2.2\lib\40\Microsoft.Exchange.WebServices.dll'
[void] [Reflection.Assembly]::LoadFile($asembly)

$s = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService
$s.Credentials = New-Object Net.NetworkCredential($username, $password, $domain)
$s.AutodiscoverUrl($email) 

$inbox = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($s,[Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox)
Write-host -fore Yellow "Unread count:" -NoNewline;Write-host $inbox.UnreadCount
Write-host -fore Yellow "Total count:" -NoNewline;Write-host $inbox.TotalCount

#$psPropertySet = new-object Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::FirstClassProperties)
#$psPropertySet.RequestedBodyType = [Microsoft.Exchange.WebServices.Data.BodyType]::Text;

#$items = $inbox.FindItems($inbox.TotalCount)
#$items | % $_.Sender.Address
#$items.Sender.Address
foreach ($sender in $inbox.FindItems($inbox.TotalCount)) {$sender.Sender.Address}

#$items = $inbox.FindItems(5) | select ConversationTopic,From,Sender,Subject
#$items.Sender.Address
#endregion

#Get-MessageTrackingLog -Sender qmail@ktehnika.co.rs -MessageSubject "Automatic reply: Verifyng email address" | select MessageSubject,Recipients,Timestamp

#http://stackoverflow.com/questions/4454165/how-to-check-an-exchange-mailbox-via-powershell


# work with exchange server to retrieve messages
# see this SO answer: http://stackoverflow.com/a/4866894

# call this script using dot-source (see http://technet.microsoft.com/en-us/library/ee176949.aspx)
# to allow continued use of the objects, specifically, reading our inbox
# e.g...
# . C:\Path\To\Script\Outlook_ReadInbox.ps1

# replace with your email address
$email    = "qmail@ktehnika.co.rs"

# only need to populate these if you're impersonating...
$username = "qmail"
$password = "Novisad1"
$domain   = "ktehnika"

# to allow us to write multi-coloured lines
# see http://stackoverflow.com/a/2688572
# usage: Write-Color -Text Red,White,Blue -Color Red,White,Blue
# usage: Write-Color Red,White,Blue Red,White,Blue
function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}

# load the assembly
$asembly = 'D:\_scripts\EWS\Microsoft.Exchange.WebServices.2.2\lib\40\Microsoft.Exchange.WebServices.dll'
[void] [Reflection.Assembly]::LoadFile($asembly)

# set ref to exchange, first references 2007, 2nd is 2010 (default)
#$s = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2007_SP1)
$s = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService

# use first option if you want to impersonate, otherwise, grab your own credentials
$s.Credentials = New-Object Net.NetworkCredential($username, $password, $domain)

#$s.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
#$s.UseDefaultCredentials = $true

# discover the url from your email address
$s.AutodiscoverUrl($email)

# get a handle to the inbox
$inbox = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($s,[Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox)

#create a property set (to let us access the body & other details not available from the FindItems call)
$psPropertySet = new-object Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::FirstClassProperties)
$psPropertySet.RequestedBodyType = [Microsoft.Exchange.WebServices.Data.BodyType]::Text;

$items = $inbox.FindItems(5)
#$items = $inbox.FindItems(5) | select ConversationTopic,From,Sender,Subject
#$items.Sender.Address

#set colours for Write-Color output
$colorsread = "Yellow","White"
$colorsunread = "Red","White"

# output unread count
Write-Color -Text "Unread count: ",$inbox.UnreadCount -Color $colorsread
Write-Color -Text "Total count: ",$inbox.TotalCount -Color $colorsread

foreach ($item in $items.Items)
{
  # load the property set to allow us to get to the body
  $item.load($psPropertySet)

  # colour our output
  If ($item.IsRead) { $colors = $colorsread } Else { $colors = $colorsunread }

  #format our body
  #replace any whitespace with a single space then get the 1st 50 chars
  $bod = $item.Body.Text -replace '\s+', ' '
  $bod = $bod.Substring(0,50)
  $bod = "$bod..."

  # output the results - first of all the From, Subject, References and Message ID
  write-host "====================================================================" -foregroundcolor White
  Write-Color "From:    ",$($item.From.Name) $colors
  Write-Color "Subject: ",$($item.Subject)   $colors
  Write-Color "Body:    ",$($bod)            $colors
  write-host "====================================================================" -foregroundcolor White
  ""
}


# display the newest 5 items
#$inbox.FindItems(5)
# display the unread items from the newest 5
#$inbox.FindItems(5) | ?{$_.IsRead -eq $False} | Select Subject, Sender, DateTimeSent | Format-Table -auto

# returns the number of unread items
# $inbox.UnreadCount


#see these URLs for more info
# EWS
# folder members: http://goo.gl/vFy0p
# exporting headers: http://www.stevieg.org/tag/how-to/
# read emails with EWS: http://goo.gl/or8fh
# Powershell
# multi-color lines: http://stackoverflow.com/a/2688572



# download the Exchange Web Services Managed API 1.2.1 from
# http://www.microsoft.com/en-us/download/details.aspx?id=30141
# extract somewhere, e.g. ...
# msiexec /a C:\Users\YourUsername\Downloads\EwsManagedApi.msi /qb TARGETDIR=C:\Progs\EwsManagedApi


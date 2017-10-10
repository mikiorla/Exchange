#if (get-pssnapin -notlike 
#{Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010}
#Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

if ($host.name -eq "Windows PowerShell ISE Host")
     { Write-Warning "You should run this script in Powershell console"
      #exit
      }
else {
      Clear-Host
      [console]::SetWindowSize([console]::LargestWindowWidth,[console]::LargestWindowHeight)
      $m = $Host.UI.RawUI.WindowSize.Width/4
      [console]::CursorVisible=$False
      #[console]::SetCursorPosition(
     }
$databaseStatus = @{}
$dag = Get-DatabaseAvailabilityGroup -status
$dagMembers = $dag.Operationalservers #| select Name  
$error.clear()

$a = 0
$y = 0

while(1)
{
#$dagMembers = $dag.Operationalservers #| select Name  
foreach ($dagmember in $dagMembers)
{
if ($error){Clear-host;$errorLOg += $error;$error.clear()}
#sleep 1
$y = 1
$x = $a*$m # |---0x40---|---1x40---|---2x40---| ...

[console]::SetCursorPosition($x,$y)

#$allDB = (Get-MailboxDatabaseCopyStatus -Server $dagmember -ConnectionStatus | ? {$_.IncomingLogCopyingNetwork -or $_.OutgoingConnections} | sort Name) #only DAG databases
$allDB = (Get-MailboxDatabaseCopyStatus -Server $dagmember | sort Name)
Write-host -fore White $dagmember

    foreach ($db in $allDB )
    {
    #sleep 1
    $dbstatuschanged = $null
    #(Get-mailboxdatabase $db.DatabaseNAme).ActivationPreference -match $dagmember
    #{($db.ActivationPreference.Split(","))[0].split("[") -eq $dagmember}
    #$ap = ((Get-MailboxDatabase $db.DatabaseName).activationpreference[1].trimstart("[").trimend("]").split(",")[1] )
    
    #<# 
    $ap = ((Get-MailboxDatabase $db.DatabaseName).activationpreference | ? {$_.Key -eq $dagmember}).Value
    #>

    $y++
    [console]::SetCursorPosition($x,$y)
    
    #if ($db.activeCopy){ Write-host -nonewline -ForegroundColor Green $db.DatabaseName; write-host -fore Gray }
    
    if (!($databaseStatus.ContainsKey($db.Name))) {$databaseStatus.Add($db.Name,$db.Status)}
    if ( $db.Status -ne $databaseStatus[$db.Name])
    {
    $databaseStatus[$db.Name] = $db.Status #update new status
    $dbstatuschanged = $true
    }
    $apnum = " ["+$ap+"] "
    #if ($db.activeCopy -and !$dbstatuschanged)
    if (!$dbstatuschanged) #dbstatuschanged FALSE
     {
        if ($db.activeCopy -and ($db.Status -eq "Dismounted"))
        {Write-host -nonewline -ForegroundColor Red $db.DatabaseName;Write-host -NoNewline -ForegroundColor DarkGray $apnum;Write-Host -ForegroundColor Gray $db.Status}
        elseif ($db.activeCopy)
        {Write-host -nonewline -ForegroundColor Green $db.DatabaseName;Write-Host -NoNewline -ForegroundColor DarkGray $apnum;Write-host -ForegroundColor Gray $db.Status}
        else
        {Write-host -nonewline -ForegroundColor Gray $db.DatabaseName;Write-Host -NoNewline -ForegroundColor DarkGray $apnum;
            if ($db.Status -ne "Healthy") {Write-host -ForegroundColor DarkYellow $db.Status}
            else {Write-host -ForegroundColor Gray $db.Status} 
        }
     }
    else #dbstatuschanged TRUE
     {  
        if ($db.activeCopy -and ($db.Status -eq "Dismounted"))
        {
        Write-host -nonewline -ForegroundColor Red $db.DatabaseName;Write-host -NoNewline -ForegroundColor DarkGray $apnum;Write-host -NoNewline "                                   " #35
        [console]::SetCursorPosition(($Host.UI.RawUI.CursorPosition.X-35),$Host.UI.RawUI.CursorPosition.Y)
        Write-host -ForegroundColor Gray $db.Status
        }
        elseif ($db.activeCopy)
        {
        Write-host -nonewline -ForegroundColor Green $db.DatabaseName;Write-host -NoNewline -ForegroundColor DarkGray $apnum;Write-host -NoNewline "                                   " #35
        [console]::SetCursorPosition(($Host.UI.RawUI.CursorPosition.X-35),$Host.UI.RawUI.CursorPosition.Y)
        Write-host -ForegroundColor Gray $db.Status
        }
        else 
        {
        Write-host -nonewline -ForegroundColor Gray $db.DatabaseName;Write-host -NoNewline -ForegroundColor DarkGray $apnum;Write-host -NoNewline "                                   " #35
        [console]::SetCursorPosition(($Host.UI.RawUI.CursorPosition.X-35),$Host.UI.RawUI.CursorPosition.Y)
            if ($db.Status -ne "Healthy") {Write-host -ForegroundColor DarkYellow $db.Status}
            else {Write-host -ForegroundColor Gray $db.Status}
        }
     }
     
    
    }#foreach db
    
if ($a -lt ($dagMembers.count - 1)) {$a++}
elseif ($a -eq ($dagMembers.count - 1)) {$a = 0}
#{$a = 0;sleep 1;Clear-Host;}  

} #foreach dagmember
   
} #while


# [console]::CursorVisible=$true

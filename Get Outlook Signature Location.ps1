
$comps = Get-ADComputer -Properties OperatingSystem -Filter "OperatingSystem -LIKE '*7*'"
$comps = $comps.Name
#$comps = 'jadranka-pc'
#,'xn26'
foreach ($compname in $comps)
{
$Error.Clear()
if (Test-Connection $compname -count 1 -ErrorAction SilentlyContinue )
{

#check WMI
$os = (gwmi -Class Win32_operatingSystem -ComputerName $compname -ErrorAction SilentlyContinue)
if ($Error[0])
    {
    #RPC is Unavailable!
    Write-host $compname+" RPC offline,check Firewall!"

    }
else {
    #RPC online,continue with WMI!
    $username = (gwmi -Class Win32_process -ComputerName $compname -Filter "Name='explorer.exe'").getowner().user
    $compname
    $os.Caption
    $username

    if ($os.Caption -like "*XP*")
        {
        $Sig_path = '\\'+ $compname + '\c$\Documents and Settings\'+$username+'\Application Data\Microsoft\Signatures' 
        [string[]]$argumentList = "\\$compname","netsh","firewall","show","state"
        $stateString = 'Operational mode'
        }
    else 
        {
        $Sig_path = '\\'+ $compname + '\c$\Users\'+$username+'\AppData\Roaming\Microsoft\Signatures' 
        [string[]]$argumentList = "\\$compname","netsh","advfirewall","show","domainprofile"
        $stateString = 'State'
        }
    
    if (Test-Path $Sig_path) {Get-ChildItem $Sig_path}
    
    #http://stackoverflow.com/questions/11531068/powershell-capturing-standard-out-and-error-with-process-object    
    $psi = New-object System.Diagnostics.ProcessStartInfo 
    $psi.CreateNoWindow = $true 
    $psi.UseShellExecute = $false 
    $psi.RedirectStandardOutput = $true 
    $psi.RedirectStandardError = $true 
    $psi.FileName = 'D:\_scripts\PSTools\PsExec.exe' 
    $psi.Arguments = $argumentList 
    $process = New-Object System.Diagnostics.Process 
    $process.StartInfo = $psi 
    [void]$process.Start()
    $output = $process.StandardOutput.ReadToEnd() 
    $process.WaitForExit() 
    $output
    
    #$output | Select-string $stateString

    }#else
} #Test-connection

else { Write-host -fore Yellow $compname" Offline" }


}

#cd D:\_scripts\PSTools
#$expression = 'D:\_scripts\PSTools\PsExec.exe \\'+$compname + ' netsh advfirewall show domainprofile | Select-String State'
#Invoke-Expression $expression
#Invoke-Expression 'D:\_scripts\PSTools\PsExec.exe \\xn26 netsh advfirewall show domainprofile' -ErrorAction SilentlyContinue | Select-String State


#[string[]]$argumentList = "\\$compname","netsh","advfirewall","show","domainprofile"
#Start-Process -FilePath D:\_scripts\PSTools\PsExec.exe -ArgumentList $argumentList -RedirectStandardOutput dummyOutput.txt -wait







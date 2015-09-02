
$servers = Get-ExchangeServer
#$vds = "OWA","ECP","WebServices","ActiveSync","OAB","Powershell"
$vds = "OWA","ECP","WebServices","ActiveSync","OAB","Autodiscover","Powershell"

$Object = New-Object PSObject
#$Object | add-member Noteproperty -Name Server -Value $null 
$Object | add-member Noteproperty -Name Name -Value $null  
$Object |add-member Noteproperty -Name ExternalURL -Value $null  
$Object | add-member Noteproperty -Name InternalURL -Value $null 

foreach ($server in $servers)
{
$hostname = $server.Name
    foreach ($vd in $vds) 
    {
        $command = "Get-"+$vd+"VirtualDirectory"+" -Server "+$hostname + "| Set-variable a"
        Invoke-Expression $command

        #$Object.Server = $hostname
        $Object.Name = ($hostname+" "+$a.Name)
        $Object.ExternalUrl = $a.ExternalUrl
        $Object.InternalUrl = $a.InternalUrl
        $Object
    }

    Get-OutlookAnywhere -server $hostname | Set-Variable oa
    $Object.Name = ($hostname+" OutlookAnywhere")
    $Object.ExternalUrl = $oa.ExternalHostname
    $Object.InternalUrl = $oa.InternalHostname
    $Object
        
}



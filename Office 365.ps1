
$UserCredential = Get-Credential -Message 'Office 365 Admin' -UserName milan@kt.rs
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session

Import-Module msonline

Connect-MsolService -Credential $UserCredential

Get-MSolDomain
new-MSolFederatedDomain -DomainName kt.rs
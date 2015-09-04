
#create AD users/mailboxes from CSV
$users = Import-Csv 'C:\Users\Milan.KTEHNIKA\Documents\trcpro-users list 3.txt' -Encoding Unicode
#$password = 'Trcprons1' 
$password = ConvertTo-SecureString "Trcprons1" -AsPlainText -Force

foreach ($user in $users)
{

$param = @{

OrganizationalUnit = 'ktehnika.local/TRCPRO'
Name =  $user.Name
Alias = $user.'Exchange Alias' 
UserPrincipalName =$user.'User Logon Name'
SamAccountName = $user.'User Logon Name'.Split('@')[0]
FirstName = $user.'First Name'
LastName = $user.'Last Name'
Password = $password
ResetPasswordOnNextLogon = $false

Office = $user.'Office'
Department = $user.'Department'

Database ='E1'
}
#New-Mailbox @param 

}
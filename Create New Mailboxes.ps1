

$users = Import-Csv 'C:\Users\Milan.KTEHNIKA\Documents\TRCPRO users.txt' -Encoding Unicode
$password = 'Trcprons1' 
foreach ($user in $users)
{

$name = $user.Name
$email = $user.'E-Mail Address'


New-Mailbox -Password $password -
}
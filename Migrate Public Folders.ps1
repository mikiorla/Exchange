
#export public folder data
Get-PublicFolder -Recurse | Export-CliXML C:\Legacy_PFStructure.xml
Get-PublicFolderStatistics | Export-CliXML C:\Legacy_PFStatistics.xml
Get-PublicFolder -Recurse | Get-PublicFolderClientPermission | Select-Object Identity,User -ExpandProperty AccessRights | Export-CliXML C:\Legacy_PFPerms.xml

#check if public folder has '/' in name
Get-PublicFolderStatistics -ResultSize Unlimited | Where {$_.Name -like "*\*"} | Format-List Name, Identity
#if it has
#Set-PublicFolder -Identity <public folder identity> -Name <new public folder name>



#Make sure there isn’t a previous record of a successful migration.
Get-OrganizationConfig | Format-List PublicFoldersLockedforMigration, PublicFolderMigrationComplete
#if $false than OK


#exchange 2013
Get-PublicFolderMigrationRequest #| Remove-PublicFolderMigrationRequest -Confirm:$false

#make sure there are no existing public folders on the Exchange 2013 servers
Get-Mailbox -PublicFolder 
Get-PublicFolder
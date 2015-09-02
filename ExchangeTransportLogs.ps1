


#Get-MessageTrackingLog -Server e1 -Recipients petar.dzigurski@ktehnika.co.rs -Start (get-date).AddMinutes(-30)

$SMTPReceiveLogPath = get-childitem -path "\\e1\c$\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" 
$SMTPReceiveLog = $SMTPReceiveLogPath | sort -Property LastWriteTime -Descending

get-content $SMTPReceiveLog[0].FullName

ii "\\e1\c$\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\"


$FEAgentLogPath = "\\e1\C$\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\AgentLog"
$FEAgentLogItems = Get-childitem -path $FEAgentLogPath
$FEAgentLog = $FEAgentLogItems | sort -Property LastWriteTime -Descending

get-content $FEAgentLog[0].FullName 

Get-AgentLog -TransportService FrontEnd | select Timestamp,IPaddress,P1FromAddress,Recipients,Action,Reason
Get-AgentLog -TransportService FrontEnd -StartDate (get-date).AddDays(-1).AddHours(-2) | select Recipients #| select Timestamp,IPaddress,P1FromAddress,Recipients,Action,Reason
Get-AgentLog -TransportService Hub
#Get-AgentLog -TransportService MailboxSubmission
#Get-AgentLog -TransportService MailboxDelivery

#Hub
#MailboxSubmission 
#MailboxDelivery
#FrontEnd
#Edge
#format mm/dd/yyyy

#Get-MessageTrackingLog -Server Mailbox01 -Start "03/13/2013 09:00:00" -End "03/15/2013 17:00:00" -Sender "john@contoso.com"
Get-MessageTrackingLog -Sender bicore@ts.fujitsu.com -Start '4/20/2015 08:00' -End '4/21/2015 08:00' | sort Timestamp -Desc | fl * TImestamp,EventId,Recipients  
Get-MessageTrackingLog -Sender bicore@ts.fujitsu.com -Start '4/20/2015 07:00' -End '4/21/2015 7:00' -EventId HAREDIRECTFAIL | fl  *

#HAREDIRECTFAIL                                                                                               
#RECEIVE                                                                                                      
#AGENTINFO                                                                                                    
#SEND

get-messagetrackinglog -messagesubject "BiCore PEC Order Confirmation Mail" -Start '4/20/2015 08:00' -End '4/21/2015 08:00' | sort timestamp | ft timestamp,eventid,source,connec*,totalbytes,serverip,OriginalClientIp -AutoS



#(get-content $FEAgentLog[0].FullName).TrimStart("#Fields: ")
#$a[4].Trimstart("#Fields: ")

#$a = (get-content $FEAgentLog[0].FullName)
#Import-Csv ($a[4..$a.Count]).TrimStart("#Fields: ")

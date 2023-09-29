#Change Log:
# 9/18/23: Added timer and timeout for 6 hours to the while loop to prevent infinite loop. Added additional check in while loop to detect status change and alert on changes between node state until node gets to Ready
# 9/20/23: Corrected issue where Node State of "ReadyToJoin" was being incorrectly identified as "Ready"
# 9/29/23: Added try/catch to the $MyNode variable to deal with status code 500 message when load balancer is offline

#Variables - Get NodeInfo and Current State
$NodeIP = "YOUR NODE PUBLIC IP"
$discordhook = "YOUR WEBHOOK URL"
$MyNode = try { invoke-webrequest https://nebula-apim.azure-api.net/public/dag/nodestate/integrationnet/"$NodeIP"?layer=l1 -UseBasicParsing | Select -ExpandProperty Content | Out-String -ErrorAction SilentlyContinue } catch { $_.Exception.Response }
$NodeInfo = $MyNode.split(",") -replace '[{}""]'
$nodestate = $MyNode.split(",")[-1] -replace "}" | Out-String
$Loop = $true
$Timeout = 21600 #6 hours in seconds
$timer = [Diagnostics.Stopwatch]::StartNew()

#Actions based on node state
If ($nodestate.Trim() -eq '"state": "Ready"') {
Write-Output "Node is in the Ready State"
exit 0
}
else {
    Write-output "Node not in the ready state. Current Node State is: $NodeState"
    $payload = [pscustomobject]@{
        content = "NODE IS NOT IN READY STATE
        $nodestate"
        }
        Invoke-RestMethod -Uri $discordhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
        #$From = "youremail@gmail.com"
        #$To = "yourrecipientemail@outlook.com"
        #$Subject = "NODE L1 DOWN"
        #$Body = "L1 Node status is not Ready
        #Current Status is $nodestate"
        #$Password = "your app password" | ConvertTo-SecureString -AsPlainText -Force
        #$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
        #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
    While (($timer.Elapsed.TotalSeconds -lt $Timeout) -and ($Loop)) {
        $tempstate = $nodestate
        $MyNode = invoke-webrequest https://nebula-apim.azure-api.net/public/dag/nodestate/integrationnet/"$NodeIP"?layer=l1 -UseBasicParsing | Select -ExpandProperty Content | Out-String -ErrorAction SilentlyContinue
        $NodeInfo = $MyNode.split(",") -replace '[{}""]'
        $nodestate = $MyNode.split(",")[-1] -replace "}"
        If ($tempstate -ne $nodestate)
        {
            write-output "Node state has changed"
            $payload = [pscustomobject]@{
                content = "NODE STATE CHANGED
                $nodestate"
                }
            Invoke-RestMethod -Uri $discordhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
        }
        If ($NodeState.Trim() -ne '"state": "Ready"')
        {
            Start-Sleep -Seconds 60
        }
        else {
            $Loop = $false
            Write-Output "Node Status is now ready"
            $payload = [pscustomobject]@{
                content = "NODE IS BACK ONLINE AND READY
                $nodestate"
                }
            Invoke-RestMethod -Uri $discordhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
            #$From = "youremail@gmail.com"
            #$To = "yourrecipientemail@outlook.com"
            #$Subject = "NODE L1 BACK ONLINE"
            #$Body = "L1 Node Online and Ready
            #Current Status is $nodestate"
            #$Password = "your app password" | ConvertTo-SecureString -AsPlainText -Force
            #$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
            #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
        }
    }
}

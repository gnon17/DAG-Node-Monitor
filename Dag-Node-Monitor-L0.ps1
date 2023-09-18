#Variables - Get NodeInfo and Current State
$NodeIP = "YOUR NODE PUBLIC IP"
$discordhook = "YOUR WEBHOOK URL"
$MyNode = invoke-webrequest https://nebula-apim.azure-api.net/public/dag/nodestate/integrationnet/"$NodeIP"?layer=l0 -UseBasicParsing | Select -ExpandProperty Content | Out-String -ErrorAction SilentlyContinue
$NodeInfo = $MyNode.split(",") -replace '[{}""]'
$nodestate = $MyNode.split(",")[-1] -replace "}"
$Loop = $true

#Actions based on node state
If ($nodestate -match "Ready") {
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
        #$Subject = "NODE L0 DOWN"
        #$Body = "L0 Node status is not Ready
        #Current Status is $nodestate"
        #$Password = "your app password" | ConvertTo-SecureString -AsPlainText -Force
        #$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
        #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
    While ($Loop) {
        $MyNode = invoke-webrequest https://nebula-apim.azure-api.net/public/dag/nodestate/integrationnet/"$NodeIP"?layer=l0 -UseBasicParsing | Select -ExpandProperty Content | Out-String -ErrorAction SilentlyContinue
        $NodeInfo = $MyNode.split(",") -replace '[{}""]'
        $nodestate = $MyNode.split(",")[-1] -replace "}"
        If ($NodeState -notmatch "Ready")
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
            #$Subject = "NODE L0 BACK ONLINE"
            #$Body = "L0 Node Online and Ready
            #Current Status is $nodestate"
            #$Password = "your app password" | ConvertTo-SecureString -AsPlainText -Force
            #$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
            #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
        }
    }
}
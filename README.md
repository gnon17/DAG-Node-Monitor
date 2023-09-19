# DAG-Node-Monitor
## Monitor your Constellation Network Node with PowerShell

This describes how you can monitor your node status using a PowerShell script. Instructions are below for Windows and Linux. You can even run the monitor script on your node if you'd like to. This can work on MacOS also, but I do not have a Mac and do not know the equivalent setup. At writing, the script simply detects if your node is connected to the cluster and in the "Ready" state, which is what we want. The template is configured to send a notification to a webhook URL (I use Discord), but you can use any other app that can use a webhook. Optionally, you can get email alerts or SMS alerts if your carrier still supports email to SMS. Here is a sample alert from Discord and email:
-  ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/0c793e51-152f-42a7-8783-a24fa95035c8)
-  ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/d311ac90-c8b7-4303-9be8-1019b0eb0850)

### What is the point of this? 
I like trying new things with PowerShell. It also allows for more flexible notifications and can be changed or enhanced by the community. Uptime Robot is a great free tool, but it only monitors every 5 minutes and the free tier is limited to email notifications. Extra features cost $7 per month. I hope to continue enhancing this script to provide more details and useful notifications, but for now, it will notify you when your node goes into any state that is not "Ready" and then notify you again when it's back into the Ready state. You can set up the script on as many devices as you'd like, but any device running the monitor script will trigger an alert. So, if you have three devices monitoring, you'll end up with three separate alerts. 

### How it works:
The script itself is rather simple and uses the same resource Uptime Robot uses to detect if a node is online. It reaches out to the URL displaying the connected nodes and pulls the status from your node. You supply your node's public IP address into the script which is how your node is identified. If your node has a status different from "Ready" then an alert is generated to inform you that your node is no longer in the ready state and shows you the current status. The script then checks every minute to see if the status is changed to ready. When the node status becomes "Ready", you will receive another notification that your node is back online. The time can be adjusted if you'd like. 

### Pre-requisites and Editing the script for your Node
There are a few things you need to do before the script will monitor your node. 
- Create a discord server and generate a webhook for the alerts (or a different app that can use a webhook)
- Edit the script and add your webhook URL and your node's public IP
- OPTIONAL: Add email information using an app password for email and/or SMS alerts if your carrier allows email to SMS. I know T-Mobile does not allow this anymore.

1. To generate a webhook URL in Discord you need to have a server. This will be used for your Node Alerts. Open Discord and click the + sign in the left pane. When the Create a Server Windows appears, click Create My own:
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/5079efd0-2aa6-43b4-b2d9-b1caa2e56bc9)
2. Click for Me and My friends:
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/6bc8b99b-0970-4d54-933f-cbd0cad3e010)
3. Provide a name for the server, and click Create.
4. Right-click your server in the left pane, select server settings > Integrations
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/09a0bd96-7119-4f73-845d-310cebfbe3f2)
5. Select webhooks
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/7fb306b6-b0e0-4414-ac86-51b18a5f3b32)
6. Select New Webhook and create one or more webhooks. I created separate webhooks for L0 and L1, but you can use a single webhook if you'd like.  
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/a8968f98-f134-4a28-8001-2766c863e6ea)
7. Copy the webhook URL and paste it in notepad or somewhere temporary. We will need this in a few minutes to add this to the script. You can always go back into your webhooks and copy the URL again.
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/0dfc3623-f9da-4dc6-bca0-f62838be1486)

Now we need to edit the script files so they are customized to monitor your node and send notifications to your discord channel. 
1. Download the dag-node-monitor-L0.ps1 and dag-node-monitor-L1.ps1 files from this repo.
2. Open them in a text editor or code editor. You can also right-click and choose edit if you're using Windows. There are two things you need to edit. There are variables for your node's public IP address ($nodeIP) and a variable for the Webhook URL ($discordhook). Edit these so they use your node IP and your webhook URL. Do this for both the L1 and L0 scripts. Save them when finished.
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/3d8cab14-a3ee-4907-92bc-cef9b63a264c)
3. I have the email portion commented out since PowerShell uses older legacy authentication to send email. The most secure way to use this is to use an app password. Some email providers still allow this, but others don't. Gmail and Yahoo mail allow app passwords, but only for older established accounts. New accounts are not permitted to create app passwords. If you want to use email or email to SMS, you'll need to uncomment this portion (remove the #s) and complete the necessary variables highlighted in the screenshot below. If you do this, make sure to edit both else statements with your email details. 
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/762cfea9-7693-4242-a13e-5433f1f85ec9)
4. If using Windows, move the files to the c:\temp folder. If it does not exist, create it. You can save it elsewhere if you'd like to, but remember where you saved it. The template task files for Windows reference c:\temp.

### How to Monitor your Node using Windows
We need a way to trigger the script. On Windows, we will use a scheduled task and set it to run every minute. You can set this up on multiple devices, but ideally, you want a device that is always on (e.g. - a home server or VPS if you already have one). If your device running the monitor is down, you obviously won't get alerts.
1. Download both of the Dag-Node-Monitor.ps1 scripts
2. Move the scripts into the c:\temp directory on your machine. If that directory does not exist, create it.
3. Download both XML files (DAG-NODE-MONITOR-L0.xml and DAG-NODE-MONITOR-L1.xml)
4. Search for and open Task Scheduler:
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/3f382eae-3621-4344-a981-93c9e246eb73)
5. Right-click the task scheduler library, and select Import:
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/5ad5ad19-b952-48f0-8870-09a34c538cbe)
6. Select the DAG-NODE-MONITOR-L0.xml file we downloaded in step three
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/b562764e-80ff-4171-97d7-183631c6dfa0)
7. This imports the task with the default settings. The default settings run the script every minute, won't run the script if the process is already running (important so we don't get continuous alerts), and use C:\Temp\Dag-Node-Monitor-L0.ps1 as the location for the monitoring script.  Click OK to take the default settings. You can modify these if you'd like. For example, you can change the frequency, navigate to the triggers tab, and adjust the frequency.
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/5c1f13fc-6510-4887-beba-13e45793720f)
8. Repeat steps 5-7 for the L1 monitor. When finished, click Enable task history in the task scheduler. This will allow you to verify your task is running on schedule.
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/bb6ef0e2-e113-4474-a1cc-94c39f220a09)
9. If you feel like testing the alerts against your node, you can use the following commands to leave and rejoin the L1 network - "sudo nodectl restart-p intnet-l1". This should take a minute or two and be long enough for your node to leave the L1 pool, generate an alert, and then rejoin, which should result in another alert showing your node is back online. If that command finishes too quickly, use the three commands below. You'll be disconnected from the L1 pool for 2-4 minutes, which should be enough time to generate a down alert, and then the alert that your node is back in the ready state:
    - sudo nodectl leave -p intnet-l1 (replace intnet with your profile if it's named differently)
    - sudo nodectl stop -p intnet-l1
    - sudo nodectl restart -p intentl1

### How to Monitor your Node using Linux
The example below uses Ubuntu and cron, which is the equivalent of a Windows scheduled task. I did this on the node itself and it had no impact on resource utilization since the script requires almost no resources. As mentioned in the Windows instructions, ideally you'll want this running on a machine that's on 24/7 so you don't miss alerts.
1. First, we need to install PowerShell. Commands are below taken from the MS Learn article here - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3:
    - sudo apt-get update
    - sudo apt-get install -y wget apt-transport-https software-properties-common
    - wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
    - sudo dpkg -i packages-microsoft-prod.deb
    - rm packages-microsoft-prod.deb
    - sudo apt-get update
    - sudo apt-get install -y powershell
  2. We need upload the ps1 scripts to our linux machine. Make sure you've followed the steps in the pre-requisites so your script files are edited with your node information. You can use WinSCP for this by entering the same connection details you use to connect via SSH. Make note of the location where you copy the script files:
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/23e1066e-f7e3-430a-a7d2-bc92f03c8057)
  3. Now that our script files are on our Linux machine, we need to edit the crontab file. This will execute our monitoring script on a schedule. Use the command "sudo crontab -e" to open the crontab file. Then, we need to add the below lines to the file. Make sure to use the correct path to your script files. You can view this from Winscp where it's highlighted in step two. The below lines will run the monitoring script every minute. Using Flock will prevent the script from executing if it's already in progress. This prevents us from getting spammed with alerts every minute if the node is offline. 
        -  */1 * * * * /usr/bin/flock -n /tmp/L0nodemonitor.lockfile pwsh -File "/pathtoyourfile/Dag-Node-Monitor-L0.ps1"
        -  */1 * * * * /usr/bin/flock -n /tmp/L1nodemonitor.lockfile pwsh -File "/pathtoyourfile/Dag-Node-Monitor-L1.ps1"
        - Here's an example screenshot:
            - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/67941b6c-ac14-4c37-936b-30f95f65ad15)
4. Wait a minute or two and then verify your crontab job is executing with the below command. You'll see log entries that the script is executing every minute:
       - grep CRON /var/log/syslog
       - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/41902150-a7ce-49e6-9485-ea36ea375477)
5. To test the alerts, we can quickly leave and rejoin the L1 network using the same steps in step nine of the Windows instructions

### Troubleshooting Guide
#### I am receiving "node not found" but my node is in the ready state
- Verify your node's IP is correct in your script. You can test this by executing these commands from PowerShell. Make sure to replace your node's public IP in place of "YOUR NODE PUBLIC IP" for the $NodeIP variable. The below commands should output the correct state of your node if your node IP is correct. 
    - $NodeIP = "YOUR NODE PUBLIC IP"
    - $MyNode = invoke-webrequest https://nebula-apim.azure-api.net/public/dag/nodestate/integrationnet/"$NodeIP"?layer=l0 -UseBasicParsing | Select -ExpandProperty Content | Out-String -ErrorAction SilentlyContinue
    - $nodestate = $MyNode.split(",")[-1] -replace "}"
    - $nodestate
 
 #### I received an alert that my node is not in the ready state, but I never received an alert that it's back online
 - There is likely an issue with the else statement but caught in an infinite loop. This will happen if your node's public IP is incorrect or it changed. The loop is waiting for a status change for a node IP that doesn't exist. In this case, we need to make sure our monitoring script is using the correct node IP (see "node not found" troubleshooting entry). After confirming the node IP is accurate, we need to manually terminate the task. I'm working on a solution for this with a timer so the script won't loop for more than 12 hours. 
 - Manually stop Windows Task. 
   - Open the task scheduler. Find your dag node monitoring scheduled tasks. Right-click each of them and select "end". The tasks will resume running on schedule after being ended.
   - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/21072ab1-e7f7-4cbf-9539-ddb3c397cddb)
 - Manually Stop crontab jobs on Ubuntu
   - Use the below command to locate the PIDs that are using the script files (repeat these steps for L0 script if it's happening to both)
       - sudo ps aux |grep "/PATH TO MONITOR SCRIPTS/Dag-Node-Monitor-L1.ps1"
       - You'll receive output like the screenshot below. Record the PIDs
       -  ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/c9a8746a-3e9a-4e49-86f8-5cc0ad69d41c)
       - Terminate the PIDs using the kill command for each of the PIDs:
           - kill 92449
           - kill 92451
           - kill 92453
        - The job will resume running again on schedule
hi







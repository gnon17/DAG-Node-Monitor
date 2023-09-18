# DAG-Node-Monitor
## Monitor your Constellation Network Node with PowerShell

This describes how you can monitor your node status using a PowerShell script. Instructions are below for Windows and Linux. You can even run the monitor script on your node if you'd like to. This can work on MacOS also, but I do not have a Mac and do not know the equivalent setup. At writing, the script simply detects if your node is connected to the cluster and in the "Ready" state, which is what we want. The template is configured to send a notification to a webhook URL (I use Discord), but you can use any other app that can use a webhook. Optionally, you can get email alerts or SMS alerts if your carrier still supports email to SMS. Here is a sample alert from Discord and email:
![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/8b670a7c-e63f-4a82-9002-172bcebfb6de)
![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/953bdc06-1b23-45e4-87cb-072e1a237d88)

### What is the point of this? 
I like trying new things with PowerShell. It also allows for more flexible notifications and can be changed or enhanced by the community. Uptime Robot is a great free tool, but it only monitors every 5 minutes and uses email notifications. Extra features cost $7 per month. I hope to continue enhancing this script to provide more details and useful notifications, but for now, it will notify you when your node goes into any state that is not "Ready" and then notify you again when it's back into the Ready state. You can set up the script on as many devices as you'd like, but any device running the monitor script will trigger an alert. So, if you have three devices monitoring, you'll end up with three separate alerts. 

### How it works:
The script itself is rather simple. It reaches out to the URL displaying the connected nodes and pulls the status from your node. You supply your node's public IP address into the script which is how your node is identified. If your node has a status different from "Ready" then an alert is generated to inform you that your node is no longer in the ready state, and shows you the current status. The script then checks every minute to see if the status is changed to ready. When the node status becomes "Ready", you will receive another notification that your node is back online. The time can be adjusted if you'd like. 

### Pre-requisites and Editing the script for your Node
There are a few things you need to do before the script will monitor your node. 
- Create a discord server and generate a webhook for the alerts (or a different app that can use a webhook)
- Edit the script and add your webhook URL and your node's public IP
- OPTIONAL: Add email information using an app password for email and/or SMS alerts if your carrier allows email to SMS. I know T-Mobile does not allow this anymore.

1. To generate a webhook URL in discord you need to have a server. This will be used for your Node Alerts. Open Discord and click the + sign in the left pane. When the Create a Server Windows come up, click Create My own:
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/d07d715f-68ba-4f11-82f8-b2e5def6963d)
2. Click for Me and My friends:
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/73627ce0-42bd-4056-8f87-9c945d9f4004)
3. Provide a name for the server, and click Create.
4. Right-Click your server in the left pane, select server settings > Integrations
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/27bbd245-c7d2-4f8c-8230-16505f44e242)
5. Select webhooks
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/8d31b972-8fa1-41c8-b562-2aadcafb3e7f)
6. Select New Webhook and create one or more wekbooks. I created separate webhooks for L0 and L1, but you can use a single webhook if you'd like.  
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/e177fa84-0a0b-4dd9-9892-8d3c48f25e21)
7. Copy the webhook URL and paste it in nodepad or somewhere temporary. We will need this in a few minutes to add this to the script. You can always go back into your webhooks and copy the URL again.
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/170b9ae0-0beb-4a29-97fc-044ae871c49c)

Now we need to edit the script files so they are customized to monitor your node and send notifications to your discord channel. 
1. Download the dag-node-monitor-L0.ps1 and dag-node-monitor-L1.ps1 files from this repo.
2. Open them in a text editor or code editor to edit. You can also right-click and choose edit if you're using Windows. There are two things you need to edit. There are variables for your node's public IP address ($nodeIP) and a variable for the Webhook URL ($discordhook). Edit these so they use your node IP and your webhook URL. Do this for both the L1 and L0 scripts. Save them when finished.
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/05a63e2a-6845-4ee4-af20-b865549e9de1)
3. If using Windows, move the files to the c:\temp folder. If it does not exist, create it. You can save it elsewhere if you'd like to, but remember where you saved it. The template task files for Windows reference c:\temp.

### How to Monitor your Node using Windows
We need a way to trigger the script. On Windows, we will use a scheduled task and set it to run every minute. You can set this up on multiple devices, but ideally, you want a device that is always on (e.g. - a home server or VPS if you already have one). If your device running the monitor is down, you obviously won't get alerts.
1. Download both of the Dag-Node-Monitor.ps1 scripts
2. Move the scripts into the c:\temp directory on your machine. If that directory does not exist, create it.
3. Download both XML files (DAG-NODE-MONITOR-L0.xml and DAG-NODE-MONITOR-L1.xml)
4. Search for and open Task Scheduler:
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/29df94bb-5b12-4ca5-95c0-80dfc6daa36a)
5. Right-click the task scheduler library, and select Import:
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/f342a787-3a92-4e99-b6b4-d9755923d633)
6. Select the DAG-NODE-MONITOR-L0.xml file we downloaded in step three
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/93001ad6-b9cd-40d0-ba5a-2eaccbd4667a)
7. This imports the task with the default settings. The default settings run the script every minute, won't run the script if the process is already running (important so we don't get continuous alerts), and use C:\Temp\Dag-Node-Monitor-L0.ps1 as the location for the monitoring script.  Click OK to take the default settings. You can modify these if you'd like. For example, you can change the frequency, navigate to the triggers tab and adjust the frequency.
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/e0647329-a018-456f-8ed1-a7b11efead84)
8. Repeat steps 5-7 for the L1 monitor. When finished, click Enable task history in the task scheduler. This will allow you to verify your task is running on schedule.
  - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/ed57f77e-fabc-4b9d-a27d-672aa4ebf39a)
9. If you feel like testing the alerts against your node, you can use the following commands to leave and rejoin the L1 network - "sudo nodectl restart-p intnet-l1". This should take a minute or two and be long enough for your node to leave the L1 pool, generate an alert, and then rejoin, which should result in another alert showing your node is back online. If that command finishes too quickly, use the three commands below. You'll be disconnected from the L1 pool for 2-4 minutes, which should be enough time to generate a down alert, and then the alert that your node is back in the ready state:
    - sudo nodectl leave -p intnet-l1 (replace intnet with your profile if its named differently)
    - sudo nodectl stop -p intnet-l1
    - suco nodectl restart -p intentl1

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
    - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/f6ec22c7-b9d2-4f47-90c2-e0aa156982e1)
  3. Now that our script files are on our Linux machine, we need to edit the crontab file. This will execute our monitoring script on a schedule. Use the command "sudo crontab -e" to open the crontab file. Then, we need to add the below lines to the file. Make sure to use the correct path to your script files. You can view this from Winscp where it's highlighted in step 2. The below lines will run the monitoring script every minute. Using Flock will prevent the script from executing if it's already in progress. This prevents us from getting spammed with alerts every minute if the node is offline. 
    - */1 * * * * /usr/bin/flock -n /tmp/L0nodemonitor.lockfile pwsh -File "/pathtoyourfile/Dag-Node-Monitor-L0.ps1"
    - */1 * * * * /usr/bin/flock -n /tmp/L1nodemonitor.lockfile pwsh -File "/pathtoyourfile/Dag-Node-Monitor-L1.ps1"
    - Here's an example screenshot:
        - ![image](https://github.com/gnon17/DAG-Node-Monitor/assets/105109259/c80e5a66-8646-42db-a61b-937b4bed345c)
    






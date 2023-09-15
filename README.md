# DAG-Node-Monitor
## Monitor your Constellation Network Node with PowerShell

This describes how you can monitor your node status using a PowerShell script. Instructions are below for Windows and Linux. This can work on MacOS also, but I do not have a Mac and do not know the equivalent setup. At writing, the script simply detects if your node is connected to the cluster and in the "Ready" state, which is what we want. The template is configured to send a notification to a webhook URL (I use discord), but you can use any other app that can use a webhook. Optionally, you can get email alerts or SMS alerts if your carrier still supports email to SMS.  

### What is the point of this? 
I like trying new things with PowerShell. It also allows for more flexible notifications and can be changed or enhanced by the community. Uptime Robot is a great free tool, but it only monitors every 5 minutes and uses email notifications. Extra features cost $7 per month. I hope to continue enhancing this script to provide more details and useful notifications, but for now, it will notify you when your node goes into any state that is not "Ready" and then notify you again when it's back into the Ready state. You can set up the script on as many devices as you'd like, but any device running the monitor script will trigger an alert. So, if you have three devices monitoring, you'll end up with three separate alerts. 

### How it works:
The script itself is rather simple. It reaches out to the URL displaying the connected nodes and pulls the status from your node. You supply your node's public IP address into the script which is how your node is identified. If your node has a status different from "Ready" then an alert is generated to inform you that your node is no longer in the ready state, and shows you the current status. The script then checks every minute to see if the status is changed to ready. When the node status becomes "Ready", you will receive another notification that your node is back online. The time can be adjusted if you'd like. 

### How to Monitor your node using Windows
We need a way to trigger the script. On Windows, we will use a scheduled task and set it to run every minute. You can set this up on multiple devices, but ideally, you want a device that is always on (e.g. - a home server or VPS if you already have one). If your device running the monitor is down, you obviously won't get alerts.
1. Download both of the Dag-Node-Monitor.ps1 scripts
2. Move the scripts into the c:\temp directory on your machine. If that directory does not exist, create it.
3. Download both XML files (DAG-NODE-MONITOR-L0.xml and DAG-NODE-MONITOR-L1.xml)
4. 

# Control Vera Ezlo Device by Device Name
The purpose of this script is so that you can change the value of a device by the **device name** instead of having to know the **device's ID**.

Note: This is a quickly written and uploaded script, not much development work has been done on it yet.

For example, with this script you can call this command in PowerShell:

```
php .\Ezlo.php "Office AC" 1
```

And the office AC turns on

```
php .\Ezlo.php "Office AC" 0
```
And the office AC turns off. The "office AC" is a window unit that is plugged into a Z-Wave outlet.

---
## How it Works
- First, the device names and IDs are gathered from `hub.devices.list`
- Next, the device IDs and IDs are gathered from `hub.items.list`
- An array with the device name as the key and the ID (from hub.items.list) is created.
- Whatever you specify for the first argument is the device name, and the second argument is the value_in

Change as needed!

## Prerequisites
Nothing too fancy is needed, just php, any version will do, preferably version 8+. If you have Chocolatey and want to install php, simply type...
```
choco install php
```

Your device needs to have **offllineAnonymousAccess** and **offlineInsecureAccess** set to **true** as defined in [Part 2 on this page](https://support.getvera.com/hc/en-us/articles/360016339799-Ezlo-platform-How-to-use-HTTP-API-commands-aka-Luup-Requests). If you want to keep these set to false, you'll just need to modify the script to use cURL instead. I might add this as an option later.
## Setup
Change the Ezlo IP address at the top of the script.

## Usage
Run the script from PowerShell like so:
```
php .\Ezlo.php "Device Name Goes Here" Value_Integer_Goes_Here
```
such as
```
php .\Ezlo.php "Room Light" 0
```
to turn off the device, and
```
php .\Ezlo.php "Room Light" 1
```
to turn on the device.

**Note**: I have not added functionality for things such as door locks... right now it only works with binary switches such as lights and outlets. You can easily add a different value by adjusting the script.
## To see all the devices and device names
Run this special command which will output the devices and its associated ID (not device ID but the ID used in URL).
```
php .\Ezlo.php Show_Devices_Array 1
```
![devices array](https://i.imgur.com/LWRAecE.png)
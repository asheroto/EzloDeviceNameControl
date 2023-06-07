
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/asheroto)
# Control Ezlo Device by Device Name
[Ezlo](https://www.ezlo.com/) is a home automation platform that uses Z-Wave and Zigbee.

This script allows you to control your Ezlo device by **device name** instead of **device ID**. It will also show you all the devices and their associated IDs and item/function names. This is useful if you want to control your Ezlo device with PowerShell or another scripting language.

**Turn Office AC on:**
```powershell
.\Ezlo.ps1 -DeviceName "Office AC" -ItemName "Switch" -Value 1
```
**Turn Office AC off:**
```powershell
.\Ezlo.ps1 -DeviceName "Office AC" -ItemName "Switch" -Value 0
```
And the office AC turns off.

**Output:**
![Controlling the device](https://github.com/asheroto/EzloDeviceNameControl/assets/49938263/98c942b4-f92d-4875-b213-1fec5fa08002)

In this example, the "Office AC" device is a window unit that is plugged into a Z-Wave outlet.

## How it Works
- The device names and IDs are gathered from `hub.devices.list`
- The device IDs and item/function names and IDs are gathered from `hub.items.list`
- An array is created containing the `device name` as the key, and the `ID` and `item/function name` as object values 
- When `-ShowDevices` is specified as a parameter, the data is converted to JSON for readability

**Note**: The device ID (`deviceId`) is different than ID (`_id`). The device ID is the device itself, whereas the ID is an item/function of the device.

## Prerequisites

- PowerShell
- [Ezlo device](https://www.ezlo.com/)
- Your device needs to have **offllineAnonymousAccess** and **offlineInsecureAccess** set to **true** as defined in Part 2 [on this page](https://support.getvera.com/hc/en-us/articles/360016339799-Ezlo-platform-How-to-use-HTTP-API-commands-aka-Luup-Requests).
	- If you want to keep these set to false, you'll just need to modify the script. I might add this as an option later.

## Setup
Change the Ezlo IP address at the top of the script.

## Usage
**Run the script from PowerShell like so:**
```powershell
.\Ezlo.ps1 -DeviceName "Device Name Goes Here" -ItemName "Item Name Goes Here" -Value Value_Integer_Goes_Here
```
**To see all the devices and device names:**

Run this special command which will output the devices, the item/function names, and its associated ID in JSON format.
```powershell
.\Ezlo.ps1 -ShowDevices
```
## Example
**Turn on the device:**
```powershell
.\Ezlo.ps1 -DeviceName "Room Light" -ItemName "Switch" -Value 1
```
**Turn off the device:**
```powershell
.\Ezlo.ps1 -DeviceName "Room Light" -ItemName "Switch" -Value 0
```

## Screenshots
**Controlling the device:**

![Controlling the device](https://github.com/asheroto/EzloDeviceNameControl/assets/49938263/98c942b4-f92d-4875-b213-1fec5fa08002)

**ShowDevices:**

![ShowDevices](https://github.com/asheroto/EzloDeviceNameControl/assets/49938263/b9f6ec2d-81cd-41e8-b92c-310ea7a283c7)
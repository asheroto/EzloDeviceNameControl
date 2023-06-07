param(
	[string]$DeviceName,
	[string]$ItemName,
	[int]$Value,
	[switch]$ShowDevices
)

# Function to write help text
function WriteHelpText($text) {
	if ($text) {
		Write-Warning $text
	}
	Write-Warning "You must specify the device name, function name and value"
	Write-Warning "For example: .\Ezlo.ps1 -DeviceName 'Office Light' -ItemName 'Switch' -Value 1"
	Write-Warning "To see the list of devices, specify -ShowDevices"
}

# Set your Ezlo IP address here
$ezloIp = '192.168.0.16'

# If ShowDevices is set, then show the array and exit
if ($ShowDevices) {
	# Invoke REST API to get the list of devices including device name
	$devicesList = "http://${ezloIp}:17000/v1/method/hub.devices.list"
	$json = Invoke-RestMethod -Uri $devicesList
	$devices = $json.result.devices
	$deviceIdLookup = @{}
	foreach ($device in $devices) {
		$deviceIdLookup[$device._id] = $device.name
	}

	# Invoke REST API to get the list of items including item name and ID
	$itemsList = "http://${ezloIp}:17000/v1/method/hub.items.list"
	$json = Invoke-RestMethod -Uri $itemsList
	$items = $json.result.items
	$nameLookup = @{}
	foreach ($item in $items) {
		$name = $deviceIdLookup[$item.deviceId]
		$new = New-Object PSObject -Property @{
			"Name" = $item.name
			"ID"   = $item._id
		}

		if (-not $nameLookup.ContainsKey($name)) {
			$nameLookup[$name] = @()
		}

		$nameLookup[$name] += $new
	}

	# Convert the lookup array to JSON
	$nameLookupJson = ConvertTo-Json $nameLookup -Depth 3

	# Print the array
	Write-Output $nameLookupJson
} else {
	# Ensure DeviceName, ItemName, and Value are provided
	if ($DeviceName -eq $null) {
		WriteHelpText("You must specify the device name")
		exit 1
	}
	if ($ItemName -eq $null) {
		WriteHelpText("You must specify the function name")
		exit 1
	}
	if ($Value -eq $null) {
		WriteHelpText("You must specify the value")
		exit 1
	}

	# Invoke REST API to get the list of devices including device name
	$devicesList = "http://${ezloIp}:17000/v1/method/hub.devices.list"
	$json = Invoke-RestMethod -Uri $devicesList
	$devices = $json.result.devices
	$deviceIdLookup = @{}
	foreach ($device in $devices) {
		$deviceIdLookup[$device._id] = $device.name
	}

	# Invoke REST API to get the list of items including item name and ID
	$itemsList = "http://${ezloIp}:17000/v1/method/hub.items.list"
	$json = Invoke-RestMethod -Uri $itemsList
	$items = $json.result.items
	$id = $null
	foreach ($item in $items) {
		$name = $deviceIdLookup[$item.deviceId]

		# If the lowercase name of the device and item match the lowercase arguments, then set the ID
		if ($item.name.ToString().ToLower() -eq $ItemName.ToString().ToLower() -and $name.ToLower() -eq $DeviceName.ToString().ToLower()) {
			$id = $item._id
			break
		}
	}

	# If $id is not set, then exit
	if (-not $id) {
		if ($null -eq $DeviceName -or $DeviceName.Length -eq 0) {
			$DeviceName = "NOT SET"
		}
		if ($null -eq $ItemName -or $ItemName.Length -eq 0) {
			$ItemName = "NOT SET"
		}

		WriteHelpText("Device $($DeviceName) or item $($ItemName) not found")
		exit 1
	}

	# Call the API to set the value
	$url = "http://${ezloIp}:17000/v1/method/hub.item.value.set?_id=${id}&value_int=${Value}"
	Write-Output "Device: $DeviceName"
	Write-Output "Item: $ItemName"
	Write-Output "Value: $Value"
	Write-Output "Calling: $url"
	Invoke-RestMethod -Uri $url | Out-Null
}
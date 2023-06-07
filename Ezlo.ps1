# Set your Ezlo IP address here
$ezloIp = '192.168.0.16'

# The key to show the array of devices
$SDA_KEY = "Show_Devices_Array"

# If Show_Devices_Array is the first argument, then show the array and exit
if ($args[0] -and $args[0].ToLower() -eq $SDA_KEY) {
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
	# Ensure the correct number of arguments is provided
	if ($args.Length -ne 3) {
		Write-Warning "Wrong number of arguments"
		Write-Warning "You must specify the device name, function name and value"
		Write-Warning "For example: .\Ezlo.ps1 'Office Light' 'Switch' 1"
		Write-Warning "To see the list of devices, specify 'Show_Devices_Array' as the only argument"
		exit 1
	}

	$deviceName = $args[0]
	$itemName = $args[1]
	$value = $args[2]

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
		if ($item.name.ToString().ToLower() -eq $itemName.ToString().ToLower() -and $name.ToLower() -eq $deviceName.ToString().ToLower()) {
			$id = $item._id
			break
		}
	}

	# If $id is not set, then exit
	if (-not $id) {
		Write-Warning "Device $($deviceName) or item $($itemName) not found"
		Write-Warning "You must specify the device name, function name and value"
		Write-Warning "For example: .\Ezlo.ps1 'Office Light' 'Switch' 1"
		Write-Warning "To see the list of devices, specify 'Show_Devices_Array' as the only argument"
		exit 1
	}

	# Call the API to set the value
	$url = "http://${ezloIp}:17000/v1/method/hub.item.value.set?_id=${id}&value_int=${value}"
	Write-Output "Device: $deviceName"
	Write-Output "Item: $itemName"
	Write-Output "Value: $value"
	Write-Output "Calling: $url"
	Invoke-RestMethod -Uri $url | Out-Null
}
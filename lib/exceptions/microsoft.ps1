function Update-ApplicationIcon {
    param (
        [string]$Uid,
        [string]$Icon
    )

    # Global
    $headers = @{
        "Accept" = "application/json"
    }
    $apiBase = "https://definitely-firm-chamois.ngrok-free.app"

    # Retrieve data for the specified Uid
    $uri = "${apiBase}/api/Application/byuid/$Uid"
    $jsonData = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers

    # Create the updated custom object
    $newObject = [PSCustomObject]@{
        id = $jsonData.id
        uid = $jsonData.uid
        lastUpdate = $jsonData.lastUpdate
        applicationCategory = $jsonData.applicationCategory
        publisher = $jsonData.publisher
        name = $jsonData.name
        version = $jsonData.version
        copyright = $jsonData.copyright
        licenseAcceptRequired = $jsonData.licenseAcceptRequired
        lcid = @($jsonData.lcid)
        cpuArch = @($jsonData.cpuArch)
        homepage = $jsonData.homepage
        icon = $Icon
        docs = $jsonData.docs
        license = $jsonData.license
        tags = $jsonData.tags
        summary = $jsonData.summary
        enabled = $jsonData.enabled
    }
    $payload = $newObject | ConvertTo-Json

    # Update the data using PUT request
    $response = Invoke-RestMethod -Method Put -Uri "${apiBase}/api/Application/$($jsonData.id)" -Headers $headers -Body $payload -ContentType "application/json"

    # Display the response
    $response
}

# Usage
# Define a dictionary with Uid as keys and Icon URLs as values
$applicationIcons = @{
    "Microsoft.Edge.Beta" = "https://github.com/OptechX/library.apps.images/raw/main/Microsoft/Microsoft Corporation/Microsoft.Edge.Beta/icon.png"
    "Microsoft.Edge.Dev" = "https://github.com/OptechX/library.apps.images/raw/main/Microsoft/Microsoft Corporation/Microsoft.Edge.Dev/icon.png"
    "Microsoft.Edge.Canary" = "https://github.com/OptechX/library.apps.images/raw/main/Microsoft/Microsoft Corporation/Microsoft.Edge.Canary/icon.png"
    "Microsoft.IronPython.2" = "https://github.com/OptechX/library.apps.images/raw/main/Microsoft/IronPython Team/Microsoft.IronPython.2/icon.png"
}

# Iterate over the dictionary and call the function
$applicationIcons.GetEnumerator() | ForEach-Object {
    $Uid = $_.Key
    $Icon = $_.Value
    Update-ApplicationIcon -Uid $Uid -Icon $Icon
}

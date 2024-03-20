# Define the path to the LayoutModification.xml file
$xmlFilePath = "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"

# Check if the file exists
if (Test-Path $xmlFilePath) {
    Write-Host "File found: $xmlFilePath"
} else {
    Write-Host "File not found: $xmlFilePath. Exiting script."
    exit
}

# Load the XML file
try {
    [xml]$xmlContent = Get-Content -Path $xmlFilePath
    Write-Host "Successfully loaded the XML file."
} catch {
    Write-Host "Failed to load the XML file. Exiting script."
    exit
}

# Define the namespaces used in the XML document
$namespaceManager = New-Object System.Xml.XmlNamespaceManager($xmlContent.NameTable)
$namespaceManager.AddNamespace('defaultlayout', 'http://schemas.microsoft.com/Start/2014/LayoutModification')
$namespaceManager.AddNamespace('taskbar', 'http://schemas.microsoft.com/Start/2014/TaskbarLayout')

# Define the AppUserModelIDs to remove
$appUserModelIDsToRemove = @(
    "9426MICRO-STARINTERNATION.DragonCenter_kzh8wxbdkxb8p!App",
    "9426MICRO-STARINTERNATION.CreatorCenter_kzh8wxbdkxb8p!App",
    "9426MICRO-STARINTERNATION.BusinessCenter_kzh8wxbdkxb8p!App",
    "9426MICRO-STARINTERNATION.MSICenter_kzh8wxbdkxb8p!App",
    "Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App"
)

# Remove the specified elements
foreach ($id in $appUserModelIDsToRemove) {
    $elements = $xmlContent.SelectSingleNode("//taskbar:UWA[@AppUserModelID='$id']", $namespaceManager)
    if ($elements -ne $null) {
        $elements.ParentNode.RemoveChild($elements)
        Write-Host "Removed element with AppUserModelID: $id"
    } else {
        Write-Host "Element with AppUserModelID: $id not found."
    }
}

# Save the modified XML back to the file
try {
    $xmlContent.Save($xmlFilePath)
    Write-Host "The XML file has been successfully updated and saved."
} catch {
    Write-Host "Failed to save the updated XML file. You might not have the necessary permissions."
}

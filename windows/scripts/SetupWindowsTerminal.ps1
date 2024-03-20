# Check if the script is running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please rerun the script as an administrator."
    Write-Host "To run the script in unrestricted mode, you can start PowerShell as an administrator and use the command below:"
    Write-Host "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass"
    exit
}


# Install oh-my-posh
Write-Host "Installing oh-my-posh..."
winget install JanDeDobbeleer.OhMyPosh -s winget
Write-Host "Appending oh-my-posh to PATH..."
$env:Path += ";C:\Users\$env:UserName\AppData\Local\Programs\oh-my-posh\bin"

# Install and update posh-git
Write-Host "Installing posh-git..."
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
PowerShellGet\Update-Module posh-git

# Install Font
Write-Host "Installing font..."
oh-my-posh font install UbuntuMono

# Define the URL of the raw settings.json file from your GitHub repository
$settingsUrl = "https://github.com/jjjccw/environment/raw/main/windows/settings.json"

# Define the path to the Windows Terminal settings.json file on your local machine
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Use Invoke-WebRequest to download the file and replace the existing settings.json
Invoke-WebRequest -Uri $settingsUrl -OutFile $settingsPath

Write-Host "Windows Terminal settings.json has been successfully replaced."

# URL of the JSON file in your GitHub repository
$jsonConfigUrl = "https://github.com/jjjccw/environment/raw/main/windows/jjjccw.omp.json"

# Download the JSON file and place it in the $env:POSH_THEMES_PATH directory
$themePath = Join-Path $env:POSH_THEMES_PATH "jjjccw.omp.json"
Invoke-WebRequest -Uri $jsonConfigUrl -OutFile $themePath

# Check if the PowerShell profile exists, and create it if it does not
if (-not (Test-Path $PROFILE.AllUsersAllHosts)) {
    New-Item -Type File -Path $PROFILE.AllUsersAllHosts -Force | Out-Null
}


# Add oh-my-posh initialization and posh-git to the profile
$profileContent = @"
oh-my-posh init pwsh --config `"$env:POSH_THEMES_PATH\jjjccw.omp.json`" | Invoke-Expression
"@

# Ensure correct escape for regex use
$escapedProfileContent = [regex]::Escape($profileContent)

# Check if the profile already contains the specified content
if (-not (Select-String -Path $PROFILE.AllUsersAllHosts -Pattern $escapedProfileContent -Quiet)) {
    "Setting default oh-my-posh config..."
    Add-Content -Path $PROFILE.AllUsersAllHosts -Value $profileContent
}
else {
    Write-Host "Default oh-my-posh config already correct, skipping..."
}

# Perform the operation to add posh-git to the profile
Add-PoshGitToProfile

Write-Host "Done. Restart your terminal for changes to take effect."
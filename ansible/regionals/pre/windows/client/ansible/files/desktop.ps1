# Define the source directory where the shortcuts are located
$sourceDirectory = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

# Define the destination directory for the Public Desktop
$publicDesktopDirectory = [System.Environment]::GetFolderPath("CommonDesktopDirectory")

# Check if the destination directory exists, and if not, create it
if (-not (Test-Path -Path $publicDesktopDirectory)) {
    New-Item -Path $publicDesktopDirectory -ItemType Directory
}

# Get a list of all shortcut files in the source directory
$shortcutFiles = Get-ChildItem -Path $sourceDirectory -Recurse -File -Filter *.lnk

# Copy each shortcut to the Public Desktop directory for all users
foreach ($shortcutFile in $shortcutFiles) {
    $destinationPath = Join-Path -Path $publicDesktopDirectory -ChildPath $shortcutFile.Name
    Copy-Item -Path $shortcutFile.FullName -Destination $destinationPath -Force
}

Write-Host "Shortcuts copied to Public Desktop for all users."

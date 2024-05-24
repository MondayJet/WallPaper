<#
.SYNOPSIS
    Script to download Desktop Wallpaper
    This script downloads a desktop wallpaper image and saves it to a specified directory on Windows.
    It can either download a predefined image or fetch the daily Bing wallpaper based on a flag.
#>

# Define variables
$useBingWallpaper = $false # Set to $true to have the script fetch wallpaper from Bing
$wallpaperUrl = "https://i.imgur.com/pPpDNMR.png" # Default wallpaper URL
$wallpaperDir = "C:\Users\Public\Desktop" # Directory to save the wallpaper
$wallpaperFile = "Wallpaper.png" # Name of the wallpaper file
$log = "C:\var\log\fetchdesktopwallpaper.log" # Log file location for script output and errors

# Start logging
# Redirects standard output and standard error to the log file
Start-Transcript -Path $log -Append

# Log the start of the script execution with a timestamp for tracking purposes
Write-Output ""
Write-Output "##############################################################"
Write-Output "# $(Get-Date) | Starting download of Desktop Wallpaper"
Write-Output "############################################################"
Write-Output ""

# Check if the wallpaper directory exists and create it if it's missing
if (Test-Path $wallpaperDir) {
    # Log that the directory already exists
    Write-Output "$(Get-Date) | Wallpaper dir [$wallpaperDir] already exists"
} else {
    # Log the creation of the directory and create it
    Write-Output "$(Get-Date) | Creating [$wallpaperDir]"
    New-Item -ItemType Directory -Path $wallpaperDir
}

# Attempt to download the image file
# No point checking if it already exists since we want to overwrite it anyway
if ($useBingWallpaper -eq $true) {
    # Log the attempt to determine the URL of today's Bing wallpaper
    Write-Output "$(Get-Date) | Attempting to determine URL of today's Bing Wallpaper"
    
    # Fetch the Bing homepage HTML and extract the URL of today's wallpaper image
    $bingHtml = Invoke-WebRequest -Uri "https://www.bing.com"
    $bingFileUrl = ($bingHtml.Content -match "th\?id=.*?.jpg")[0] -replace "tmb", "1920x1200"
    
    # Construct the full URL for the Bing wallpaper
    $wallpaperUrl = "https://bing.com/$bingFileUrl"
    
    # Log the new wallpaper URL
    Write-Output "$(Get-Date) | Setting wallpaperUrl to today's Bing Desktop [$wallpaperUrl]"
}

# Log the attempt to download the wallpaper
Write-Output "$(Get-Date) | Downloading Wallpaper from [$wallpaperUrl] to [$wallpaperDir\$wallpaperFile]"

# Use Invoke-WebRequest to download the wallpaper
try {
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile "$wallpaperDir\$wallpaperFile"
    # Log the successful download
    Write-Output "$(Get-Date) | Wallpaper [$wallpaperUrl] downloaded to [$wallpaperDir\$wallpaperFile]"
    
    # Uncomment the following line to refresh the desktop wallpaper immediately after downloading
    # Add code to set the desktop wallpaper on Windows if needed
    
    # Exit the script with a success status
    Exit 0
} catch {
    # Log the failure to download the wallpaper
    Write-Output "$(Get-Date) | Failed to download wallpaper image from [$wallpaperUrl]"
    
    # Exit the script with a failure status
    Exit 1
}

# Stop logging
Stop-Transcript

# Function to download the Bing wallpaper of the day
function Download-BingWallpaper {
    $bingUrl = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"
    $response = Invoke-WebRequest -Uri $bingUrl -Method Get -UseBasicParsing
    $wallpaperUrl = "https://www.bing.com" + ($response.Content | ConvertFrom-Json).images.url

    $wallpaperPath = "$env:TEMP\bing_wallpaper.jpg"
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath

    return $wallpaperPath
}

# Function to set the wallpaper
function Set-Wallpaper {
    param (
        [string]$WallpaperPath
    )
    # Use registry to set wallpaper (works for Windows 7 and later)
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper -Value $WallpaperPath
    # Update the system parameters to reflect the changes
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

# Main script
$wallpaperPath = Download-BingWallpaper
Set-Wallpaper -WallpaperPath $wallpaperPath

#!/bin/bash
#set -x
 
############################################################################################
##
## Script to download Desktop Wallpaper
##
###########################################
 
## Copyright (c) 2020 Microsoft Corp. All rights reserved.
## Scripts are not supported under any Microsoft standard support program or service. The scripts are provided AS IS without warranty of any kind.
## Microsoft disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a
## particular purpose. The entire risk arising out of the use or performance of the scripts and documentation remains with you. In no event shall
## Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
## (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary
## loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility
## of such damages.
## Feedback: neiljohn@microsoft.com
 
#!/bin/bash
# This script downloads and sets a wallpaper on a macOS system.
# It can either download a predefined image or fetch the daily Bing wallpaper.

# Define variables

# Set to true to fetch the wallpaper from Bing. If false, it uses the predefined URL.
usebingwallpaper=false

# Default wallpaper URL (used if usebingwallpaper is false)
wallpaperurl="https://i.imgur.com/pPpDNMR.png" #https://i.imgur.com/pPpDNMR.png

# Directory where the wallpaper will be saved
wallpaperdir="/Library/Desktop"

# Name of the wallpaper file
wallpaperfile="Wallpaper.jpg"

# Log file location for recording the script's output and errors
log="/var/log/fetchdesktopwallpaper.log"

# Start logging
# Redirects standard output (stdout) and standard error (stderr) to the log file
exec 1>> $log 2>&1

# Log the start of the script execution with a timestamp for tracking
echo ""
echo "##############################################################"
echo "# $(date) | Starting download of Desktop Wallpaper"
echo "############################################################"
echo ""

# Check if the wallpaper directory exists and create it if it's missing
if [ -d $wallpaperdir ]; then
    # Log that the directory already exists
    echo "$(date) | Wallpaper dir [$wallpaperdir] already exists"
else
    # Log the creation of the directory and create it
    echo "$(date) | Creating [$wallpaperdir]"
    mkdir -p $wallpaperdir
fi

# Attempt to download the image file
# No point checking if it already exists since we want to overwrite it anyway
if [ "$usebingwallpaper" = true ]; then
    # Log the attempt to determine the URL of today's Bing wallpaper
    echo "$(date) | Attempting to determine URL of today's Bing Wallpaper"
    
    # Fetch the Bing homepage HTML and extract the URL of today's wallpaper image
    bingfileurl=$(curl -sL https://www.bing.com | grep -Eo "th\?id=.*?.jpg" | sed -e "s/tmb/1920x1200/")
    
    # Construct the full URL for the Bing wallpaper
    wallpaperurl="https://bing.com/$bingfileurl"
    
    # Log the new wallpaper URL
    echo "$(date) | Setting wallpaperurl to today's Bing Desktop [$wallpaperurl]"
fi

# Log the attempt to download the wallpaper
echo "$(date) | Downloading Wallpaper from [$wallpaperurl] to [$wallpaperdir/$wallpaperfile]"

# Use curl to download the wallpaper
curl -L -o $wallpaperdir/$wallpaperfile $wallpaperurl

# Check the exit status of the curl command to determine if the download was successful
if [ "$?" = "0" ]; then
    # Log the successful download
    echo "$(date) | Wallpaper [$wallpaperurl] downloaded to [$wallpaperdir/$wallpaperfile]"
    
    # Uncomment the following line to refresh the desktop wallpaper immediately after downloading
    #killall Dock
    
    # Exit the script with a success status
    exit 0
else
    # Log the failure to download the wallpaper
    echo "$(date) | Failed to download wallpaper image from [$wallpaperurl]"
    
    # Exit the script with a failure status
    exit 1
fi

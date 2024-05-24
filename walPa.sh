#!/bin/bash
# Uncomment the following line for debugging mode to see each command executed
# set -x

############################################################################################
##
## Script to download Desktop Wallpaper
## This script downloads a desktop wallpaper image and saves it to a specified directory on macOS.
## It can either download a predefined image or fetch the daily Bing wallpaper based on a flag.
##
############################################################################################

# Define variables
usebingwallpaper=false # Set to true to have the script fetch wallpaper from Bing
wallpaperurl="https://i.imgur.com/XPdjuFS.png" # Default wallpaper URL
wallpaperdir="/Library/Desktop" # Directory to save the wallpaper
wallpaperfile="Wallpaper.jpg" # Name of the wallpaper file
log="/var/log/fetchdesktopwallpaper.log" # Log file location for script output and errors

# Start logging
# Redirects standard output (stdout) and standard error (stderr) to the log file
exec 1>> $log 2>&1

# Log the start of the script execution with a timestamp for tracking purposes
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

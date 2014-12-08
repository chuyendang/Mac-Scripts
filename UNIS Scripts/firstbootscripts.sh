#!/bin/bash
# dvchuyen@unishanoi.org
# First Boot Script
# Version 1.3 for Mavericks
# 2014 Oct 17

firstbootscripts="/private/var/firstbootscripts.sh"
log_location="/private/var/log/firstbootscripts.log"
archive_log_location="/private/var/log/firstbootscripts-`date +%Y-%m-%d-%H-%M-%S`.log"
LoginLogLaunchAgent="/Library/LaunchAgents/org.unishanoi.LoginLog.plist"
LoginLogApp="/Library/PrivilegedHelperTools/LoginLog.app"

# Function to provide logging of the script's actions to
# the log file defined by the log_location variable

ScriptLogging(){

    DATE=`date +%Y-%m-%d\ %H:%M:%S`
    LOG="$log_location"
    
    echo "$DATE" " $1" >> $LOG
}

# LaunchDaemon in /System/Library/LaunchDaemons/
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.loginwindow.plist
/bin/launchctl load -S loginwindow $LoginLogLaunchAgent

# Wait up for a network connection to become active

  ScriptLogging "Checking for active network connection."
  ScriptLogging "========================================="
  
 ((count = 10))                            
while [[ $count -ne 0 ]] ; do
    ping -c 1 172.16.0.27                    
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))                      
    fi
    ((count = count - 1))                  
done

if [[ $rc -eq 0 ]] ; then                 
    NETWORKUP="-YES-"
else
    NETWORKUP="-NO-"
fi
  
  if [[ "${NETWORKUP}" != "-YES-" ]]; then
   ScriptLogging "Could not ping DC2, Macbook will reboot in 10 seconds..."

   # Sleeping for 10 seconds to allow folks to read the last message
  
   /bin/sleep 10
   /sbin/reboot
  fi
  
  if [[ "${NETWORKUP}" == "-YES-" ]]; then
   ScriptLogging "Connected to UNIS network. Proceeding..."
  fi

#Begin run first boot scripts - UNIS
#dvchuyen@unishanoi.org 12 Sep 2014
ScriptLogging "Please be patient. This process may take a while to complete."
sleep 5

ScriptLogging "Settingtime and timezone..."
#set time zone and time server
systemsetup -settimezone Asia/Ho_Chi_Minh
systemsetup -setnetworktimeserver dc2.unishanoi.org
systemsetup -setusingnetworktime on
ntpdate -vu dc2.unishanoi.org
sleep 3

# Set the login window to name and password
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Allow click thru clock to see IP, Host Name, OS version
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable Time Machine's pop-up message whenever an external drive is plugged in
defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Turn off DS_Store file creation on network volumes
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores true

# Set Energy Saver.
ScriptLogging "Setting Engergy Saver..."
IS_LAPTOP=`/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book"`

if [ "$IS_LAPTOP" != "" ]; then
	pmset -b sleep 30 disksleep 20 displaysleep 15 halfdim 1
	pmset -c sleep 0 disksleep 0 displaysleep 30 halfdim 1
else	
	pmset sleep 0 disksleep 0 displaysleep 30 halfdim 1
fi

#suppresses iCloud Setup screen when new users log in for the first time
#check if the plist is already in place , and valid 
plistok_command=$(plutil /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant.plist)
plistok=$?
if [ "$plistok" ]; then
	#create the plist file from scratch  - it's either not there or not valid
	defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant.plist -dict ''
fi

#determine the OS Version - works for version numbers like 10.9,10.10,10.9.4
systemversion=$(system_profiler SPSoftwareDataType|grep "System Version"|sed -e "s/.*OS X //;s/\([0-9]*\.[0-9]*\).*/\1/g")
#insert the required values into the Setup assistant plist
plutil -insert LastSeenCloudProductVersion -string $systemversion /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant.plist
plutil -insert DidSeeCloudSetup -bool true /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.SetupAssistant.plist

#Binding to AD
ScriptLogging "Binding to Active Directory..."
dsconfigad -add "unishanoi.org" -username "tcatech@unishanoi.org" -password "-------" -alldomains enable -mobile enable -mobileconfirm disable -preferred dc2.unishanoi.org -localhome enable -ou "OU=Macs,OU=UNIS Computers,DC=UNISHANOI,DC=ORG" -group "UNISHANOI\Domain Admins,UNISHANOI\Tech Support" -force
sleep 3

#Add Tech support group to local admin
dseditgroup -o edit -a "UNISHANOI\Tech Support" -t group admin

#Install Wifi Profile
ScriptLogging "Installing Wifi Profile.."
profiles -I -F /private/var/wifi.machine.mobileconfig
sleep 2

# Turn SSH on
systemsetup -setremotelogin on

# Allow everyone add-remove printers
dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

# Disable external accounts (i.e. accounts stored on drives other than the boot drive.)
defaults write /Library/Preferences/com.apple.loginwindow EnableExternalAccounts -bool false

# Turn off Gatekeeper
spctl --master-disable

ScriptLogging "All done!... Restarting Mac." 
sleep 3

# Remove items
 /bin/launchctl unload -S loginwindow $LoginLogLaunchAgent
 /bin/rm $LoginLogLaunchAgent
 /bin/rm -rf $LoginLogApp
 /bin/launchctl load /System/Library/LaunchDaemons/com.apple.loginwindow.plist
 /bin/rm -rf /Library/LaunchDaemons/org.unishanoi.initialsetup.plist
 /bin/rm -rf  /private/var/wifi.machine.mobileconfig
 /bin/rm $0
 
# Reboot  
 /bin/sleep 2
 /sbin/reboot
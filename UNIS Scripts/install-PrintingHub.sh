#!/bin/sh
 
# Script to install and setup Printing Hub
# dvchuyen@unishanoi.org - 2014 Oct 20
# Need to install the required drivers first!

printername="PRINTING_HUB"
gui_display_name="Fuji Xerox Printing Hub"
address="smb://print.unishanoi.org/Fuji%20Xerox%20Printing%20Hub"
driver_ppd="/Library/Printers/PPDs/Contents/Resources/FX Print Driver for Mac OS X.gz"

# Populate these options if you want to set specific options for the printer. E.g. duplexing installed, etc.
option_1="FXColorMode=Black"
option_2="auth-info-required=negotiate"
option_3=""
 
### Printer Install ###
# In case we are making changes to a printer we need to remove an existing queue if it exists.
/usr/bin/lpstat -p $printername
if [ $? -eq 0 ]; then
        /usr/sbin/lpadmin -x $printername
fi
 
# Now we can install the printer.
/usr/sbin/lpadmin \
        -p "$printername" \
        -L "$location" \
        -D "$gui_display_name" \
        -v "$address" \
        -P "$driver_ppd" \
        -o "$option_1" \
        -o "$option_2" \
        -o "$option_3" \
        -o printer-is-shared=false \
        -E

# Enable and start the printers on the system (after adding the printer initially it is paused).
/usr/sbin/cupsenable $(lpstat -p | grep -w "printer" | awk '{print$2}')
 
exit 0
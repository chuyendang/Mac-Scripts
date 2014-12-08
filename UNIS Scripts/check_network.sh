#!/bin/bash

 ((count = 10))                            # Maximum number to try.
while [[ $count -ne 0 ]] ; do
    ping -c 1 172.16.0.27                    # Try once.
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))                      # If okay, flag to exit loop.
    fi
    ((count = count - 1))                  # So we don't go forever.
done

if [[ $rc -eq 0 ]] ; then                  # Make final determination.
    NETWORKUP="-YES-"
else
    NETWORKUP="-NO-"
fi


	if [[ "${NETWORKUP}" != "-YES-" ]]; then
   echo= "Could not ping to DC2, Macbook will reboot in 10 seconds..."

   # Sleeping for 10 seconds to allow folks to read the last message
  
   /bin/sleep 10
   /sbin/reboot
  fi
  
  if [[ "${NETWORKUP}" == "-YES-" ]]; then
   echo=  "Active network connection detected. Proceeding."
  fi
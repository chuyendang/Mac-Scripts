#!/bin/bash
# =========================
# Add User OSX Command Line
# =========================

# === Typically, this is all the info you need to enter ===

# echo "Enter your desired user name: "
# read USERNAME
USERNAME="unis"

# echo "Enter a full name for this user: "
# read FULLNAME
FULLNAME="UNIS"

echo "Enter a password for this user: "
read -s PASSWORD

# ====

# Create a UID that is not currently in use
echo "Creating an unused UID for new user..."

if  $UID -ne 0 ; then echo "Please run $0 as root." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

# Create the user account by running dscl (normally you would have to do each of these commands one
# by one in an obnoxious and time consuming way.
echo "Creating necessary files..."

dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$FULLNAME"
dscl . -create /Users/$USERNAME UniqueID "$USERID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
dscl . -passwd /Users/$USERNAME $PASSWORD
dscl . -append /Groups/admin GroupMembership $USERNAME

# Create the home directory
echo "Creating home directory..."
createhomedir -c 2>&1 | grep -v "shell-init"

echo "Created user #$USERID: $USERNAME ($FULLNAME)"
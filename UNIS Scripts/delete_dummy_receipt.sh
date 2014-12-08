#!/bin/bash

# Delete dummy receipts for old versions of iWork and iLife apps

if [ -f /Applications/iPhoto.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/iPhoto.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/iPhoto.app/Contents/Info CFBundleShortVersionString` == 9.5.1 ]];then
			rm /Applications/iPhoto.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for iPhoto.app"
		fi
	fi
fi
if [ -f /Applications/iMovie.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/iMovie.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/iMovie.app/Contents/Info CFBundleShortVersionString` == 10.0.2 ]];then
			rm /Applications/iMovie.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for iMovie.app"
		fi
	fi
fi
if [ -f /Applications/GarageBand.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/GarageBand.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/GarageBand.app/Contents/Info CFBundleShortVersionString` == 10.0.1 ]];then
			rm /Applications/GarageBand.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for GarageBand.app"
		fi
	fi
fi
if [ -f /Applications/Keynote.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/Keynote.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/Keynote.app/Contents/Info CFBundleShortVersionString` == 6.1 ]];then
			rm /Applications/Keynote.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for Keynote.app"
		fi
	fi
fi
if [ -f /Applications/Numbers.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/Numbers.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/Numbers.app/Contents/Info CFBundleShortVersionString` == 3.1 ]];then
			rm /Applications/Numbers.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for Numbers.app"
		fi
	fi
fi
if [ -f /Applications/Pages.app/Contents/_MASReceipt/receipt ];then
	if [ ! -s /Applications/Pages.app/Contents/_MASReceipt/receipt ];then
		if [[ ! `defaults read /Applications/Pages.app/Contents/Info CFBundleShortVersionString` == 5.1 ]];then
			rm /Applications/Pages.app/Contents/_MASReceipt/receipt
			echo "Deleted receipt for Pages.app"
		fi
	fi
fi
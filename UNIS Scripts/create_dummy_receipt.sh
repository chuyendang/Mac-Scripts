#!/bin/bash

# Create dummy receipts for iWork and iLife apps

if [ -d /Applications/iPhoto.app ];then
	mkdir -m 755 /Applications/iPhoto.app/Contents/_MASReceipt
	touch /Applications/iPhoto.app/Contents/_MASReceipt/receipt
fi
if [ -d /Applications/iMovie.app ];then
	mkdir -m 755 /Applications/iMovie.app/Contents/_MASReceipt
	touch /Applications/iMovie.app/Contents/_MASReceipt/receipt
fi
if [ -d /Applications/GarageBand.app ];then
	mkdir -m 755 /Applications/GarageBand.app/Contents/_MASReceipt
	touch /Applications/GarageBand.app/Contents/_MASReceipt/receipt
fi
if [ -d /Applications/Keynote.app ];then
	mkdir -m 755 /Applications/Keynote.app/Contents/_MASReceipt
	touch /Applications/Keynote.app/Contents/_MASReceipt/receipt
fi
if [ -d /Applications/Numbers.app ];then
	mkdir -m 755 /Applications/Numbers.app/Contents/_MASReceipt
	touch /Applications/Numbers.app/Contents/_MASReceipt/receipt
fi
if [ -d /Applications/Pages.app ];then
	mkdir -m 755 /Applications/Pages.app/Contents/_MASReceipt
	touch /Applications/Pages.app/Contents/_MASReceipt/receipt
fi
#!/bin/bash
security add-trusted-cert -d -r trustAsRoot -k "/Library/Keychains/System.keychain" "/usr/local/etc/scripts/unis-wifi-cer-1.cer"
security add-trusted-cert -d -r trustAsRoot -k "/Library/Keychains/System.keychain" "/usr/local/etc/scripts/unis-wifi-cer-2.cer"
rm "/usr/local/etc/scripts/unis-wifi-cer-1.cer"
rm "/usr/local/etc/scripts/unis-wifi-cer-2.cer"
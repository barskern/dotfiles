#!/usr/bin/env bash
#
# replicate-keyusbs
#
set -e

cp -an /media/usb/keyusb/. /media/usb/keyusb2/
cp -an /media/usb/keyusb2/. /media/usb/keyusb/

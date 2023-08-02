#!/bin/bash

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Roy van der Veen <roy@ijsco-media.nl> wrote this file. As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------

set -e

./run.sh
python build_image.py
python show_image_inky7.py arts/output-latest.png
rm arts/*
sleep 30

#!/bin/bash

# phpVMS - Virtual Airline Administration Software
# Copyright (c) 2008 Nabeel Shahzad
#
# phpVMS is licenced under the following license:
#   Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)
#   View license.txt in the root, or visit:
#	http://creativecommons.org/licenses/by-nc-sa/3.0/


DOWNLOAD_URL="http://downloads.phpvms.net/phpvms.full.tar.gz"
UPDATE_URL="http://downloads.phpvms.net/phpvms.update.tar.gz"
BETA_URL="http://downloads.phpvms.net/phpvms.beta.tar.gz"

CURRENT_PATH=`pwd`

echo "phpVMS Installer Script"
echo "What do you want to do? "
echo "(1 = new phpVMS, 2 = update phpVMS, 3 = update phpVMS to beta)"
echo -n "> "
read INSTALL_TYPE

echo "Current path is $CURRENT_PATH, enter new path to change, or blank to use it"
echo -n "> "
read NEW_PATH

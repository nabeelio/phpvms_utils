#!/bin/bash

# phpVMS - Virtual Airline Administration Software
# Copyright (c) 2008 Nabeel Shahzad
#
# phpVMS is licenced under the following license:
#   Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)
#   View license.txt in the root, or visit:
#	http://creativecommons.org/licenses/by-nc-sa/3.0/
#
# This is an installer script - gives you the option to install
# a new copy of phpVMS, update an existing copy, or update beta
# copies. This should be placed in the same directory as your
# phpVMS install, or where you want it to be installed. To run:
#
# chmod +x ./phpvms_install.sh
# ./phpvms_install.sh
#
# Note: It requires read/write permissions in the directory it's 
# running. It will create a temporary directory to download and
# extract the files it needs.
#
# AS A PRECAUTION, MAKE A COPY OF YOUR LOCAL.CONFIG.PHP FILE.
# I attempt to make a backup of it (core/local.config.php.1),
# I then restore the local.config.php file and remove the .1 file
# for security purposes. But JUST IN CASE!! Make a backup.


DOWNLOAD_URL="http://downloads.phpvms.net"
CURRENT_PATH=`pwd`
TMP=`date +%Y.%m.%d`

echo "======================="
echo "phpVMS Installer Script"
echo "Copyright (c) 2010 http://www.phpvms.net"
echo "Licenced under the following license:"
echo "Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)"
echo "  View license.txt or visit http://creativecommons.org/licenses/by-nc-sa/3.0/"
echo
echo "Open this file to see detailed instructions"
echo 

# Get the proper path to phpVMS
echo "Step 1: Path to phpVMS. Current path is \"$CURRENT_PATH\"."
echo "  Press enter to use the above, or enter the correct path (absolute path)"
echo -n "> "
read NEW_PATH
echo

# See if they entered a path
if [ ! -z "$NEW_PATH" ]; then
   CURRENT_PATH="$NEW_PATH"
fi

# Some paths we need later on
CORE_PATH=$CURRENT_PATH"/core"
INSTALL_PATH=$CURRENT_PATH"/install"
TMP_PATH=$CURRENT_PATH"/tmp"$TMP

# Determine the version file we're using
VERSION_FILE=$CORE_PATH"/version"
if [ ! -f "$VERSION_FILE" ]; then
  VERSION_FILE=$INSTALL_PATH"/version"
  if [ ! -f "$VERSION_FILE" ]; then
	echo -n
  fi
fi

# Read the install type
while true; do

   echo "Step 2. Select the operation you'd like to perform"
   echo -n "  (N)ew Install  (U)pdate  (B)eta  (Q)uit > "
   read INSTALL_TYPE

   case $INSTALL_TYPE in 

	# Do a fresh install
	[Nn]* )
	   FILE_NAME="phpvms.full.tar.gz"
	   break;;

	# Do an upgrade install
	[Uu]* )
	   if [ ! -d "$CORE_PATH" ]; then
		echo "Not a valid path to phpVMS!"
	        exit;
	   fi

	   CURRENT_VERSION=`cat $VERSION_FILE`
	   LATEST_VERSION=`wget -q --output-document - $DOWNLOAD_URL/release.version`
  	   FILE_NAME="phpvms.update.tar.gz"

	   echo 
	   echo "Your version: x.x.$CURRENT_VERSION"
	   echo "Updating to $LATEST_VERSION"

	   break;;

	# Do a beta install
	[Bb]* )
	   
	   echo "This will install a copy of the beta, either over an existing install, or as a new install"

	   CURRENT_VERSION=`cat $VERSION_FILE`
	   LATEST_VERSION=`wget -q --output-document - $DOWNLOAD_URL/beta.version`
	   FILE_NAME="phpvms.beta.tar.gz"

	   echo 
	   echo "Current beta revision number: $LATEST_VERSION"

	   break;;

	[Qq]* ) exit;;
	* ) echo "Please enter a valid option";;
   esac

done;

echo
echo "You have 5 seconds now to cancel, if you're not sure... (hit Control+C)"
sleep 5s

# Now create the temporary paths we need
if [ ! -d "$TMP_PATH" ]; then
   mkdir -p "$TMP_PATH"
fi


echo "Downloading files..."
wget -q $DOWNLOAD_URL"/"$FILE_NAME --output-document $TMP_PATH"/"$FILE_NAME

echo "Extracting and copying"

# Utar, and remove the tar file
tar -xzvf $TMP_PATH"/"$FILE_NAME &> /dev/null
rm $TMP_PATH"/"$FILE_NAME &> /dev/null

# Remove the downloaded local.config.php file
rm $TMP_PATH"/core/local.config.php" &> /dev/null

# Copy everything to our destination
cp -R $TMP_PATH" "$CURRENT_PATH &> /dev/null

rm -drf $TMP_PATH

echo "Completed file upload! Please run the /install/install.php if it was a new install, or install/update.php if this was an upgrade"

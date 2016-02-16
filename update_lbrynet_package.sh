#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo"
  exit
fi

lbrynet_directory="/Users/${SUDO_USER}/Library/Application Support/lbrynet"

current_version=$(git ls-remote https://github.com/lbryio/lbry.git | grep HEAD | cut -f 1)

if [ -d "$lbrynet_directory" ]; then
	if [ -f "${lbrynet_directory}/version.txt" ]; then
		if grep -Fxq "$current_version" "${lbrynet_directory}/version.txt"; then
			echo "LBRYnet version $current_version is up to date"
			exit
		fi
	fi
fi

tmp=$(mktemp -d)
cd $tmp

echo "Downloading newest version of lbrynet"

git clone https://github.com/lbryio/lbry.git &>/dev/null
cd lbry

version=$(git rev-parse HEAD)
echo "Installing lbrynet"
sudo python setup.py install &>/dev/null
mkdir -p "$lbrynet_directory"
echo $version > "${lbrynet_directory}/version.txt"

echo "Cleaning up"

cd ../../
sudo rm -rf $tmp
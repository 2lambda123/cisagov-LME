#!/bin/bash

# Change to the directory where the script is located
script_dir=$(dirname "$0")
cd $script_dir || exit 1
# We need to get the full path of the script dir for below
script_dir=$(pwd)

# Default username
username="admin.ackbar"

# Parse flag-based arguments
while getopts "u:" opt; do
  case $opt in
    u) username=$OPTARG ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Download a copy of the LME files
#sudo git clone https://github.com/cisagov/lme.git /opt/lme/
sudo git clone -b cbaxley-122-testbed_from_scripts https://github.com/cisagov/lme.git /opt/lme/
# curl -s https://api.github.com/repos/cisagov/LME/releases/latest | jq -r '.assets[0].browser_download_url' | xargs -I {} sh -c 'curl -L -O {} && unzip -d /opt/lme/ "$(basename {})"'


echo 'export DEBIAN_FRONTEND=noninteractive' >> ~/.bashrc
echo 'export NEEDRESTART_MODE=a' >> ~/.bashrc
. ~/.bashrc

# Set the noninteractive modes for root
echo 'export DEBIAN_FRONTEND=noninteractive' | sudo tee -a /root/.bashrc
echo 'export NEEDRESTART_MODE=a' | sudo tee -a /root/.bashrc

# Execute script with root privileges
sudo "$script_dir/linux_install_lme.exp"

if [ -f "/opt/lme/files_for_windows.zip" ]; then
    sudo cp /opt/lme/files_for_windows.zip /home/"$username"/
    sudo chown "$username":"$username" /home/"$username"/files_for_windows.zip
else
    echo "files_for_windows.zip does not exist. Probably because the LME install requires a reboot."
fi

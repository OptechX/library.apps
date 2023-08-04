#!/bin/bash

# Install tool 'jq' and 'unzip'
sudo apt -y install jq unzip

# Replace OWNER and REPO_NAME with the owner and name of the repository
OWNER="OptechX"
REPO_NAME="OptechX.Library.Apps.UpdateTool"

# Get the latest release version
latest_release=$(curl -s "https://api.github.com/repos/${OWNER}/${REPO_NAME}/releases/latest" | jq -r '.tag_name')

# Extract version number from "vX.X.X"
version="${latest_release#v}"

# Download the oxlaut.zip file from the latest release
curl -sL -o oxlaut.zip "https://github.com/${OWNER}/${REPO_NAME}/releases/download/${latest_release}/oxlaut.zip"

# Print the version and download status
echo "Latest version: ${version}"
echo "Downloaded oxlaut.zip from the latest release."

# Unzip the oxlaut.zip file
mkdir -p /home/runner/work/library.apps/library.apps/bin
unzip oxlaut.zip
mv OptechX.Library.Apps.UpdateTool/bin/Release/net7.0/linux-x64/publish/oxlaut ./bin
rm -rf OptechX.Library.Apps.UpdateTool
chmod +x ./bin/oxlaut
echo "oxlaut.zip has been successfully unzipped."
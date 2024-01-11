#!/bin/s
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

# Script to document and automate the installation of software needed for the Spezi Template Application
#
# It is required that Xcode is installed on the macOS instance.

# 1. Install homebrew
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"


# 2. Install tools
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc

brew install node
brew install firebase-cli
brew install fastlane
# Set the local correctly to work with fastlane
echo 'export LC_ALL=en_US.UTF-8' >> ~/.zshrc
echo 'export LANG=en_US.UTF-8' >> ~/.zshrc

brew install swiftlint

brew install git-lfs
git lfs install
git lfs install --system

brew tap FelixHerrmann/tap
brew install swift-package-list

# Ensure that everything on the system is up-to-date
brew upgrade


# 3. Test and start the firebase emulator
firebase emulators:exec --project test "echo 'Firebase emulator installed and started successfully!'"

#!/bin/bash
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

export LC_CTYPE=UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Function to display an error message, show the help, and exit
error_exit_help() {
    echo "Error: $1" >&2
    show_help
    exit 1
}

# Function to display help message
show_help() {
    echo "Usage: $0 --name <appName> --bundleIdentifier <bundleId> [--provisioningProfile <procitationFile>]"
    echo
    echo "Options:"
    echo "  --name                Name of the application. (required)"
    echo "  --bundleIdentifier    The iOS bundle identifier of the application. (required)"
    echo "  --provisioningProfile The name of the iOS provisioning profile to build the application. (optional, defaults to the value of --name)"
    echo "  --help                Display this help and exit."
}

# Initialize variables
appName=""
bundleIdentifier=""
provisioningProfile=""

# Parse named arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)
            appName="$2"
            shift # past argument
            shift # past value
            ;;
        --bundleIdentifier)
            bundleIdentifier="$2"
            shift # past argument
            shift # past value
            ;;
        --provisioningProfile)
            provisioningProfile="$2"
            shift # past argument
            shift # past value
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            error_exit_help "Unknown option: $1"
            ;;
    esac
done

# Check for required arguments
if [ -z "$appName" ]; then
    error_exit_help "The --name argument is required."
fi

if [ -z "$bundleIdentifier" ]; then
    error_exit_help "The --bundleIdentifier argument is required."
fi

# Set default value for provisioningProfile if not provided
if [ -z "$provisioningProfile" ]; then
    provisioningProfile="$appName"
fi

# Remove spaces from appName
appNameNoSpaces="${appName// /}"

# Convert appName to lowercase and remove spaces
appNameLowerNoSpaces=$(echo "$appName" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

# Testing the input:
echo "Application Name: $appName"
echo "Bundle Identifier: $bundleIdentifier"
echo "Provisioning Profile: $provisioningProfile"
echo "Application Name (No Spaces): $appNameNoSpaces"
echo "Application Name (Lowercase, No Spaces): $appNameLowerNoSpaces"

# Rename the bundle identifier:
oldBundleIdentifierEscaped=$(sed 's:/:\\/:g' <<< "edu.stanford.spezi.templateapplication")
bundleIdentifierEscaped=$(sed 's:/:\\/:g' <<< "$bundleIdentifier")

find . -type f -not \( -path '*/.git/*' \) -not \( -path '*/Scripts/create.sh' \) -exec grep -Iq . {} \; -print | while read -r file; do
    sed -i '' "s/${oldBundleIdentifierEscaped}/${bundleIdentifierEscaped}/g" "$file" || echo "Failed to process $file"
done


# Rename the provisioning profile:
oldProvisioningProfileEscaped=$(sed 's:/:\\/:g' <<< "\"Spezi Template Application\"")
provisioningProfileEscaped=$(sed 's:/:\\/:g' <<< "\"$provisioningProfile\"")

sed -i '' "s/${oldProvisioningProfileEscaped}/${provisioningProfileEscaped}/g" "./fastlane/Fastfile"
sed -i '' "s/${oldProvisioningProfileEscaped}/${provisioningProfileEscaped}/g" "./TemplateApplication.xcodeproj/project.pbxproj"


# Firebase project name:
firebaseProjectNameEscaped=$(sed 's:/:\\/:g' <<< "stanfordspezitemplateapp")
appNameLowerNoSpacesEscaped=$(sed 's:/:\\/:g' <<< "$appNameLowerNoSpaces")

sed -i '' "s/${firebaseProjectNameEscaped}/${appNameLowerNoSpacesEscaped}/g" ".firebaserc"
sed -i '' "s/${firebaseProjectNameEscaped}/${appNameLowerNoSpacesEscaped}/g" "./TemplateApplication/Supporting Files/GoogleService-Info.plist"


# Rename project and code:
projectNameLowercaseEscaped=$(sed 's:/:\\/:g' <<< "templateapplication")
headerFileEscaped=$(sed 's:/:\\/:g' <<< "Stanford Spezi Template Application open-source")
projectNameNoSpacesEscaped=$(sed 's:/:\\/:g' <<< "TemplateApplication")
projectNameSpeziEscaped=$(sed 's:/:\\/:g' <<< "Spezi Template Application")
projectNameEscaped=$(sed 's:/:\\/:g' <<< "Template Application")
templateEscaped=$(sed 's:/:\\/:g' <<< "Template")
sstaEscaped=$(sed 's:/:\\/:g' <<< "{{SSTA}}")
taEscaped=$(sed 's:/:\\/:g' <<< "{{TA}}")

sstaFullEscaped=$(sed 's:/:\\/:g' <<< "Stanford Spezi Template Application")
taFullEscaped=$(sed 's:/:\\/:g' <<< "TemplateApplication")
newHeaderFileEscaped=$(sed 's:/:\\/:g' <<< "$appName based on the $sstaEscaped")
appNameEscaped=$(sed 's:/:\\/:g' <<< "$appName")
appNameNoSpacesEscaped=$(sed 's:/:\\/:g' <<< "$appNameNoSpaces")

find . -type f -not \( -path '*/.git/*' \) -not \( -path '*/Scripts/create.sh' \) -exec grep -Iq . {} \; -print | while read -r file; do
    sed -i '' "s/${projectNameLowercaseEscaped}/${appNameLowerNoSpacesEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${headerFileEscaped}/${newHeaderFileEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${projectNameNoSpacesEscaped}/${appNameNoSpacesEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${projectNameSpeziEscaped}/${appNameEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${projectNameEscaped}/${appNameEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${templateEscaped}/${appNameNoSpacesEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${sstaEscaped}/${sstaFullEscaped}/g" "$file" || echo "Failed to process $file"
    sed -i '' "s/${taEscaped}/${taFullEscaped}/g" "$file" || echo "Failed to process $file"
done

# Remove the repo link and DOI from the citation file:
# Specify the file name
citationFile="CITATION.cff"
total_lines=$(wc -l < "$citationFile")
lines_to_keep=$((total_lines - 2))

# Check if the file has more than 3 lines
if [ "$lines_to_keep" -ge 1 ]; then
    # Output the first N lines to a temporary file
    head -n "$lines_to_keep" "$citationFile" > ".$citationFile"
    # Replace the original file with the temporary file
    mv ".$citationFile" "$citationFile"
else
    echo "$citationFile has less than 3 lines, nothing will be removed."
fi


# Rename files and directories
# Function to recursively rename directories
rename_directories() {
    base_dir=$1
    find "$base_dir" -depth -type d -name "*${projectNameNoSpacesEscaped}*" | while read -r dir; do
        new_dir=$(echo "$dir" | sed "s/${projectNameNoSpacesEscaped}/${appNameNoSpacesEscaped}/g")
        mv "$dir" "$new_dir"
        # Prevent reprocessing of already renamed directories
        rename_directories "$new_dir"
    done
}

# Rename directories
rename_directories "."

# Rename files
find . -type f -name "*${projectNameNoSpacesEscaped}*" | while read -r file; do
    new_file=$(echo "$file" | sed "s/${projectNameNoSpacesEscaped}/${appNameNoSpacesEscaped}/g")
    # Check if the new file path's directory exists before moving
    new_dir=$(dirname "$new_file")
    if [ -d "$new_dir" ]; then
        mv "$file" "$new_file"
    fi
done

# Remove the DocC documentation, Figures, and replace the README with a placeholder README
rm -rf "./${appNameNoSpacesEscaped}/Supporting Files/${appNameNoSpacesEscaped}.docc"
mv "./Scripts/TEMPLATEREADME.md" "./README.md"

linkCheckDisabledEscaped=$(sed 's:/:\\/:g' <<< "<!-- markdown-link-check-disable-line -->")
sed -i '' "s/${linkCheckDisabledEscaped}//g" "./README.md"


rm -rf "./Scripts"
rm -f "./.github/workflows/documentation-deployment.yml"

#!/bin/bash

<<info

This is a backup with rotation script
it will not store more than 3 backups
it will replace the oldest one with the latest

info
# Check if zip is installed
if [ ! command -v zip > /dev/null 2>&1 ]; then
    echo "Error: 'zip' command not found. Please install zip (e.g. sudo apt install zip)"
    exit 1
fi

# Check if directory argument is provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <source_directory>"
	exit 1
fi

# Variables
src="$1"
timestamp=$(date '+%F_%H-%M-%S')
backup_file="${src}/backups/backup_${timestamp}.zip"

# Check if source directory exists
if [ ! -d "$src" ]; then
	echo "Source directory doesn't exist"
	exit 1
fi

# Creating backup
echo "Creating backup: $backup_file"
mkdir -p "$src/backups/"
cd "$src" || exit 1

zip -r "$backup_file" . -x "backup_*.zip" > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "Error: Backup failed."
	exit 1
fi

# Rotation
ls backups/backup_*.zip 2> /dev/null | sort | head -n -3 | xargs -r rm -f 2> /dev/null

echo -e "Backup completed\n\nCurrent backups:"
ls backups/backup_*.zip 2> /dev/null 


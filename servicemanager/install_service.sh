#!/bin/bash

# Check if a file path is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <path/to/service-file.service>"
  exit 1
fi

# Get the provided file path
service_file_path="$1"

# Check if the file exists
if [ ! -f "$service_file_path" ]; then
  echo "Error: File not found: $service_file_path"
  exit 1
fi

# Define the directory where systemd service files are usually located
systemd_dir="/etc/systemd/system/"

# Extract the service file name from the provided path
service_file_name=$(basename "$service_file_path")

# Set the destination path for the systemd directory
destination_path="$systemd_dir$service_file_name"

# Copy the service file to the systemd directory
cp "$service_file_path" "$destination_path"

# Reload systemd to pick up the changes
systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting the service..."
systemctl enable "$service_file_name"
systemctl start "$service_file_name"

# Add the service name to the known_services.txt file
known_services_file="known_services.txt"
echo "$service_file_name" >> "$known_services_file"

echo "Service installation and activation completed."
exit 0

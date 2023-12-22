#!/bin/bash

# File containing a list of known services (one per line)
services_file="known_services.txt"

# Check if the services file exists
if [ ! -f "$services_file" ]; then
  echo "Error: Services file not found: $services_file"
  exit 1
fi

# Read the list of known services into an array
mapfile -t services < "$services_file"

# Check if there are no services in the file
if [ "${#services[@]}" -eq 0 ]; then
  echo "Error: No services found in the services file."
  exit 1
fi

# Display the list of known services to the user
echo "Known services:"
for ((i=0; i<${#services[@]}; i++)); do
  echo "$((i+1)). ${services[i]}"
done

# Prompt the user to choose a service
read -p "Enter the number of the service you want to use: " selected_index

# Validate user input
if ! [[ "$selected_index" =~ ^[1-${#services[@]}]$ ]]; then
  echo "Invalid input. Please enter a valid number."
  exit 1
fi

# Get the selected service name
selected_service="${services[selected_index-1]}"

# Prompt the user for action
read -p "Choose an action for $selected_service (restart/start/enable/disable/status): " action

# Perform the selected action
case "$action" in
  restart)
    sudo systemctl restart "$selected_service"
    ;;
  start)
    sudo systemctl start "$selected_service"
    ;;
  enable)
    sudo systemctl enable "$selected_service"
    ;;
  disable)
    sudo systemctl disable "$selected_service"
    ;;
  status)
    sudo systemctl status "$selected_service"
    ;;
  *)
    echo "Invalid action. Please choose restart, start, enable, disable, or status."
    exit 1
    ;;
esac

exit 0

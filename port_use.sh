#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Use netstat to get a list of listening ports
open_ports=$(netstat -tuln | grep 'LISTEN')

# Display the list of open ports, PIDs, and associated services with path
echo "Open ports, PIDs, and associated services with path:"
while read -r line; do
  port=$(echo "$line" | awk '{print $4}' | awk -F: '{print $NF}')
  pid=$(lsof -i :$port -sTCP:LISTEN -n -P | awk 'NR==2 {print $2}')
  service=$(lsof -i :$port -sTCP:LISTEN -n -P | awk 'NR==2 {print $1}')
  
  if [ -n "$pid" ] && [ -n "$service" ]; then
    # Use ps to get the path of the associated PID
    path=$(ps -p $pid -o command --no-headers)
    echo "Port: $port, PID: $pid, Service: $service, Path: $path"
  else
    echo "Port: $port, No associated PID or service found"
  fi
done <<< "$open_ports"


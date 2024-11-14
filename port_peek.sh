#!/bin/bash

# Port Peek - Advanced Port Scanner and Service Enumerator

# Check for root access
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "👀 Welcome to Port Peek - Advanced Port Scanner 👀"
echo "-------------------------------------------------"

# Prompt for target IP
read -p "Enter the target IP address: " target_ip
read -p "Enter the port range (e.g., 1-1024): " port_range

# Function to scan and identify services on open ports
function scan_ports() {
    echo -e "\n🔄 Scanning ports on $target_ip in the range $port_range..."
    for port in $(seq $(echo $port_range | cut -d '-' -f 1) $(echo $port_range | cut -d '-' -f 2)); do
        (echo > /dev/tcp/$target_ip/$port) >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            # Use Nmap if installed for more detailed service information
            if command -v nmap &> /dev/null; then
                service=$(sudo nmap -p $port --open -Pn --reason -sV -oG - $target_ip | grep "/open" | awk '{print $3, $4, $5}')
                echo "Port $port is open - $service"
            else
                echo "Port $port is open"
            fi
        fi
    done
    echo -e "\n🎉 Scan Completed!"
}

# Run the scan
scan_ports

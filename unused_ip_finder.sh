#!/bin/bash
# Coded by Ashkan Rafiee

# Define Nmap executable path
nmap_path="/home/linuxbrew/.linuxbrew/bin/nmap"

# Define Always alive host to ensure vpn connectivity
alive_host="192.168.1.1"

# Specify the ports you want to scan, you can also give multiple ports like ports="22,80,443"
ports="22"

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Check VPN connectivity by pinging the always alive internal IP
if ! ping -c 1 -W 2 "$alive_host" > /dev/null 2>&1; then
    echo "You are not connected to org VPN server. Please connect to the VPN first."
    exit 1
fi

# Check if Nmap path is valid
if [ ! -x "$nmap_path" ]; then
    echo "Nmap is not installed or the path is incorrect."
    exit 1
fi

# Prompt user for IP range
read -p "Enter IP range for scan (e.g., 192.168.1.0/24): " ip_range

# Temporary file for Nmap output
nmap_output=$(mktemp)

# File to store IPs with no open ports
no_open_ports_file="unused_ips.txt"

# Perform Nmap scan and show progress
echo "Starting Nmap scan on $ip_range for ports $ports..."
sudo $nmap_path -Pn -n -sS -p $ports --open -T4 $ip_range -oG $nmap_output

# Generate list of all IPs in the range
mapfile -t all_ips < <($nmap_path -sL -n $ip_range | grep 'Nmap scan report for' | cut -f 5 -d ' ')

# Extract IPs with open ports from the Nmap output file
mapfile -t open_ips < <(grep '/open/' $nmap_output | awk '{print $2}')

# Convert open IPs to a hash for efficient lookup
declare -A open_ips_hash
for ip in "${open_ips[@]}"; do
    open_ips_hash[$ip]=1
done

# Check each IP to see if it's in the list of open IPs, print if not, and write to file
echo "IPs with no open ports ($ports):"
> "$no_open_ports_file" # Clear or create the file before writing
for ip in "${all_ips[@]}"; do
    if [ -z "${open_ips_hash[$ip]}" ]; then
        echo "$ip"
        echo "$ip" >> "$no_open_ports_file"
    fi
done

echo "The list of IPs with no open ports has been saved to $no_open_ports_file"

# Clean up temporary file
rm $nmap_output

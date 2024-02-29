# Unused IP Finder Tool

## Description

This tool is designed for network administrators and IT professionals to identify unused IP addresses within the datacenter's local network. Utilizing Nmap for scanning specified IP ranges and checking for commonly enabled ports, it distinguishes IPs that are currently not in use. It includes a preliminary connectivity check to the network by pinging a known, always-available IP address, ensuring the user's network connectivity before initiating the scan.

## Prerequisites

- **Root Access**: The script requires root privileges to run.
- **Nmap Installed**: Nmap must be installed on the system and be accessible in the system's PATH.
- **VPN Connectivity**: If the target network is accessible only via VPN, a connection to the organization's VPN is required.

## Configuration

Before using the tool, configure the following variables within the script to suit your environment:

- **`nmap_path`**: Absolute path to the Nmap executable. The default is set to "/home/linuxbrew/.linuxbrew/bin/nmap".
- **`alive_host`**: An IP address that is always reachable on your network, used to confirm VPN connectivity. Set this to an appropriate IP address based on your network (e.g., `192.168.1.1`).
- **`ports`**: The ports you wish to scan on each IP. By default, port "22" (SSH) is specified. Adjust according to your needs.

## Usage

1. **Configure the Script**: Modify `nmap_path`, `alive_host`, and `ports` variables in the script to reflect your specific network setup.
   
2. **Execute the Script**: Run the script with sudo to ensure it has the necessary permissions:
`sudo ./unused_ip_finder.sh <IP range>`

3. **IP Range Format**: The script accepts various IP formats, such as:
- CIDR notation (e.g., `192.168.1.0/24`)
- A hyphenated range (e.g., `192.168.0-2.1/24`)
- A single IP address (e.g., `192.168.1.100`)

4. **Review the Output**: Upon completion, the script outputs IPs without open ports on the specified ports and saves this list to `unused_ips.txt`.

## Important Notes

- **VPN Verification**: The script checks your VPN connection by pinging the `alive_host`. If this fails, you'll be prompted to establish a VPN connection.
- **Legal and Ethical Use**: Only perform scans on networks where you have explicit permission. Unauthorized scanning may violate laws or organizational policies.

## License

This project is licensed under the Apache License 2.0. For more details, see the LICENSE file in the repository.

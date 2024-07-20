#!/bin/bash

# Define color codes for visual appeal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# Print header with color
print_header() {
    echo -e "${CYAN}**********************************${NC}"
    echo -e "${CYAN} Package Installation Date and Time ${NC}"
    echo -e "${CYAN}**********************************${NC}"
}

# Print usage information
print_usage() {
    echo -e "${YELLOW}Usage: $0 [-h]${NC}"
    echo "  -h    Show this help message"
}

# Check if help is requested
while getopts "h" opt; do
    case ${opt} in
        h )
            print_usage
            exit 0
            ;;
        \? )
            print_usage
            exit 1
            ;;
    esac
done

# Fetch package information and print in formatted output
fetch_and_print_package_info() {
    dpkg-query -W -f='${Package}\t${Version}\n' | while read pkg ver; do
        infofile="/var/lib/dpkg/info/$pkg.list"
        if [ -e "$infofile" ]; then
            install_datetime=$(stat -c %y "$infofile" 2>/dev/null)
            if [ $? -eq 0 ]; then
                printf "${GREEN}%-25s${NC} ${BLUE}%-20s${NC} ${CYAN}%s${NC}\n" "$install_datetime" "$pkg" "$ver"
            else
                echo -e "${RED}Error: Could not retrieve installation time for $pkg${NC}"
            fi
        else
            echo -e "${RED}Warning: Info file not found for $pkg${NC}"
        fi
    done | sort
}

# Main execution
main() {
    print_header
    fetch_and_print_package_info
}

# Execute the main function
main

#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

echo -e "${BLUE}Installing the dependencies...${NC}"
sudo apt-get install build-essential git dkms linux-headers-$(uname -r)

echo -e "\n${BLUE}Installing the driver...${NC}"
sudo dkms install ../rtl8188fu
mkdir -p /lib/firmware/rtlwifi
sudo cp ./rtl8188fu/firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/

echo -e "\n${BLUE}Configuring the driver...${NC}"
sudo mkdir -p /etc/modprobe.d/
sudo touch /etc/modprobe.d/rtl8188fu.conf
echo "options rtl8188fu rtw_power_mgnt=0 rtw_enusbss=0 rtw_ips_mode=0" | sudo tee /etc/modprobe.d/rtl8188fu.conf

sudo mkdir -p /etc/NetworkManager/conf.d/
sudo touch /etc/NetworkManager/conf.d/disable-random-mac.conf
echo "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf

echo 'alias usb:v0BDApF179d*dc*dsc*dp*icFFiscFFipFFin* rtl8188fu' | sudo tee /etc/modprobe.d/rtl8xxxu-blacklist.conf

echo -e "${BLUE}Activating the driver...${NC}"
sudo update-initramfs -u
sudo modprobe rtl8188fu


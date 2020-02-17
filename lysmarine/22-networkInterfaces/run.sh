#!/bin/bash -e

# Network manager
apt-get install -y -q network-manager make 

# Resolve lysmarine.local
apt-get install -y -q avahi-daemon 
echo -n 'lysmarine' > /etc/hostname
echo '127.0.1.1	lysmarine' >> /etc/hosts
echo '127.0.1.1	lysmarine.local' >> /etc/hosts

# Access Point
apt-get install -y -q git util-linux procps hostapd iproute2 iw dnsmasq iptables
git clone --depth=1 https://github.com/oblique/create_ap
pushd create_ap
make install
popd

cp $FILE_FOLDER/create_ap.conf /etc/
rm -rf create_ap

# As network manager provide it's own wpa_supplicant, stop the others.  
systemctl disable dhcpcd.service
systemctl disable wpa_supplicant.service
systemctl disable hostapd.service

systemctl disable NetworkManager-wait-online.service # if we do not boot remote user it's not needed
systemctl disable ModemManager.service # for 2G/3G/4G
systemctl disable pppd-dns.service # For dial-up Internet LOL
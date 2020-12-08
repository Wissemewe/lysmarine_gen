#!/bin/bash -e

apt-get clean

apt-get -y -q install nodejs libnss3 gnome-icon-theme unzip
npm install nativefier -g --unsafe-perm

## Install icons and .desktop files
install -d -o 1000 -g 1000 /home/user/.local/share/icons
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/freeboard-sk.png /home/user/.local/share/icons/
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/signalk.png /home/user/.local/share/icons/
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/dockwa.png /home/user/.local/share/icons/
install -d /usr/local/share/applications
install -v $FILE_FOLDER/signalk.desktop /usr/local/share/applications/

## arch name translation
if [ $LMARCH == 'armhf' ]; then
  arch=armv7l
elif [ $LMARCH == 'arm64' ]; then
  arch=arm64
elif [ $LMARCH == 'amd64' ]; then
  arch=x64
else
  arch=$LMARCH
fi

USER_AGENT="Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.86 Mobile Safari/537.36"

########################################################################################################################

echo "setTheme('dark')" >./pypilot_darktheme.js
nativefier -a $arch --inject ./pypilot_darktheme.js --disable-context-menu --disable-dev-tools --single-instance \
  --name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  "http://localhost:8080" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "AvNav" --icon /usr/share/icons/gnome/48x48/categories/gnome-globe.png \
  "http://localhost:8099/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "wdash" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "bbn-launcher" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
  "http://localhost:4997" /opt/

## Make folder name arch independent.
mv /opt/Pypilot_webapp-linux-$arch /opt/Pypilot_webapp
mv /opt/AvNav-linux-$arch /opt/AvNav
mv /opt/wdash-linux-$arch /opt/wdash
mv /opt/bbn-launcher-linux-$arch /opt/bbn-launcher

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/Pypilot_webapp/chrome-sandbox
  chmod 4755 /opt/AvNav/chrome-sandbox
  chmod 4755 /opt/wdash/chrome-sandbox
  chmod 4755 /opt/bbn-launcher/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -f -t /opt/*
npm cache clean --force

########################################################################################################################


nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "SignalK" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/admin/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "Freeboard-sk" --icon /home/user/.local/share/icons/freeboard-sk.png \
  "http://localhost:80/@signalk/freeboard-sk/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "kip-dash" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@mxtommy/kip/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "instrumentpanel" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@signalk/instrumentpanel/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "sailgauge" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@signalk/sailgauge/" /opt/

## Make folder name arch independent.
mv /opt/SignalK-linux-$arch /opt/SignalK
mv /opt/Freeboard-sk-linux-$arch /opt/Freeboard-sk
mv /opt/kip-dash-linux-$arch /opt/kip-dash
mv /opt/instrumentpanel-linux-$arch /opt/instrumentpanel
mv /opt/sailgauge-linux-$arch /opt/sailgauge

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/SignalK/chrome-sandbox
  chmod 4755 /opt/Freeboard-sk/chrome-sandbox
  chmod 4755 /opt/kip-dash/chrome-sandbox
  chmod 4755 /opt/instrumentpanel/chrome-sandbox
  chmod 4755 /opt/sailgauge/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -f -t /opt/*
npm cache clean --force

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "MusicBox" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  "http://localhost:6680/musicbox_webclient" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "Dockwa" --icon /home/user/.local/share/icons/dockwa.png \
  "https://dockwa.com/" -u "$USER_AGENT" /opt/

mv /opt/MusicBox-linux-$arch /opt/MusicBox
mv /opt/Dockwa-linux-$arch /opt/Dockwa

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/MusicBox/chrome-sandbox
  chmod 4755 /opt/Dockwa/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -f -t /opt/*
npm cache clean --force

install -m 644 $FILE_FOLDER/dockwa.desktop "/usr/local/share/applications/"

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "youtube" --icon /usr/share/icons/gnome/48x48/categories/gnome-globe.png \
  "https://youtube.com/" -u "$USER_AGENT" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "facebook" --icon /usr/share/icons/gnome/48x48/categories/gnome-globe.png \
  "https://facebook.com/" -u "$USER_AGENT" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "spotify" --icon /usr/share/icons/gnome/48x48/categories/gnome-globe.png \
  "https://open.spotify.com/" -u "$USER_AGENT" /opt/

mv /opt/youtube-linux-$arch /opt/youtube
mv /opt/facebook-linux-$arch /opt/facebook
mv /opt/spotify-linux-$arch /opt/spotify

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/youtube/chrome-sandbox
  chmod 4755 /opt/facebook/chrome-sandbox
  chmod 4755 /opt/spotify/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -f -t /opt/*
npm cache clean --force

########################################################################################################################

apt-get clean

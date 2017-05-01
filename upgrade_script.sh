#!/bin/bash
echo 'Escalating privileges... You have to trust me here ;)'
#sudo su

echo 'Checking GHOST status'
service ghost status

echo 'Changing directories'
mkdir /var/www/ghost/temp
cd /var/www/ghost/temp

echo 'Cleaning Temp folder'
rm -R *

echo 'Downloading ghost-latest'
wget http://ghost.org/zip/ghost-latest.zip

echo 'Decompresing .zip file (verbosed)'
unzip ghost-latest.zip && cd ..

echo '!! STOPPING GHOST SERVICE ... you have 5sec. to abort before continuing!!'
pause 5
service ghost stop

echo 'Now is where the Magick happens (replacing files)'
echo 'Backup...'
cd content/data/
cp ghost.db ghost.$(date +"%Y%m%d_%H%M%S")

echo 'copy new files...'
cd ../..
yes | cp temp/*.md temp/*.js temp/*.json .
rm -R core
yes | cp -R temp/core .
yes | cp -R temp/content/themes/casper content/themes

echo 'You better see no crash/ERR here...'
npm install --production
pause 5

echo 'giving back permissions'
chown -R ghost:ghost ./

echo 'Starting services & checking status'
service ghost start
nginx -t

echo 'removing -temp- folder'
rm -R temp

echo '>> ALL DONE, you good to go... <<'

#!/bin/sh

mac_osversion=`sw_vers -productVersion | cut -d "." -f1,2`
mac_osversion="10.11"
puppet_agent_version="1.3.2-1"

puppet_agent="puppet-agent-${puppet_agent_version}.osx${mac_osversion}"
puppet_installer="puppet-agent-${puppet_agent_version}-installer.pkg"
download_url="https://downloads.puppetlabs.com/mac/${mac_osversion}/PC1/x86_64/${puppet_agent}.dmg"
tmp_dmg="/tmp/puppet-agent-tmp.dmg"

if [ -f $tmp_dmg ]
then
  rm -f $tmp_dmg
fi

curl -o $tmp_dmg $download_url

if [ $? -ne 0 ]
then
  echo "Something wrong while download the dmg file, please take a look manually!!!"
  exit 1
fi

hdiutil mount $tmp_dmg
installer -pkg /Volumes/${puppet_agent}/${puppet_installer} -target /

if [ $? -ne 0 ]
then
  echo "puppet agent install is not successful, and please take a look manually!!!"
  exit 1
fi

hdiutil unmount /Volumes/${puppet_agent}

echo "Done"

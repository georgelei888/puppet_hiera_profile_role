#!/bin/sh

packages="puppet-3.8.7 hiera-1.3.4 facter-2.4.6"

function run_install
{
  package=$1
  installer="${package}.pkg"
  download_url="https://downloads.puppetlabs.com/mac/${package}.dmg"

  echo "Working on $package"
  echo "--------------------------------------------------------------------------"

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
  installer -pkg /Volumes/${package}/${installer} -target /

  if [ $? -ne 0 ]
  then
    echo "puppet agent install is not successful, and please take a look manually!!!"
    exit 1
  fi
  hdiutil unmount /Volumes/${package}

  echo "Done"
  echo 
}

for p in $packages
do
  run_install $p
done

echo "Add puppet.conf"
mkdir /etc/puppet
cat << EOF > /etc/puppet/puppet.conf
[main]
    # The Puppet log directory.
    # The default value is '\$vardir/log'.
    logdir = /var/log/puppet

    # Where Puppet PID files are kept.
    # The default value is '\$vardir/run'.
    rundir = /var/run/puppet

    # Where SSL certificates are kept.
    # The default value is '\$confdir/ssl'.
    ssldir = \$vardir/ssl
    # certificate_revocation = false

[agent]
    # The file in which puppetd stores a list of the classes
    # associated with the retrieved configuratiion.  Can be loaded in
    # the separate ``puppet`` executable using the ``--loadclasses``
    # option.
    # The default value is '\$confdir/classes.txt'.
    classfile = \$vardir/classes.txt

    # Where puppetd caches the local configuration.  An
    # extension indicating the cache format is added automatically.
    # The default value is '$confdir/localconfig'.
    localconfig = \$vardir/localconfig

    server = puppet
    report = true
    pluginsync = true
    environment = staging
EOF

echo "Done"

#!/bin/sh
#Set Paths
PATH=$PATH:/usr/local/bin:/share/Apps/local/bin:/share/Apps/local/libexec/git-core:/nmt/apps/bin;export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/bin:/share/Apps/local/lib;export LD_LIBRARY_PATH
MANPATH=$MANPATH:/usr/local/share/man:/share/Apps/local/share/man;export MANPATH

install()
{
# Check opkg installation
 if [ -d /share/Apps/local ]; then
   echo "Required dependency, opkg (local) is installed."
   else
   echo "Required dependency, opkg (local) is not installed, install it via C.S.I" 
   rm -r /share/Apps/CouchpotatoV2
   exit 0
 fi
 
# Update opkg installation
 if [ -f /share/Apps/local/lib/opkg/lists/c200local ]; then
   echo "opkg (local) has been updated but cant tell when last this was, new versions may still be available."
   else
   echo "Updating opkg (local)" 
   opkg update
 fi

 # install python2.7-dev
 if [ -f /share/Apps/local/bin/python2.7-config ]; then
   echo "Required dependency, python-2.7-Dev is installed."
   else
   opkg install python2.7-dev -force-depends -force-overwrite
 fi

 # install git
 if [ -f "/share/Apps/local/bin/git" ] ; then
   echo "Required dependency, git is installed."
   else
   opkg install git -force-depends -force-overwrite
 fi
 
# install g++-4.4
 if [ -f /share/Apps/local/bin/g++ ]; then
   echo "Required dependency, g++-4.4 is installed."
   else
   opkg install g++-4.4 -force-depends -force-overwrite
 fi

# install gcc-4.4
 if [ -f /share/Apps/local/bin/gcc ]; then
   echo "Required dependency, gcc-4.4 is installed."
   else
   opkg install gcc-4.4 -force-depends -force-overwrite
 fi

# install expat
 if [ -f /share/Apps/local/lib/python2.7/xml/parsers/expat.py ] ; then
   echo "Required dependency, expat is installed."
   else
   opkg install expat -force-depends -force-overwrite
 fi

# install coreutils
# if [ -f /share/Apps/local/share/info/coreutils.info ] ; then
#   echo "Required dependency, coreutils is installed."
#   else
#   opkg install coreutils -force-depends -force-overwrite
# fi
 
# make settings folder
 if [ -d /share/Apps/CP_Settings ]; then
 echo "No need to make settings folder"
 else
 mkdir  /share/Apps/CP_Settings
 if [ -f /share/Apps/CouchpotatoV2/settings.conf ] ; then
 echo "Copying users settings"
 mv /share/Apps/CouchpotatoV2/settings.conf /share/Apps/CP_Settings/settings.conf
 rm /share/Apps/CouchpotatoV2/default.settings.conf
 sed -i 's/CouchpotatoV2/CP_Settings/g' /share/Apps/CP_Settings/settings.conf
 mv /share/Apps/CouchpotatoV2/couchpotato.db /share/Apps/CP_Settings/couchpotato.db
 mv /share/Apps/CouchpotatoV2/cache /share/Apps/CP_Settings/cache
 mv /share/Apps/CouchpotatoV2/db_backup /share/Apps/CP_Settings/db_backup
 mv /share/Apps/CouchpotatoV2/logs /share/Apps/CP_Settings/logs 
 else
 echo "Copying default settings"
 mv /share/Apps/CouchpotatoV2/default.settings.conf /share/Apps/CP_Settings/settings.conf
 fi
 fi
 
# install CouchPotatoServer
 if [ -f /share/Apps/CouchpotatoV2/CouchPotato.py ] ; then     
   echo "couchpotato2 is installed"
   else
   chmod -R 777 /share/Apps/CouchpotatoV2
   mkdir /share/tmp
   cd /share/tmp
   git clone git://github.com/RuudBurger/CouchPotatoServer.git CP
   cp -Ra CP/. /share/Apps/CouchpotatoV2
   chmod -R 777 /share/Apps/CouchpotatoV2
   chmod -R 777 /share/Apps/CP_Settings
   cd
   rm -r /share/tmp
 fi
}

uninstall()
{
    if [ -d /share/Apps/CP_Settings ]; then
        rm -R /share/Apps/CP_Settings
    fi
}


case "$1" in
    install)
    install
    ;;
    
    uninstall)
    uninstall
    ;;
esac
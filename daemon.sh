#!/bin/sh
#Set Paths
PATH=$PATH:/usr/local/bin:/share/Apps/local/bin:/share/Apps/local/libexec/git-core:/nmt/apps/bin;export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/bin:/share/Apps/local/lib;export LD_LIBRARY_PATH
MANPATH=$MANPATH:/usr/local/share/man:/share/Apps/local/share/man;export MANPATH

# Package
PACKAGE="CouchpotatoV2"
DNAME="CouchpotatoV2"

# Others
INSTALL_DIR="/share/Apps/${PACKAGE}"
PYTHON_DIR="/share/Apps/local/bin"
RUNAS="root"
PYTHON="${PYTHON_DIR}/python2.7"
COUCHPOTATO="${INSTALL_DIR}/CouchPotato.py"
CFG_FILE="/share/Apps/CP_Settings/settings.conf"
PID_FILE="/share/Apps/CP_Settings/couchpotato.pid"
LOG_FILE="/share/Apps/CP_Settings/CouchPotato.log"

force_couchpotato()
{
   chmod -R 777 /share/Apps/CouchpotatoV2
   mkdir /share/tmp
   cd /share/tmp
   git clone git://github.com/RuudBurger/CouchPotatoServer.git CP
   cp -Ra CP/. /share/Apps/CouchpotatoV2
   chmod -R 777 /share/Apps/CouchpotatoV2
   cd
   rm -r /share/tmp
}

force_all()
{
opkg update
opkg install python2.7-dev -force-depends -force-overwrite
opkg install git -force-depends -force-overwrite
opkg install g++-4.4 -force-depends -force-overwrite
opkg install gcc-4.4 -force-depends -force-overwrite
opkg install expat -force-depends -force-overwrite
}

start_daemon()
{
# start CouchPotatoServer 
${PYTHON} ${COUCHPOTATO} --daemon --pid_file ${PID_FILE} --config ${CFG_FILE}

}

daemon_status()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
return 0
    fi
return 1
}

wait_for_status()
{
    counter=$2
    while [ ${counter} <> 0 ]; do
daemon_status
        [ $? -eq $1 ] && break
let counter=counter-1
        sleep 1
    done
}

stop_daemon()
{
# Stop couchpotato

    kill `cat ${PID_FILE}`
    wait_for_status 1 20
    rm -f ${PID_FILE}
}

#Main
case $1 in
    start)
        if daemon_status; then
echo ${DNAME} is already running
        else
echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status; then
echo Stopping ${DNAME} ...
            stop_daemon
        else
echo ${DNAME} is not running
        fi
        ;;
    status)
        if daemon_status; then
echo ${DNAME} is running
            exit 0
        else
echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac


#!/bin/bash
#:
#: libsv.sh  [ valande@gmail.com ]
#:

enable_service()
{
    systemctl enable ${1} --now
}
enable_services()
{
    for serv in $@; do
        enable_service ${serv}
    done
}


start_service()
{
    systemctl start ${1}
}
start_services()
{
    for serv in $@; do
        start_service ${serv}
    done
}


restart_service()
{
    systemctl restart ${1}
}
restart_services()
{
    for serv in $@; do
        restart_service ${serv}
    done
}


check_service()
{
    systemctl status ${1}
}
check_services()
{
    for serv in $@; do
        check_service ${serv}
    done
}


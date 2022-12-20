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

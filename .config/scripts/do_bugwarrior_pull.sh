#! /bin/bash
################################################################################
# do_bugwarrior_pull.sh - Perform the 'bugwarrior-pull' command
# See https://bugwarrior.readthedocs.io
# Time-stamp: <Wed 2017-11-22 14:58 svarrette>
#
# Copyright (c) 2017 Sebastien Varrette <Sebastien.Varrette@uni.lu>
################################################################################

LOCKFILE=$HOME/.config/task/bugwarrior.lockfile

if [ -f "${LOCKFILE}" ]; then
    # test if the file is present for at least ${ALLOWED_WAITING_TIME} hour(s)
    ALLOWED_WAITING_TIME=2
    tmptest=$(find . -mmin +$((60*${ALLOWED_WAITING_TIME})) | grep ${LOCKFILE})
    if [ $? -eq 0 ]; then
        echo "/!\ WARNING: deleting old (obsolete?) lock file '${LOCKFILE}'"
        rm -f ${LOCKFILE}
    fi
fi
if [ -n "$(which bugwarrior-pull)" ]; then
    bugwarrior-pull
fi

#! /bin/bash
################################################################################
# do_bugwarrior_pull.sh - Perform the 'bugwarrior-pull' command
# See https://bugwarrior.readthedocs.io
# Time-stamp: <Wed 2017-11-22 14:58 svarrette>
#
# Copyright (c) 2017 Sebastien Varrette <Sebastien.Varrette@uni.lu>
################################################################################

# Added to cronjob as:
# */15 * * * * $HOME/.config/scripts/cronic $HOME/.config/scripts/do_bugwarrior_pull.sh
# make sure everything in scripts folder is executable
# actually added the > dev/null 2>&1 because mail was still being added even if no errors


if [ -z ${XDG_DATA_HOME+x} ]; then 
  # running from CRON likely means this isn't set
  # # this also includes the homebrew paths
  . $HOME/.zprofile
  # bugwarrior is a pipx so make sure that's available as well
  . $XDG_CONFIG_HOME/shell/vars.sh
fi

LOCKFILE=$XDG_DATA_HOME/task/bugwarrior.lockfile
RUN_BUGWARRIOR=0

if [ -f "${LOCKFILE}" ]; then
    # test if the file is present for at least ${ALLOWED_WAITING_TIME} hour(s)
    echo "Found lockfile: $LOCKFILE..."
    ALLOWED_WAITING_TIME=2
    tmptest=$(find $LOCKFILE -mmin +$((60*${ALLOWED_WAITING_TIME}))) 
    if [ $? -eq 0 ]; then
        echo "/!\ WARNING: deleting old (obsolete?) lock file '${LOCKFILE}'"
        rm -f ${LOCKFILE}
        RUN_BUGWARRIOR=1
    else
      echo "$LOCKFILE not old enough to be deleted"
    fi
else
  RUN_BUGWARRIOR=1
fi

if [ "$RUN_BUGWARRIOR" -eq "1" ]; then
  if [ -n "$(which bugwarrior)" ]; then
      bugwarrior pull
    else
      echo "bugwarrior not found in PATH:$PATH"
  fi

fi


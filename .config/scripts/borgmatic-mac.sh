#!/bin/zsh
export PATH=$PATH:/opt/homebrew/bin
export server=drukernasnyc
echo '==================='
whoami
date
# su - vitalydruke
if /usr/bin/nc -z $server 22 2>/dev/null; then
  # test if authentication successful
  ssh -i /Users/vitalydruker/.ssh/id_rsa  borg@drukernasnyc borg --version
  retVal=$?
  if [ $retVal -eq 0 ]; then
    echo "$server ✓"
    borgmatic  -c $HOME/.config/borgmatic/config-macos.yaml  --verbosity 1 --list --stats 
  else
    echo "$server ✓, but authentication failed"
  fi
else
  echo "$server ✗"
fi


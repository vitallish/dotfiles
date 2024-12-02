#! /bin/zsh
timewstatus=$(timew get dom.active)

if [ "$timewstatus" -eq "1" ]; then
  timew get dom.active.duration;
else 
  echo NR
fi


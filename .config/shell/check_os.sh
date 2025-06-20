#!/bin/bash

# Usage: source check_os.sh [--verbose]

SHOW_OUTPUT=0

# Check for --verbose flag
for arg in "$@"; do
  if [[ "$arg" == "--verbose" ]]; then
    SHOW_OUTPUT=1
  fi
done

# OS Detection
UNAME_STR=$(uname)
if [[ "$UNAME_STR" == "Darwin" ]]; then
  VAKD_COMP_OS="Mac"
elif [[ "$UNAME_STR" == "Linux" ]]; then
  if [[ -f /etc/os-release ]]; then
    OS_ID=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
    VAKD_COMP_OS="Linux-$OS_ID"
  else
    VAKD_COMP_OS="Linux-Unknown"
  fi
else
  VAKD_COMP_OS="Unknown"
fi

# Owner Detection
HOSTNAME_VAL=$(hostname)
if [[ "$HOSTNAME_VAL" == usc622* ]]; then
  VAKD_COMP_OWNER="AZ"
else
  VAKD_COMP_OWNER="V"
fi

export VAKD_COMP_OS
export VAKD_COMP_OWNER

# Output, only if --verbose
if [[ "$SHOW_OUTPUT" -eq 1 ]]; then
  echo "VAKD_COMP_OS: $VAKD_COMP_OS"
  echo "VAKD_COMP_OWNER: $VAKD_COMP_OWNER"
fi


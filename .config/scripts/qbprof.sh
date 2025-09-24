#!/bin/sh

set -- "${@}" --basedir ~/.qutebrowser/vial2
set -- "${@}" --set 'window.title_format' '{perc}{current_title}{title_sep}VIAL'

# Bug opens a blank file with details above:
# https://github.com/qutebrowser/qutebrowser/issues/3719

qutebrowser "${@}" &
disown -h


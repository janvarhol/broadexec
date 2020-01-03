#!/bin/bash

# This file is part of Broadexec.
#
# Broadexec is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Broadexec is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Broadexec.  If not, see <https://www.gnu.org/licenses/>.

### This is example for embeded scripts to provide info once before broadexec initialization
### to build custom parameters line to be used with this script

### Section between ###BRDEXEC_EMBEDED START and ###BRDEXEC_EMBEDED STOP will be run just once
### and on hosts it will be ignored/removed before remote run
### Both sections must be at start of the line

### BRDEXEC_EMBEDED_PARAMETERS variable is used for script run
### BRDEXEC_EMBEDED_ERROR should be set to true if script conditions for valid
### parameters are not fulfilled. If set to true, execution of broadexec will stop at once

### IMPORTANT: dont use any code before ###BRDEXEC_EMBEDED clauses, because before script run, 
### everything apart from first line declaring shell will be removed and only lines after 
### ###BRDEXEC_EMBEDED STOP will be executed


###BRDEXEC_EMBEDED START

echo "Enter username to be checked:"
read USERNAME
if [ ! -z "${USERNAME}" ]; then
  BRDEXEC_EMBEDED_PARAMETERS=" -u ${USERNAME}"
else
  BRDEXEC_EMBEDED_ERROR=true
fi

###BRDEXEC_EMBEDED STOP

if [ "$(echo "$@" | wc -w)" -eq 2 ]; then
  if [ "$1" = "-u" ]; then
    id $2
  else
    echo "Wrong parameter used"
    exit 1
  fi
else
  echo "Wrong number of parameters used"
  exit 1
fi

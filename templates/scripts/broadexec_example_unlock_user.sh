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

### Example script for user unlock to show broadexec questions integration

### Following question is in variable format so it will not cause issues during run
### "BRDEXEC_SCRIPT_QUESTION_" is mandatory part for broadexec to recognize 
### there are special script inputs

### Next paramateres could be r, o or b
### r = question is required and without answer, script will not be run
### o = question is optional and answer to it can be skipped by pressing ENTER
### b = used for situation for parameters without options

### Next question parameter is parameter name forwarded to this script when it is run
### In this case, after answering to the question by entering "admin" script will be run as
### ./broadexec_example_unlock_user.sh -u admin

### Warning broadexec questions should be at the start of line, one per line, and it does not matter
### where in the script

BRDEXEC_SCRIPT_QUESTION_r_u="Enter user name to be unlocked:"

### simply checking values from parameters provided by broadexec
if [ "${#}" -ne 2 ] || [ "${1}" != "-u" ] || [ "$(echo "${2}" | wc -w)" -ne 1 ]; then
  echo "Wrong input!"
  exit 1
fi

### get username to nice variable
USERNAME="${2}"

### check if user exists on system
id ${USERNAME} >/dev/null 2>&1
if [ "${?}" -ne 0 ]; then
  echo "User does not exist"
  exit 2
fi

### check and fix disabled password
if [ "$(grep ^${USERNAME} /etc/shadow | head -n 1 | awk -F ":" '{print $2}')" = "!" ]; then
  passwd -u ${USERNAME}
fi

### check and fix disabled shell
if [ "$(grep ^${USERNAME} /etc/passwd | head -n 1 | awk -F ":" '{print $7}')" != "/bin/bash" ]; then
  usermod -s /bin/bash ${USERNAME}
fi

### final checks
if [ "$(grep ^${USERNAME} /etc/shadow | head -n 1 | awk -F ":" '{print $2}')" != "!" ] && [ "$(grep ^${USERNAME} /etc/passwd | head -n 1 | awk -F ":" '{print $7}')" = "/bin/bash" ]; then
  echo "User ${USERNAME} is OK."
else
  echo "Unable to fix user ${USERNAME}"
fi

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

### this is library for implementing stats functionality of broadexec into custom scripts

### First parameter of run function has to be working path to broadexec

### main call for broadexec with parameters
stats_run () {

  ### settings
  STATS_TIMEOUT=0.2

  ### store all the parameters for broadexec
  STATS_PARAMETERS="${@}"

  ### run requested broadexec with external parameter while storing important info about it
  STATS_BROADEXEC_INFO="$(mktemp)"
  echo "./broadexec.sh ${STATS_PARAMETERS} --external > ${STATS_BROADEXEC_INFO}" | bash

  ### wait for initiation of broadexec
  STATS_BROADEXEC_INIT_TIMEOUT=10
  STATS_BROADEXEC_INIT_TIME=0
  while [ "$(cat ${STATS_BROADEXEC_INFO} | wc -l)" -eq 0 ] && [ "${STATS_BROADEXEC_INIT_TIME}" -lt "${STATS_BROADEXEC_INIT_TIMEOUT}" ]; do
    ((STATS_BROADEXEC_INIT_TIME+=1))
    sleep 1
  done

  ### in case initialization fails
  if [ "${STATS_BROADEXEC_INIT_TIME}" -eq "${STATS_BROADEXEC_INIT_TIMEOUT}" ] || [ "$(cat ${STATS_BROADEXEC_INFO} | wc -l)" -eq 0 ]; then
    echo "ERROR: Unable to initialize broadexec. Check paths manually."
    exit 1
  fi

  ### get stats file
  if [ ! -f "$(head -n 1 ${STATS_BROADEXEC_INFO})" ]; then
    echo "ERROR: Unable to get broadexec stats file."
    exit 1
  else
    STATS_FILE="$(head -n 1 ${STATS_BROADEXEC_INFO})"
  fi

  ### display stats
  while [ "$(head -n 1 ${STATS_FILE} | grep ^STATE | awk '{print $2}')" != "FINISHED" ] && [ "$(head -n 1 ${STATS_FILE} | grep ^STATE | awk '{print $2}')" != "ERROR" ] && [ "$(head -n 1 ${STATS_FILE} | grep ^STATE | awk '{print $2}')" != "INTERRUPTED" ]; do
    stats_display_line
    sleep ${STATS_TIMEOUT} 2>/dev/null || sleep 1
  done

  echo "./broadexec.sh ${STATS_PARAMETERS} EXITED AS: $(head -n 1 ${STATS_FILE} | grep ^STATE | awk '{print $2}')                             "

  ### cleanup
  rm ${STATS_BROADEXEC_INFO}
}

### display progress
stats_display_line () {

  ### get state for display of initialization
  STATS_CURRENT_STATE="$(head -n 1 ${STATS_FILE} | grep ^STATE | awk '{print $2}')"

  ### set spinner
  if [ "${STATS_SPINNER}" = "" 2>/dev/null ]; then
    STATS_SPINNER="|"
  fi
  if [ -z "${STATS_SPINNER_TIME}" ]; then
    STATS_SPINNER_TIME="$(date +%s)"
  fi
  STATS_SPINNER_TIME_OLD="${STATS_SPINNER_TIME}"
  STATS_SPINNER_TIME="$(date +%s)"
  if [ "${STATS_SPINNER_TIME}" -ne "${STATS_SPINNER_TIME_OLD}" ]; then
    if [ "${STATS_SPINNER}" = "|" ]; then
      STATS_SPINNER="/"
    elif [ "${STATS_SPINNER}" = "/" ]; then
      STATS_SPINNER="-"
    elif [ "${STATS_SPINNER}" = "-" ]; then
      STATS_SPINNER="\\"
    else
      STATS_SPINNER="|"
    fi
  fi
  

  ### get percentage progress for progress bar
  STATS_CURRENT_PERCENTAGE_OLD="${STATS_CURRENT_PERCENTAGE}"
  STATS_CURRENT_PERCENTAGE="$(cat ${STATS_FILE} | grep ^PROGRESS | awk '{print $4}')"
  if [ "${STATS_CURRENT_PERCENTAGE}" = "NULL" 2>/dev/null ];then
    STATS_CURRENT_PERCENTAGE=" ${STATS_SPINNER} initializing ..."
  fi
  if [ "${STATS_CURRENT_PERCENTAGE}" = "" 2>/dev/null ]; then
    STATS_CURRENT_PERCENTAGE="${STATS_CURRENT_PERCENTAGE_OLD}"
  fi

  ### get info about number of processed hosts
  STATS_CURRENT_HOST_OLD="${STATS_CURRENT_HOST}"
  STATS_CURRENT_HOST="$(cat ${STATS_FILE} | grep ^PROGRESS | awk '{print $2}')"
  if [ "${STATS_CURRENT_HOST}" = "" 2>/dev/null ]; then
    STATS_CURRENT_HOST="${STATS_CURRENT_HOST_OLD}"
  fi
  STATS_TOTAL_HOSTS_OLD="${STATS_TOTAL_HOSTS}"
  STATS_TOTAL_HOSTS="$(cat ${STATS_FILE} | grep ^PROGRESS | awk '{print $3}')"
  if [ "${STATS_TOTAL_HOSTS}" = "" 2>/dev/null ]; then
    STATS_TOTAL_HOSTS="${STATS_TOTAL_HOSTS_OLD}"
  fi

  ### display easy
  #if [ "${STATS_CURRENT_PERCENTAGE}" -eq "${STATS_CURRENT_PERCENTAGE}" 2>/dev/null ]; then
  #  echo -ne "Running ./broadexec.sh ${STATS_PARAMETERS}: ${STATS_CURRENT_PERCENTAGE}%               "'\r'
  #else
  #  echo -ne "Running ./broadexec.sh ${STATS_PARAMETERS}: ${STATS_CURRENT_PERCENTAGE}               "'\r'
  #fi

  ### display progress bar
  if [ "${STATS_CURRENT_PERCENTAGE}" -eq "${STATS_CURRENT_PERCENTAGE}" 2>/dev/null ]; then
    
    ### reset progress bar
    STATS_CURRENT_PROGRESS_BAR=""
    
    ### progress bar is 50 charaters long so will half the percentage
    STATS_CURRENT_PERCENTAGE_PROGRESS="$(echo "${STATS_CURRENT_PERCENTAGE} / 2" | bc)"
    ### fill progress with chars
    while [ "$(echo "${STATS_CURRENT_PROGRESS_BAR}" | wc -c)" -lt "${STATS_CURRENT_PERCENTAGE_PROGRESS}" ]; do
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}#"
    done
    ### fill the rest with white space
    while [ "$(echo "${STATS_CURRENT_PROGRESS_BAR}" | wc -c)" -lt 50 ]; do
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR} "
    done

    ### display progress bar
    STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}# ${STATS_SPINNER} "
    if [ "${STATS_CURRENT_PERCENTAGE}" -lt 10 ]; then
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}  "
    elif [ "${STATS_CURRENT_PERCENTAGE}" -lt 100 ]; then
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR} "
    fi
    STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}${STATS_CURRENT_PERCENTAGE}% "
    if [ "${STATS_CURRENT_HOST}" -lt 10 ]; then
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}   (${STATS_CURRENT_HOST}"
    elif [ "${STATS_CURRENT_HOST}" -lt 100 ]; then
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}  (${STATS_CURRENT_HOST}"
    elif [ "${STATS_CURRENT_HOST}" -lt 1000 ]; then
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR} (${STATS_CURRENT_HOST}"
    else
      STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR}(${STATS_CURRENT_HOST}"
    fi
    STATS_CURRENT_PROGRESS_BAR="${STATS_CURRENT_PROGRESS_BAR} of ${STATS_TOTAL_HOSTS})"
    echo -ne "${STATS_CURRENT_PROGRESS_BAR}                    \r"
  else
    ### init display while broadexec is not started
    echo -ne "                                                 # ${STATS_SPINNER} initializing                    \r"
  fi
}

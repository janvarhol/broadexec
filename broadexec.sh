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

### beta version of broadexec script
### also see manpage in man folder
### to view available parameters run broadexec -h
### if run without parameters it will provide menu of available scripts and hostlists with limited basic functionality

BRDEXEC_VERSION="0.9.0"

### manage paths and links
BRDEXEC_WORKING_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BRDEXEC_WORKING_DIRECTORY}"
if [ "${?}" -ne 0 ]; then
  >&2 echo "There was problem changing directory to ${BRDEXEC_WORKING_DIRECTORY}. Check and repair it manually."
  exit 1
fi

### connect config file
if [ "$(md5sum ./etc/config_file_valid_entries.db 2>/dev/null | awk '{print $1}')" = "51bf4e4d19ec3927d5210f909f01692f" ] && [ -f "./conf/broadexec.conf" ]; then
  while read BRDEXEC_CONFIG_LINE; do
    BRDEXEC_CONFIG_LINE_ITEM="$(echo "${BRDEXEC_CONFIG_LINE}" | awk -F "=" '{print $1}')"
    if [ "$(grep -c "${BRDEXEC_CONFIG_LINE_ITEM}" ./etc/config_file_valid_entries.db)" -gt 0 ]; then
      BRDEXEC_CONFIG_TMP_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
      echo "${BRDEXEC_CONFIG_LINE}" > ${BRDEXEC_CONFIG_TMP_FILE}
      . ${BRDEXEC_CONFIG_TMP_FILE}
      rm ${BRDEXEC_CONFIG_TMP_FILE}
    fi
  done < ./conf/broadexec.conf
else
  >&2 echo "Unable to load configuration database, run broadexec install again to validate databases"
  exit 1
fi

### connect team config file
if [ ! -z "${BRDEXEC_TEAM_CONFIG}" ] && [ -e "conf/${BRDEXEC_TEAM_CONFIG}" ] && [ -f "conf/${BRDEXEC_TEAM_CONFIG}/broadexec.conf" ]; then
  if [ "$(md5sum ./etc/config_file_valid_entries.db 2>/dev/null | awk '{print $1}')" = "51bf4e4d19ec3927d5210f909f01692f" ]; then
    while read BRDEXEC_CONFIG_LINE; do
      BRDEXEC_CONFIG_LINE_ITEM="$(echo "${BRDEXEC_CONFIG_LINE}" | awk -F "=" '{print $1}')"
      if [ "$(grep -c "${BRDEXEC_CONFIG_LINE_ITEM}" ./etc/config_file_valid_entries.db)" -gt 0 ]; then
        BRDEXEC_CONFIG_TMP_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        echo "${BRDEXEC_CONFIG_LINE}" > ${BRDEXEC_CONFIG_TMP_FILE}
        . ${BRDEXEC_CONFIG_TMP_FILE}
        rm ${BRDEXEC_CONFIG_TMP_FILE}
      fi
    done < ./conf/${BRDEXEC_TEAM_CONFIG}/broadexec.conf
  fi
fi

### connect library
. ./lib/lib.sh
if [ "${?}" -ne 0 ]; then
  >&2 echo "There was problem connecting to library lib.sh Check and install it manually."
  exit 1
fi

### set broadexec runid
RUNID="$(date '+%Y%m%d%H%M%S')_$$"
BRDEXEC_RUNID="brdexec_${RUNID}"

### tell library which script is being run for default non script specific functions
SCRIPT_NAME="$(basename ${0})"

### run report files cleanup
#brdexec_admin_cleanup_report_files
brdexec_load_plugin cleanup_report_files

### Run verbosity option precheck
brdexec_first_verbose_init ${@}

# check installation
if [ "$(grep -c "^#already installed" conf/broadexec.conf)" -eq 0 ]; then
  brdexec_load_plugin brdexec_install
fi

### Get main arguments for the script and process them also if some are missing fill in defaults
brdexec_getopts_main ${@}
brdexec_check_for_conflicting_inputs

#TODO make this work so it can be enabled
#brdexec_check_updates
brdexec_variables_init ${@}

### Run test scenarios
if [ ! -z "${BRDEXEC_RUN_TEST_SCENARIO}" ]; then
  ### verify test library #TODO

  ### load test library #TODO check load
  . ./lib/testing_lib.sh

  testing_init_checks
  testing_load_scenario
  testing_execute_scenarios

  ### remove temp files
  brdexec_temp_files remove_temp_files
  exit 0
fi

### Select hostlist from -h option, read path from conf, if non existing serverlist selected, give options to choose
verbose 220 2
verbose 221 2
brdexec_hosts get_list_of_hostfiles

### Solving issue of missing hosts parameter
if [ -z "${BRDEXEC_DEFAULT_HOSTS_FOLDER_SET}" ] && [ -z "${BRDEXEC_HOSTS}" ] ; then
  brdexec_hosts run_selection_of_hostfiles
fi

### create excluded hostlist if needed
brdexec_hosts create_excluded_hostlist

### If none or invalid script is selected via -s parameter display menu to choose from and run chosen script
if [ "${BRDEXEC_ADMIN_FUNCTIONS}" = "yes" ]; then
  #brdexec_admin_functions
  echo "Admin functions temporarily disabled"
  brdexec_temp_files remove_temp_files
  exit 0
### Run file copy
elif [ ! -z "${BRDEXEC_COPY_FILE}" ]; then
  brdexec_copy_file
  brdexec_temp_files remove_temp_files
  exit 0
### Run script specified as argument to -s parameter
elif [ -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ] || [ ! -f "${BRDEXEC_INPUT_SCRIPT_PATH}" ] || [ -z "${BRDEXEC_SCRIPT_TO_RUN}" ] || [ ! -f "${BRDEXEC_SCRIPT_TO_RUN}" ]; then
  brdexec_script_menu_selection
fi

#spring cleaning #TODO clean vertbose messages
### execute chosen script
verbose 126 2

### verify script signature
brdexec_verify_script_signature "${BRDEXEC_SCRIPT_TO_RUN}"

#brdexec_execute_temp_scripts -s "${BRDEXEC_SCRIPT_TO_RUN}"
brdexec_create_hosts_list_based_on_filter

### check missing known hosts
#if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
brdexec_repair_missing_known_hosts
#fi

if [ -z "${BRDEXEC_BATCH_MODE}" ]; then
  ### search for and ask questions by script
  brdexec_questions

  ### search for and execute embeded script
  brdexec_embeded_script
fi

### search for custom user & password in script file
brdexec_custom_user_pwd

### make script with included info and libraries
brdexec_make_temporary_script "${BRDEXEC_SCRIPT_TO_RUN}"

### display little help in case menu selection was used
if [ ! -z "${BRDEXEC_SELECTED_PARAMETERS_INFO}" ]; then
  brdexec_display_output "To skip menu selection you can run broadexec next time with following parameters: \n./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP}${BRDEXEC_SELECTED_PARAMETERS_INFO}\n" 255
fi

### check if there is some hosts in generated hostslist
if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep -v ^# | grep -v ^$ | wc -l)" -eq 0 ]; then
  display_error "112" 1
fi

### set status from init to running in stats file
brdexec_update_stats -p run_init_counts

verbose 110 1
for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
  BRDEXEC_SERVER_NAME="${BRDEXEC_SERVER}"
  verbose 111 2
  #### create temporary files for logging output
  brdexec_temp_files create_exec
  ### main ssh exec on background capturing outputs to temp file
  brdexec_ssh_pid create "${BRDEXEC_TMP_SCRIPT}"
  ### saving info about main output temp file and error output temp file to an array
  BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID_ID]="${BRDEXEC_MAIN_RUN_OUTPUT}"
  BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID_ID]="${BRDEXEC_ERROR_LOGFILE_MESSAGE}"
done
if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
  rm ${BRDEXEC_SERVERLIST_FILTERED} 2>/dev/null
fi

### Check running pids and connection errors
brdexec_wait_for_pids_to_finish
### Generate error log
brdexec_generate_error_log
### Display error log
brdexec_display_error_log

### Failsafe for removal of temp files that could be forgotten or skipped
brdexec_temp_files remove_temp_files

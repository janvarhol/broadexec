#!/bin/bash

#set -x
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

BRDEXEC_VERSION="0.1"

### manage paths and links
BRDEXEC_WORKING_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BRDEXEC_WORKING_DIRECTORY}"
if [ "${?}" -ne 0 ]; then
  >&2 echo "ERROR: There was problem changing directory to ${BRDEXEC_WORKING_DIRECTORY}. Check and repair it manually."
  exit 1
fi

### check for md5sum
md5sum broadexec.sh 2>/dev/null 1>/dev/null
if [ "$?" -ne 0 ]; then
  >&2 echo "ERROR: Could not find md5sum."
  exit 1
fi

### connect config file
BRDEXEC_CONFIG_CLEAN="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_CONFIG_CLEAN}"
if [ "$(md5sum ./etc/config_file_valid_entries.db 2>/dev/null | awk '{print $1}')" = "c137deae01d35c076ba371cf3b6dbc63" 2>/dev/null ] && [ -f "./conf/broadexec.conf" ]; then
  grep -v "^#" ./conf/broadexec.conf | grep -v "^$" > ${BRDEXEC_CONFIG_CLEAN}
  while read BRDEXEC_CONFIG_LINE; do
    BRDEXEC_CONFIG_LINE_ITEM="$(echo "${BRDEXEC_CONFIG_LINE}" | awk -F "=" '{print $1}')"
    if [ "$(grep -c "${BRDEXEC_CONFIG_LINE_ITEM}" ./etc/config_file_valid_entries.db)" -gt 0 ]; then
      BRDEXEC_CONFIG_TMP_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
      echo "${BRDEXEC_CONFIG_LINE}" > ${BRDEXEC_CONFIG_TMP_FILE}
      . ${BRDEXEC_CONFIG_TMP_FILE}
      rm ${BRDEXEC_CONFIG_TMP_FILE}
    fi
  done < ${BRDEXEC_CONFIG_CLEAN}
else
  >&2 echo "Unable to load configuration database, run broadexec install again to validate databases"
  exit 1
fi

### check teamconfig links
if [ -d "${BRDEXEC_DEFAULT_TEAMCONFIG_FOLDER}" ]; then
  for BRDEXEC_TEAM_FOLDER_ITEM in conf lists scripts; do
    if [ ! -L "${BRDEXEC_TEAM_FOLDER_ITEM}/${BRDEXEC_TEAM}" ]; then
      ln -s "../${BRDEXEC_DEFAULT_TEAMCONFIG_FOLDER}/${BRDEXEC_TEAM_FOLDER_ITEM}" "${BRDEXEC_TEAM_FOLDER_ITEM}/${BRDEXEC_TEAM}" 2>/dev/null
      #if [ "${?}" -ne 0 ]; then
      #  >&2 echo "Unable to create link ${BRDEXEC_TEAM_FOLDER_ITEM}/${BRDEXEC_TEAM} to ${BRDEXEC_DEFAULT_TEAMCONFIG_FOLDER}/${BRDEXEC_TEAM_FOLDER_ITEM}"
      #fi
    fi
  done
fi

### connect team config file
if [ ! -z "${BRDEXEC_TEAM_CONFIG}" ] && [ -e "conf/${BRDEXEC_TEAM_CONFIG}" ] && [ -f "conf/${BRDEXEC_TEAM_CONFIG}/broadexec.conf" ]; then
<<<<<<< HEAD
  if [ "$(md5sum ./etc/config_file_valid_entries.db 2>/dev/null | awk '{print $1}')" = "c137deae01d35c076ba371cf3b6dbc63" ]; then
=======
  if [ "$(md5sum ./etc/config_file_valid_entries.db 2>/dev/null | awk '{print $1}')" = "8773c6a7b20a12d10fca2f2ea16f87b7" ]; then
    grep -v "^#" ./conf/${BRDEXEC_TEAM_CONFIG}/broadexec.conf | grep -v "^$" > ${BRDEXEC_CONFIG_CLEAN}
>>>>>>> development
    while read BRDEXEC_CONFIG_LINE; do
      BRDEXEC_CONFIG_LINE_ITEM="$(echo "${BRDEXEC_CONFIG_LINE}" | awk -F "=" '{print $1}')"
      if [ "$(grep -c "${BRDEXEC_CONFIG_LINE_ITEM}" ./etc/config_file_valid_entries.db)" -gt 0 ]; then
        BRDEXEC_CONFIG_TMP_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        echo "${BRDEXEC_CONFIG_LINE}" > ${BRDEXEC_CONFIG_TMP_FILE}
        . ${BRDEXEC_CONFIG_TMP_FILE}
        rm ${BRDEXEC_CONFIG_TMP_FILE}
      fi
    done < ${BRDEXEC_CONFIG_CLEAN}
  fi
fi

### connect library
. ./lib/lib.sh 2>/dev/null
if [ "${?}" -ne 0 ]; then
  >&2 echo "ERROR: There was problem connecting to library lib.sh Check and install it manually."
  exit 1
fi

### set broadexec runid
RUNID="$(date '+%Y%m%d%H%M%S')_$$"
BRDEXEC_RUNID="brdexec_${RUNID}"

### tell library which script is being run for default non script specific functions
SCRIPT_NAME="$(basename ${0})"

### Run verbosity option precheck
brdexec_first_verbose_init ${@}

### load all enabled plugins
brdexec_load_all_plugins

#brdexec_load_plugin brdexec_dialog_gui
#brdexec_load_plugin brdexec_menu_hostlists

### run plugin hooks for start of script
brdexec_execute_plugin_hooks brdexec_init

### run report files cleanup
#brdexec_load_plugin cleanup_report_files

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
brdexec_hosts get_list_of_hostfiles

### Solving issue of missing hosts parameter
if [ -z "${BRDEXEC_DEFAULT_HOSTS_FOLDER_SET}" ] && [ -z "${BRDEXEC_HOSTS}" ] ; then
  brdexec_hosts run_selection_of_hostfiles
fi

brdexec_execute_plugin_hooks brdexec_manipulate_hostfiles

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

### catch disabled script manual run
for BRDEXEC_DISABLED_SCRIPT_LOOP in "${BRDEXEC_INPUT_SCRIPT_PATH}" "${BRDEXEC_SCRIPT_TO_RUN}"; do
  if [ -f "${BRDEXEC_DISABLED_SCRIPT_LOOP}" ]; then
    if [ "$(grep -wc "^BRDEXEC_SCRIPT_DISABLED" ${BRDEXEC_DISABLED_SCRIPT_LOOP})" -gt 0 ]; then
      display_error "101" 1
    fi
  fi
done

#spring cleaning #TODO clean verbose messages
### execute chosen script
verbose 126 2

### verify script signature
#brdexec_load_plugin brdexec_verify_script_signature
brdexec_execute_plugin_hooks brdexec_before_script_manipulation

brdexec_create_hosts_list_based_on_filter

### check missing known hosts
verbose -s "brdexec_repair_missing_known_hosts ${@}"
BRDEXEC_KNOWN_HOSTS_MESSAGE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
rm "${BRDEXEC_KNOWN_HOSTS_MESSAGE}"
for BRDEXEX_MISSING_KNOWN_HOSTS_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
  brdexec_repair_missing_known_hosts &
  BRDEXEC_KNOWN_HOSTS_PIDS+=" $!"
done

wait ### for known hosts
if [ -f "${BRDEXEC_KNOWN_HOSTS_MESSAGE}" ]; then
  brdexec_display_output "" 2
  rm "${BRDEXEC_KNOWN_HOSTS_MESSAGE}"
fi

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
  if [ ! -z "${BRDEXEC_DIALOG}" ]; then
    brdexec_dialog_gui_info_about_parameters
  else
    brdexec_display_output "To skip menu selection you can run broadexec next time with following parameters: \n./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP}${BRDEXEC_SELECTED_PARAMETERS_INFO}\n" 255
  fi
fi

#### check if there is some hosts in generated hostslist
#if [ "${BRDEXEC_PROXY}" = no ]; then
#  if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep -v "^#" | grep -v ^$ | wc -l)" -eq 0 ]; then
#    display_error "112" 1
#  fi
#fi

### set status from init to running in stats file
brdexec_update_stats -p run_init_counts

brdexec_execute_plugin_hooks brdexec_before_ssh

if [ "${BRDEXEC_PROXY}" = "yes" 2>/dev/null ]; then
  BRDEXEC_DIRECTLY_LIST="$(echo "${BRDEXEC_SERVERLIST_CHOSEN}" | sed -e 's/all./directly./g')"
  if [ -f "${BRDEXEC_DIRECTLY_LIST}" ]; then
    BRDEXEC_SERVERLIST_LOOP="$(egrep -v "^#|^$" "${BRDEXEC_DIRECTLY_LIST}")"
  else
    BRDEXEC_SERVERLIST_LOOP=""
  fi
fi

### check if there is some hosts in generated hostslist
if [ "${BRDEXEC_PROXY}" = no ]; then
  if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep -v "^#" | grep -v ^$ | wc -l)" -eq 0 ]; then
    display_error "112" 1
  fi
fi


verbose 110 1
for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do

  if [ "$(echo "${BRDEXEC_SERVER}" | grep -c "@")" -eq 1 ]; then
    BRDEXEC_SERVERNAME="$(echo "${BRDEXEC_SERVER}" | awk -F "@" '{print $2}')"
  else
    BRDEXEC_SERVERNAME="$(echo "${BRDEXEC_SERVER}")"
  fi
  if [ "$(echo "${BRDEXEC_SERVERNAME}" | grep -c ":")" -eq 1 ]; then
    BRDEXEC_SERVERNAME="$(echo "${BRDEXEC_SERVERNAME}" | awk -F ":" '{print $1}')"
  fi

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
#brdexec_wait_for_pids_to_finish

### count timeouts from this moment
BRDEXEC_START_TIME=$(date +%s)

### initialize report file in case this is normal run
if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
  brdexec_temp_files create_report
fi

### wait for all the answers or until timeout and display output as it is coming
brdexec_display_output_until_timeout

brdexec_execute_plugin_hooks brdexec_display_main_output

### checking what had timed out and sorting it out
brdexec_timeouted

### cleanup main output files
for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
  brdexec_temp_files remove_main_output
done


### Generate error log
brdexec_generate_error_log
brdexec_execute_plugin_hooks brdexec_generate_error_log
### Display error log
brdexec_display_error_log

### Failsafe for removal of temp files that could be forgotten or skipped
brdexec_temp_files remove_temp_files

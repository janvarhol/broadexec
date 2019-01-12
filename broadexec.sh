#!/bin/bash

### beta version of broadexec script
### also see manpage in man folder
### to view available parameters run broadexec -h
### if run without parameters it will provide menu of available scripts and hostlists with limited basic functionality

BRDEXEC_VERSION="0.9.0"

### manage paths and links
BRDEXEC_WORKING_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BRDEXEC_WORKING_DIRECTORY}"
if [ "${?}" -ne 0 ]; then
  echo "There was problem changing directory to ${BRDEXEC_WORKING_DIRECTORY}. Check and repair it manually."
  exit 1
fi

### connect config file
if [ "$(md5sum ./etc/config_file_valid_entries.db | awk '{print $1}')" = "a9ea8a5f651c790d84ffad180e08130b" ]; then
  if [ -f "./conf/broadexec.conf" ]; then
    while read BRDEXEC_CONFIG_LINE; do
      BRDEXEC_CONFIG_LINE_ITEM="$(echo "${BRDEXEC_CONFIG_LINE}" | awk -F "=" '{print $1}')"
      if [ "$(grep -c "${BRDEXEC_CONFIG_LINE_ITEM}" ./etc/config_file_valid_entries.db)" -gt 0 ]; then
        BRDEXEC_CONFIG_TMP_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        echo "${BRDEXEC_CONFIG_LINE}" > ${BRDEXEC_CONFIG_TMP_FILE}
        . ${BRDEXEC_CONFIG_TMP_FILE}
        rm ${BRDEXEC_CONFIG_TMP_FILE}
      fi
    done < ./conf/broadexec.conf
  fi
else
  echo "Unable to load configuration database, run broadexec install again to validate databases"
  exit 1
fi

### connect team config file
if [ ! -z "${BRDEXEC_TEAM_CONFIG}" ] && [ -e "conf/${BRDEXEC_TEAM_CONFIG}" ] && [ -f "conf/${BRDEXEC_TEAM_CONFIG}/broadexec.conf" ]; then
  if [ "$(md5sum ./etc/config_file_valid_entries.db | awk '{print $1}')" = "a9ea8a5f651c790d84ffad180e08130b" ]; then
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
  echo "There was problem connecting to library lib.sh Check and install it manually."
  exit 1
fi

### initialize shared variables from library
#init
RUNID="$(date '+%Y%m%d%H%M%S')_$$"

### tell library which script is being run for default non script specific functions
SCRIPT_NAME="$(basename ${0})"

### run report files cleanup
brdexec_admin_cleanup_report_files

### Run verbosity option precheck
brdexec_first_verbose_init ${@}

#TODO firstrun message until auto-configuration is implemented
### Firstrun
#if [ -f ./firstrun ]; then
#  echo "--------------------------------------------------------------------------"
#  echo "This is your first run of broadexec, welcome and hope you will enjoy it ! "
#  echo "Please consider reading man and docs and configure your broadexec properly"
#  echo "--------------------------------------------------------------------------"
#  rm ./firstrun
#fi

# check installation
if [ "$(grep -c "^#already installed" conf/broadexec.conf)" -eq 0 ]; then
  brdexec_install
fi

### Get main arguments for the script and process them also if some are missing fill in defaults
brdexec_getopts_main ${@}

#TODO make this work so it can be enabled
#brdexec_check_updates
brdexec_variables_init ${@}

### Run test suite with defined scenarios
if [ ! -z "${BRDEXEC_RUN_TEST_SCENARIO}" ]; then
  ### verify test library

  ### load test library
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

### Select hostlist from -h option, read path from conf, if non existing serverlist selected, give options to choose
brdexec_hosts get_list_of_hostfiles

### Solving issue of missing hosts parameter
if [ -z "${BRDEXEC_DEFAULT_HOSTS_FOLDER_SET}" ] && [ -z "${BRDEXEC_HOSTS}" ] ; then
  brdexec_hosts run_selection_of_hostfiles
fi

### create excluded hostlist if needed
brdexec_hosts create_excluded_hostlist

### If none or invalid script is selected via -s parameter display menu to choose from and run chosen script
if [ "${BRDEXEC_ADMIN_FUNCTIONS}" = "yes" ]; then
  brdexec_admin_functions
### Run file copy
elif [ ! -z "${BRDEXEC_COPY_FILE}" ]; then
  brdexec_copy_file
### Run select for script
elif [ "${BRDEXEC_DEFINED_OPTION_START}" = "yes" ]; then
  brdexec_defined_option_exec
### Run script specified as argument to -s parameter
elif [ ! -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
  brdexec_script_exec
else
  display_error "100" 1
fi

if [ -z "${BRDEXEC_ADMIN_FUNCTIONS}" ] && [ -z "${BRDEXEC_COPY_FILE}" ]; then
  ### Check running pids and connection errors
  brdexec_wait_for_pids_to_finish
  ### Generate error log
  brdexec_generate_error_log
  ### Display error log
  brdexec_display_error_log
fi

### Failsafe for removal of temp files that could be forgotten or skipped
brdexec_temp_files remove_temp_files

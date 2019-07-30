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

#
#######################
#######################
## Table of contents ##
#######################
#######################
#
#
# (x)1x(x) - Main/Core functions
# (x)2xx   - Initialization/Loading/Checking functions
# (x)3x(x) - Error/Output/Format/Export functions
# (x)4x(x) - Helper/Install/Rare use functions
#
####################################
####################################
## Standard library functions ##
####################################
####################################
#
# 300 H (ALL) display_error - display error message from any function or part of script.
#      First parameter is mandatory and it is message to be displayed.
#      Second one is error code which is optional. Example: display_error "Wrong input" 1
#
# 302 H (ALL) verbose - if verbose option is on, this one displays nearly everything there is
#      so you can find out where the problem might be. Generally used only for developing and should be probably
#      disabled in final product
#
# 308 H (ALL) log - log anything based on log settings
#
# 312 H (ALL) limit_file_size - display error and stop in case file checked is bigger than requested
#      Stops generating data in case there is infinite loop or wrong data collection in place
#      -c for characters, -M for megabytes, -l lines
#
##################################
##################################
## Broadexec specific functions ##
##################################
##################################
#
### How Broadexec works in nushell ######
#
#   Broadexec script calls for getopts management to sort out arguments. If you need to add some,
#   You can do it in brdexec_getopts_main. Serverlist selection is done in brdexec_select_hostlist.
#   It ignores commented out servers and if there is just one serverlist, script will use it.
#
#   Then most commonly brdexec_script_menu_selection will be called.
#   This function just sorts out various scripts that are prepared and tested by somebody responsible and it calls
#   brdexec_execute_temp_scripts which is doing actual magic stuff.
#
#
#################################
###### Main/Core functions ######
#################################
#
# 11   brdexec_execute_temp_scripts - main execution of temp scripts provided by filtering or options
#
# 12   brdexec_script_menu_selection - function to be run when you select to run set
#      of predefined scripts
#
# 13   brdexec_script_exec - function to be run when you input script path or name as argument to -s parameter
#      First it will check if path or name is valid may it be relative or absolute if not it tries
#      to search for such file inside of predefined scripts folder, if not found script selection will be displayed
#
# 14   brdexec_ssh_pid - function to create, check and kill ssh process
#
# 15   (11) brdexec_wait_for_pids_to_finish - loop for checking if every run on every server is finished
#
# 16 H (30,32) script_specific - helper function for various scripts like broadexec to enhance basic
#       standard library functions while preserving standardization of standard functions
#
# 17   brdexec_copy_file - copy selected file(s) to destination on remote hosts
#
# 18   brdexec_hosts - everything to do with hosts files/lists
#
# 19   brdexec_scripts - everything to do with scripts
#
#######################################################
###### Initialization/Loading/Checking functions ######
#######################################################
#
# 200 H (10) brdexec_first_verbose_init - check and enable verbosity before arguments are read. Insane but useful.
#
# 201 H (10) brdexec_getopts_main - get end process main arguments to the script and check for conflicting inputs
#
# 204 H (10) brdexec_variables_init - check all variables read from config file and assume defaults if missing
#
# 205 H brdexec_temp_files - function to automate creation and deletion of temp files
#
# 206 H (15) brdexec_display_output_until_timeout - check back in bursts from servers and display output continually
#      until timeout
#
# 207 H (15) brdexec_timeouted - sort out timeouted servers, display info, write into report
#
# 208 H (22) brdexec_select_hosts_filter - in case -l option is not present and hosts file selection takes place
#      display select menu for all possible filters available in hosts file that was previously chosen
#
# 209 H (11) (41) brdexec_create_hosts_list_based_on_filter - separate function to recreate hostslist
#      to be used based on filter options entered
#
# 211 H brdexec_create_temporary_hosts_list_based_on_filter - due to complicated nature of filter selection this
#       was created as reusable code for hosts fiters due to multilevel multi instance filtering capabilities
#
# 212 H brdexec_make_temporary_script - create temporary script to be run on hosts with included variables and libraries
#
# 213 H brdexec_verify_script_signature
#
# 214 H brdexec_check_for_conflicting_inputs
#
##################################################
###### Error/Output/Format/Export functions ######
##################################################
#
# 301 H (10) brdexec_usage - simple usage to be displayed when wrong input is provided with list of
#      avaliable arguments
#
# 303 H (11) brdexec_generate_error_log - create structured error log file with hostname info and every
#      error for each host on the same line
#
# 304 H (11) brdexec_display_error_log - display generated error messages and connection problems if any occured
#
# 305   (11) brdexec_repair_missing_known_hosts - after run if some known_hosts errors are detected, script
#      will try to reolve them by downloading and adding needed keys to known_hosts
#
# 306 H brdexec_display_output - display main output when there is no quiet mode, display nothing if there is
#
# 307 H brdexec_interruption_ctrl_c - display info and clean after itself when CTRL+C is pressed
#
# 309 H (11) brdexec_questions - ask questions according to script setting
#
# 310 H (11) brdexec_custom_user_pwd - search for custom user and password in selected script and
#       run broadexec with this credentials
#
# 311 H (11) brdexec_embeded_script - search for embeded script and run it to gather info for
#       main script parameters
#
# 312 H limit_file_size - exit of file size broadexec is trying to write to exceeds size limit
#
# 313 H brdexec_update_stats - update stats file according to broadexec progress for reporting to other scripts
#
###############################################
###### Helper/Install/Rare use functions ######
###############################################
#
# 41   brdexec_admin_functions - run admin interface to check connectivity, distribute ssh keys,
#      check sudo functionality, fix local user password expiration
#
# 42   (41) brdexec_admin_check_and_fix_ssh_keys - check and fix ssh keys on selected filtered hostslist
#
# 43   (41) brdexec_admin_check_and_fix_password_expiration
#
# 44   (41) brdexec_admin_check_connectivity_and_sudo_functionality
#
# 45   (41) brdexec_admin_cleanup_report_files - cleanup report files based on settings
#
# 46   brdexec_check_updates - first function run after loading library into broadexec,
#      it will check if config file is present and possible updates downloadable from git
#
# 47   brdexec_create_config_file - create basic config file when broadexec is run for the first time
#
# 48   (41) brdexec_admin_ask_password
#

#########################################################################################
###### Functions ########################################################################
#########################################################################################

#11
#brdexec_execute_temp_scripts () { verbose -s "brdexec_execute_temp_scripts ${@}"
#
#  if [ "${1}" = "-s" ] 2>/dev/null; then
#
#    brdexec_create_hosts_list_based_on_filter
#
#    ### check missing known hosts
#    if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
#      brdexec_repair_missing_known_hosts
#    fi
#
#    if [ -z "${BRDEXEC_BATCH_MODE}" ]; then
#      ### search for and ask questions by script
#      brdexec_questions
#
#      ### search for and execute embeded script
#      brdexec_embeded_script
#    fi
#
#    ### search for custom user & password in script file
#    brdexec_custom_user_pwd
#
#    ### make script with included info and libraries
#    brdexec_make_temporary_script "${2}"
#
#    ### display little help in case menu selection was used
#    if [ ! -z "${BRDEXEC_SELECTED_PARAMETERS_INFO}" ]; then
#      brdexec_display_output "To skip menu selection you can run broadexec next time with following parameters: \n./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP}${BRDEXEC_SELECTED_PARAMETERS_INFO}\n" 255
#    fi
#
#    ### check if there is some hosts in generated hostslist
#    if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep -v ^# | grep -v ^$ | wc -l)" -eq 0 ]; then
#      display_error "112" 1
#    fi
#
#    ### set status from init to running in stats file
#    brdexec_update_stats -p run_init_counts
#
#    verbose 110 1
#    for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
#      BRDEXEC_SERVER_NAME="${BRDEXEC_SERVER}"
#      verbose 111 2
#      #### create temporary files for logging output
#      brdexec_temp_files create_exec
#      ### main ssh exec on background capturing outputs to temp file
#      brdexec_ssh_pid create "${BRDEXEC_TMP_SCRIPT}"
#      ### saving info about main output temp file and error output temp file to an array
#      BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID_ID]="${BRDEXEC_MAIN_RUN_OUTPUT}"
#      BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID_ID]="${BRDEXEC_ERROR_LOGFILE_MESSAGE}"
#    done
#    if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
#      rm ${BRDEXEC_SERVERLIST_FILTERED} 2>/dev/null
#    fi
#  fi
#}

#12
brdexec_script_menu_selection () { verbose -s "brdexec_script_menu_selection ${@}"

  ### get list of predefined scripts
  verbose 120 2
  if [ -d "${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_TEAM_CONFIG}" ] && [ ! -z "${BRDEXEC_TEAM_CONFIG}" ]; then
    BRDEXEC_LIST_OF_TEAM_PREDEFINED_SCRIPTS="$(ls -1 ${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_TEAM_CONFIG} 2>/dev/null | grep -v README | grep ".sh$" | tr '\n' ' ')"
  fi

  BRDEXEC_LIST_OF_CUSTOM_PREDEFINED_SCRIPTS="$(ls -1 ${BRDEXEC_DEFAULT_SCRIPTS_FOLDER} 2>/dev/null | grep -v README | grep ".sh$" | tr '\n' ' ')"
  ### create list with full relative paths
  for BRDEXEC_TEAM_PREDEFINED_SCRIPT in ${BRDEXEC_LIST_OF_TEAM_PREDEFINED_SCRIPTS}; do
    BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS="${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS} ${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_PREDEFINED_SCRIPT}"
  done
  for BRDEXEC_CUSTOM_PREDEFINED_SCRIPT in ${BRDEXEC_LIST_OF_CUSTOM_PREDEFINED_SCRIPTS}; do
    BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS="${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS} ${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_CUSTOM_PREDEFINED_SCRIPT}"
  done
  verbose 121 2

  ### Check if folder with predefined scripts exists
  verbose 122 2
  if [ -d "${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}" ]; then

    ### Check if there are any scripts in predefined folder
    verbose 123 2
    if [ "$(echo "${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}" | wc -l)" -gt 0 ]; then

      ### Exit in batch mode
      if [ "${BRDEXEC_BATCH_MODE}" = "yes" ]; then
        display_error "124" 1
      fi
      ### Display menu to choose from scripts
      verbose 124 2

      BRDEXEC_SCRIPT_SELECT_ID=0
      echo "Available scripts:"
      for BRDEXEC_PREDEFINED_SCRIPTS_ITEM in ${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}; do
	      ((BRDEXEC_SCRIPT_SELECT_ID++))
        echo "${BRDEXEC_SCRIPT_SELECT_ID}) ${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"
      done

      ### setting prompt
      echo
      echo -n 'Select script to run #> '

      unset BRDEXEC_PREDEFINED_SCRIPTS_ITEM
      read BRDEXEC_PREDEFINED_SCRIPTS_ITEM
      if [ "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" = "" 2>/dev/null ]; then
        display_error "120" 1
      elif ! [ "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" -eq "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" 2>/dev/null ]; then
        display_error "120" 1
      elif [ "$(echo "${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}" | wc -w)" -lt "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" 2>/dev/null ]; then
        display_error "120" 1
      elif [ "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" -lt 1 2>/dev/null ]; then
        display_error "120" 1
      else
        BRDEXEC_SCRIPT_SELECT_ID="${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"
        BRDEXEC_PREDEFINED_SCRIPTS_ITEM="$(echo "${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}" | awk -v field="$BRDEXEC_PREDEFINED_SCRIPTS_ITEM" '{print $field}')"
        brdexec_display_output "${BRDEXEC_SCRIPT_SELECT_ID}) ${BRDEXEC_PREDEFINED_SCRIPTS_ITEM} was selected\n" 255
      fi

      brdexec_display_output "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM} was selected.\n" 255

      ### add selection to info line about selected parameters
      BRDEXEC_SELECTED_PARAMETERS_INFO="${BRDEXEC_SELECTED_PARAMETERS_INFO} -s ${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"
      BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"

    ### missing predefined scripts
    else
      display_error "121" 2
    fi

  ### missing scripts folder
  else
    display_error "122" 2
  fi
}

#14
brdexec_ssh_pid () { verbose -s "brdexec_ssh_pid ${@}"

  ### create ssh process
  if [ "${1}" = "create" ]; then

    ### check for entry in broadexec hosts file and use it if found
    if [ ! -z "${BRDEXEC_SERVER}" ] && [ -f "${BRDEXEC_HOSTS_FILE}" ]; then
      if [ "$(grep -ic "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE} 2>/dev/null)" -gt 0 ] 2>/dev/null; then
        BRDEXEC_SERVER="$(grep -i "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE} | head -n 1 | awk '{print $1}')"
      fi
    fi

    ### main ssh command of broadexec
    ### check for script with custom credentials
    if [ -z "${BRDEXEC_SCRIPT_CUSTOM_CREDENTIALS}" ]; then
      cat ${2} | ssh -o StrictHostKeyChecking=yes -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} "cat > /tmp/${BRDEXEC_RUNID}.sh && uname -n && ${BRDEXEC_RUNSHELL} \"sh /tmp/${BRDEXEC_RUNID}.sh${BRDEXEC_QUESTION_SCRIPT_PARAMETERS}${BRDEXEC_EMBEDED_PARAMETERS}\" ; rm /tmp/${BRDEXEC_RUNID}.sh" 2>>${BRDEXEC_ERROR_LOGFILE_MESSAGE} >> ${BRDEXEC_MAIN_RUN_OUTPUT} &

      ### catching PID ID to check on this session
      BRDEXEC_SSH_PID_ID="${!}"
      BRDEXEC_SSH_PIDS+=" ${BRDEXEC_SSH_PID_ID}"; verbose 141 3

    ### run pid with custom credentials
    else
      ### use askpass script to log in with password
      SSH_ASKPASS_PASSWORD="${BRDEXEC_SCRIPT_PWD}"
      SSH_ASKPASS_SCRIPT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
      BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${SSH_ASKPASS_SCRIPT}"
      # $ (dollars) are not escaped in original script
      cat <<EOF >${SSH_ASKPASS_SCRIPT}
      if [ -n "\$SSH_ASKPASS_PASSWORD" ]; then
        cat <<< "\$SSH_ASKPASS_PASSWORD"
      elif [ \$# -lt 1 ]; then
        echo "Usage: echo password | \$0 <ssh command line options>" >&2
        exit 1
      else
        read SSH_ASKPASS_PASSWORD
        export SSH_ASKPASS=\$0
        export SSH_ASKPASS_PASSWORD
        [ "\$DISPLAY" ] || export DISPLAY=dummydisplay:0
        # use setsid to detach from tty
        exec setsid "\$@" </dev/null
      fi
EOF
      chmod 755 ${SSH_ASKPASS_SCRIPT}

      ### use scp to copy file due to conflicting algorithms in main ssh function and askpass script
      echo $SSH_ASKPASS_PASSWORD | $SSH_ASKPASS_SCRIPT scp ${2} ${BRDEXEC_SCRIPT_USER}@${BRDEXEC_SERVER}:/tmp/${BRDEXEC_RUNID}.sh

      echo $SSH_ASKPASS_PASSWORD | $SSH_ASKPASS_SCRIPT ssh -o StrictHostKeyChecking=no -o ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT} -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes -o PubkeyAuthentication=no -q ${BRDEXEC_SCRIPT_USER}@${BRDEXEC_SERVER} "uname -n 2>>/tmp/${BRDEXEC_RUNID}.error >>/tmp/${BRDEXEC_RUNID}.data && ${BRDEXEC_RUNSHELL} \"sh /tmp/${BRDEXEC_RUNID}.sh${BRDEXEC_QUESTION_SCRIPT_PARAMETERS}${BRDEXEC_EMBEDED_PARAMETERS}\" 2>>/tmp/${BRDEXEC_RUNID}.error >>/tmp/${BRDEXEC_RUNID}.data ; rm /tmp/${BRDEXEC_RUNID}.sh"

      echo $SSH_ASKPASS_PASSWORD | $SSH_ASKPASS_SCRIPT ssh -o StrictHostKeyChecking=no -o ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT} -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes -o PubkeyAuthentication=no -q ${BRDEXEC_SCRIPT_USER}@${BRDEXEC_SERVER} "cat /tmp/${BRDEXEC_RUNID}.data"
      echo $SSH_ASKPASS_PASSWORD | $SSH_ASKPASS_SCRIPT ssh -o StrictHostKeyChecking=no -o ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT} -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes -o PubkeyAuthentication=no -q ${BRDEXEC_SCRIPT_USER}@${BRDEXEC_SERVER} "cat /tmp/${BRDEXEC_RUNID}.error"

      ### catching PID ID to check on this session
      BRDEXEC_SSH_PID_ID="${!}"
      BRDEXEC_SSH_PIDS+=" ${BRDEXEC_SSH_PID_ID}"; verbose 141 3
      rm ${SSH_ASKPASS_SCRIPT}

    fi

  ### kill ssh process
  elif [ "${1}" = "kill" ]; then

    ### check if pid is still active
    ps -p ${BRDEXEC_SSH_PID} >/dev/null
    if [ "${?}" -eq 0 ]; then
      disown ${BRDEXEC_SSH_PID}
      kill -9 ${BRDEXEC_SSH_PID} >/dev/null 2>&1

      ### wait for process to end
      brdexec_ssh_pid wait_for_process_to_end ${BRDEXEC_SSH_PID}

      ### removing temporary file on remote host after killing ssh session
      if [ ! -z "${BRDEXEC_PROCESS_KILLED}" ]; then
        ssh -o StrictHostKeyChecking=yes -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} "rm /tmp/${BRDEXEC_RUNID}.sh 2>/dev/null" 2>/dev/null
        BRDEXEC_SSH_KILL_PID="${?}"
        ### wait for process to end
        brdexec_ssh_pid wait_for_process_to_end ${BRDEXEC_SSH_KILL_PID}
      fi

    fi
  elif [ "${1}" = "wait_for_process_to_end" ]; then

    BRDEXEC_SSH_KILLED_PID_TO_WAIT="${2}"

    ### wait for process to end
    sleep 0.2 2>/dev/null || sleep 1
    unset BRDEXEC_PROCESS_KILLED
    BRDEXEC_TIMES_KILL_CHECKED_COUNT=0
    ps -p ${BRDEXEC_SSH_KILLED_PID_TO_WAIT} >/dev/null
    if [ "${?}" -eq 0 ]; then
      while [ "${BRDEXEC_TIMES_KILL_CHECKED_COUNT}" -lt 11 ]; do
        ((BRDEXEC_TIMES_KILL_CHECKED_COUNT+=1))
        ### sleeping with intelligence
        if [ "${BRDEXEC_TIMES_KILL_CHECKED_COUNT}" -lt 4 ]; then
          sleep 0.2 2>/dev/null || sleep 1
        elif [ "${BRDEXEC_TIMES_KILL_CHECKED_COUNT}" -lt 8 ]; then
          sleep 0.8 2>/dev/null || sleep 1
        else
          sleep 2
        fi

        ### check if it ended
        ps -p ${BRDEXEC_SSH_KILLED_PID_TO_WAIT} >/dev/null
        if [ "${?}" -ne 0 ]; then
          BRDEXEC_PROCESS_KILLED="yes"
          BRDEXEC_TIMES_KILL_CHECKED_COUNT=42
        fi
      done
    fi
    ### final check
    ps -p ${BRDEXEC_SSH_KILLED_PID_TO_WAIT} >/dev/null
    if [ "${?}" -eq 0 ]; then
      brdexec_display_output "SSH process with PID ${BRDEXEC_SSH_KILLED_PID_TO_WAIT} is unable to be stopped. Check manually." 1 error
    fi

  fi
}

#15
brdexec_wait_for_pids_to_finish () { verbose -s "brdexec_wait_for_pids_to_finish ${@}"

  ### count timeouts from this moment
  BRDEXEC_START_TIME=$(date +%s)

  ### initialize report file in case this is normal run
  if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
    brdexec_temp_files create_report
  fi

  ### wait for all the answers or until timeout and display output as it is coming
  brdexec_display_output_until_timeout

  ### checking what had timed out and sorting it out
  brdexec_timeouted

  ### cleanup main output files
  for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
    brdexec_temp_files remove_main_output
  done
}

#16
script_specific () {

  ### NOTE
  ### do not insert verbose -s into this function
  ### because it will create infinite loop

  case ${1} in
    ### broadexec specifics
    broadexec.sh)
    case ${2} in
      ### broadexec error display specifics
      display_error)
        case ${3} in
          write_last_run_log)
            [ -f "./etc/display_error.db" ] && . ./etc/display_error.db
            echo -e "ERROR [${4}] ${ERROR_MESSAGE[$4]}" >> ${BRDEXEC_LOG_LAST_RUN}
          ;;
          exit)
            BRDEXEC_EXIT_IN_PROGRESS="yes"
            brdexec_interruption_ctrl_c
          ;;
        esac
      ;;
      ### broadexec verbose output specifics
      verbose)
        case ${3} in
          write_last_run_log)
            [ -f "./etc/verbose.db" ] && . ./etc/verbose.db
            echo "   VERBOSE[${4}]: ${VERBOSE_MESSAGE[$4]}" >> ${BRDEXEC_LOG_LAST_RUN}
          ;;
          write_last_run_log_start)
            echo "   VERBOSE: Function ${4} START" >> ${BRDEXEC_LOG_LAST_RUN}
          ;;
          write_anything_other)
            echo "${4}" >> ${BRDEXEC_LOG_LAST_RUN}
          ;;
        esac
      ;;
    esac
    ;;
  esac
}

#17
brdexec_copy_file () { verbose -s "brdexec_copy_file ${@}"

  brdexec_create_hosts_list_based_on_filter

  ### check missing known hosts
  if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
    brdexec_repair_missing_known_hosts
  fi

  ### display little help in case menu selection was used
  if [ ! -z "${BRDEXEC_SELECTED_PARAMETERS_INFO}" ]; then
    brdexec_display_output "To skip menu selection you can run broadexec next time with following parameters: \n./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP}${BRDEXEC_SELECTED_PARAMETERS_INFO}\n" 255 error
  fi

  ### check input file
  if [ ! -f "${BRDEXEC_COPY_FILE}" ]; then
    display_error "171" 1
  fi

  ### check output folder
  if [ "$(echo "${BRDEXEC_COPY_DESTINATION}" | cut -c 1)" != "/" ] 2>/dev/null; then
    display_error "170" 1
  fi
  if [ "$(echo "${BRDEXEC_COPY_DESTINATION}" | grep -Fc '..')" -gt 0 ]; then
    display_error "172" 1
  fi
  if [ "$(echo "${BRDEXEC_COPY_DESTINATION}" | grep -c "^/tmp")" -eq 0 ] && [ "$(echo "${BRDEXEC_COPY_DESTINATION}" | grep -c "^/home")" -eq 0 ]; then
    display_error "173" 1
  fi

  ### copy files
  for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
    BRDEXEC_SERVER_NAME="${BRDEXEC_SERVER}"
    echo -e "${BRDEXEC_SERVER}"
    scp -B -C -p -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_COPY_FILE} ${BRDEXEC_USER}@${BRDEXEC_SERVER}:${BRDEXEC_COPY_DESTINATION}
  done
}

#18
brdexec_hosts () {

  case ${1} in
    init_default_hosts_folder)
      if [ -z "${BRDEXEC_DEFAULT_HOSTS_FOLDER}" ]; then
        BRDEXEC_DEFAULT_HOSTS_FOLDER=hosts
      fi
      if [ ! -d "${BRDEXEC_DEFAULT_HOSTS_FOLDER}" ]; then
        display_error "180" 1
      fi
    ;;
    check_hosts_file_from_parameter_input)
      if [ ! -z "${BRDEXEC_HOSTLIST_FROM_PARAMETER}" ]; then
        if [ -f "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
          BRDEXEC_DEFAULT_HOSTS_FOLDER_SET="yes"
        else
          display_error "184" 1
        fi
      else
        BRDEXEC_HOSTLIST_NOT_FOUND="yes"
      fi
    ;;
    create_excluded_hostlist)
      if [ ! -z "${BRDEXEC_HOSTSLIST_EXCLUDE}" ]; then
        BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1}"
        BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2}"
        cat ${BRDEXEC_SERVERLIST_CHOSEN} > ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1}
        BRDEXEC_HOSTSLIST_EXCLUDE="${BRDEXEC_HOSTSLIST_EXCLUDE//,/ }"
        for BRDEXEC_HOST_EXCLUDED in ${BRDEXEC_HOSTSLIST_EXCLUDE}; do
          grep -v "^${BRDEXEC_HOST_EXCLUDED} "  ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1} > ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2}
          cat ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2} > ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1}
          grep -v "^${BRDEXEC_HOST_EXCLUDED}$"  ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1} > ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2}
          cat ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP2} > ${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1}
        done
        BRDEXEC_SERVERLIST_CHOSEN="${BRDEXEC_HOSTSLIST_EXCLUDED_TEMP1}"
      fi
    ;;
    get_list_of_hostfiles)
      verbose 220 2
      verbose 221 2
      ### get list of team hostsfiles
      if [ -d "${BRDEXEC_DEFAULT_HOSTS_FOLDER}/${BRDEXEC_TEAM_CONFIG}" ] && [ ! -z "${BRDEXEC_TEAM_CONFIG}" ]; then
        if [ "$(ls -1 ${BRDEXEC_DEFAULT_HOSTS_FOLDER}/${BRDEXEC_TEAM_CONFIG} 2>/dev/null | grep -v ^hosts$ | wc -l)" -gt 0 ]; then
          BRDEXEC_LIST_OF_TEAM_HOSTSFILES="$(ls -1 ${BRDEXEC_DEFAULT_HOSTS_FOLDER}/${BRDEXEC_TEAM_CONFIG} 2>/dev/null | grep -v ^hosts$ | tr '\n' ' ')"
        fi
      fi

      ### get list of custom hostsfiles
      #2233 FIXME
      BRDEXEC_LIST_OF_CUSTOM_HOSTSFILES="$(ls -1 ${BRDEXEC_DEFAULT_HOSTS_FOLDER} 2>/dev/null | grep -v ^hosts$ | grep -v ^${BRDEXEC_TEAM_CONFIG}$ | tr '\n' ' ')"
      BRDEXEC_LIST_OF_SERVERLISTS="${BRDEXEC_LIST_OF_TEAM_HOSTSFILES} ${BRDEXEC_LIST_OF_CUSTOM_HOSTSFILES}"

      ### check if there are some hostslists
      if [ "$(echo "${BRDEXEC_LIST_OF_SERVERLISTS}" | wc -l)" -lt 1 ]; then
        display_error "181" 1
      fi

      ### create temporary hostlist from -H option
      if [ "${BRDEXEC_SERVERLIST_CHOSEN}" = "" ] && [ ! -z "${BRDEXEC_HOSTS}" ] ; then
        BRDEXEC_SERVERLIST_CHOSEN="$(mktemp)"
        BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_SERVERLIST_CHOSEN}"
        for BRDEXEC_INPUT_HOST in $(echo "${BRDEXEC_HOSTS}" | sed -e 's/,/\ /g'); do
          echo "${BRDEXEC_INPUT_HOST}" >> ${BRDEXEC_SERVERLIST_CHOSEN}
        done
      fi
    ;;
    run_selection_of_hostfiles)
      if [ ! -z "${BRDEXEC_HOSTLIST_NOT_FOUND}" ]; then

        ### Exit in batch mode
        if [ "${BRDEXEC_BATCH_MODE}" = "yes" ]; then
          display_error "182" 1
        fi

        ### Running custom select to choose from hostslists
        if [ "$(echo "${BRDEXEC_LIST_OF_SERVERLISTS}" | wc -w)" -gt 0 ] || [ ! -z "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
          verbose 183 2

          ### create hostsfile list with full relative paths
          for BRDEXEC_TEAM_HOSTSFILE in ${BRDEXEC_LIST_OF_TEAM_HOSTSFILES}; do
            BRDEXEC_LIST_OF_FULL_HOSTSFILES="${BRDEXEC_LIST_OF_FULL_HOSTSFILES} hosts/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_HOSTSFILE}"
          done
          for BRDEXEC_CUSTOM_HOSTSFILE in ${BRDEXEC_LIST_OF_CUSTOM_HOSTSFILES}; do
            BRDEXEC_LIST_OF_FULL_HOSTSFILES="${BRDEXEC_LIST_OF_FULL_HOSTSFILES} hosts/${BRDEXEC_CUSTOM_HOSTSFILE}"
          done
          ### check and include default hostfile in case it is linked differently or in different folder
          if [ -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
            if [ "$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | grep -c "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}")" -eq 0 ]; then
              BRDEXEC_LIST_OF_FULL_HOSTSFILES="${BRDEXEC_LIST_OF_FULL_HOSTSFILES} ${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}"
            fi
          fi

          echo -e "\nAvailable hostlists:"

          BRDEXEC_HOSTLIST_SELECT_ID=0
          for BRDEXEC_HOSTLIST_CHOSEN_ITEM in ${BRDEXEC_LIST_OF_FULL_HOSTSFILES}
          do
            ((BRDEXEC_HOSTLIST_SELECT_ID++))
            echo "${BRDEXEC_HOSTLIST_SELECT_ID}) ${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
          done

          ### display prompt
          echo
          if [ ! -z "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
            if [ -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
              echo -n "Select hostslist # [${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}] "
            else
              echo -n "Select hostslist # "
            fi
          else
            echo -n "Select hostslist # "
          fi
          verbose 182 1

          unset BRDEXEC_HOSTLIST_CHOSEN_ITEM
          read BRDEXEC_HOSTLIST_CHOSEN_ITEM
          if [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" = "" 2>/dev/null ]; then
            if [ -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
              BRDEXEC_HOSTLIST_CHOSEN_ITEM="${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}"
              brdexec_display_output "Default hostlist ${BRDEXEC_HOSTLIST_CHOSEN_ITEM} was selected\n" 255
            else
              display_error "183" 1
            fi
          elif ! [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" -eq "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" 2>/dev/null ]; then
            display_error "183" 1
          elif [ "$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | wc -w)" -lt "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" 2>/dev/null ]; then
            display_error "183" 1
          elif [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" -lt 1 2>/dev/null ]; then
            display_error "183" 1
          else
            BRDEXEC_HOSTLIST_SELECT_ID="${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
            BRDEXEC_HOSTLIST_CHOSEN_ITEM="$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | awk -v field="$BRDEXEC_HOSTLIST_CHOSEN_ITEM" '{print $field}')"
            brdexec_display_output "${BRDEXEC_HOSTLIST_SELECT_ID}) ${BRDEXEC_HOSTLIST_CHOSEN_ITEM} was selected\n" 255
          fi

          BRDEXEC_SERVERLIST_CHOSEN="${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
          BRDEXEC_SELECTED_PARAMETERS_INFO="${BRDEXEC_SELECTED_PARAMETERS_INFO} -h ${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"

          ### run selection of filter
          brdexec_select_hosts_filter ${BRDEXEC_SERVERLIST_CHOSEN}

          ### in case you want to select multiple filters
          ### not implemented, time will tell if needed
          ### leave as placeholder for future use

        fi
      fi
      ### display error when hostsfile is invalid
      if [ ! -f "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
        display_error "184" 1
      fi
      PS3=''
    ;;
    check_and_generate_hosts_file)
      if [ -f "${BRDEXEC_DEFAULT_HOSTS_FOLDER}/hosts" ]; then
        cat "${BRDEXEC_DEFAULT_HOSTS_FOLDER}/hosts" >> ${BRDEXEC_HOSTS_FILE}
      fi
      if [ -f "default/hosts/hosts" ]; then
        cat default/hosts/hosts >> ${BRDEXEC_HOSTS_FILE}
      fi
    ;;
  esac
}

#19
brdexec_scripts () {

  case ${1} in
    init_default_scripts_folder)
      if [ -z "${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}" ]; then
        BRDEXEC_DEFAULT_SCRIPTS_FOLDER=scripts
      fi ;;
    check_script_file_from_parameter_input)
      if [ "$1" = "" ] 2>/dev/null || [ -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
        if [ -z "${BRDEXEC_COPY_FILE}" ]; then
          BRDEXEC_DEFINED_OPTION_START="yes"
        fi
      fi
      ### check script input via -s for validity and override script selection
      if [ ! -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
        if [ -f "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
          ### check if relative or absolute path entered is valid, if not assume script is in scripts folder
          BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_INPUT_SCRIPT_PATH}"
        elif [ -f "${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
          BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_INPUT_SCRIPT_PATH}"
        elif [ -f "${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
          BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_DEFAULT_SCRIPTS_FOLDER}/${BRDEXEC_INPUT_SCRIPT_PATH}"
        fi
        ### verify script signature
        brdexec_verify_script_signature "${BRDEXEC_SCRIPT_TO_RUN}"
      fi
    ;;
  esac
}

#200
brdexec_first_verbose_init () {

  ### setting up logging
  if [ -z "${BRDEXEC_LOG_PATH}" ]; then
    BRDEXEC_LOG_PATH=./logs
  fi
  if [ ! -d "${BRDEXEC_LOG_PATH}" ]; then
    mkdir "${BRDEXEC_LOG_PATH}" || display_error "200" 1
  fi
  BRDEXEC_LOG_LAST_RUN="${BRDEXEC_LOG_PATH}/brdexec_last_run.log"
  BRDEXEC_LOG_CHECK_UPDATES="${BRDEXEC_LOG_PATH}/brdexec_check_updates.log"

  ### reset last run logfile
  > ${BRDEXEC_LOG_LAST_RUN} || display_error "201" 1
  ### set defaul loglevel
  if [ -z "${LOG_LEVEL}" ] || [ "${LOG_LEVEL}" -lt 0 2>/dev/null ] || [ "${LOG_LEVEL}" -gt 2 2>/dev/null ] || [ ! "${LOG_LEVEL}" -eq "${LOG_LEVEL}" 2>/dev/null ]; then
  #   missing                  negative                                too big                                 not number
    LOG_LEVEL=1
  fi
  ### set logfile
  LOG_FILE="${BRDEXEC_LOG_PATH}/broadexec.log"

  ### Verbosity mania; way to be verbose before you know it the right way via getopts... do you have more elegant way?
  VERBOSE="no"
  ### setting default verbosity level
  VERBOSITY_LEVEL=1
  ### checking for -v parameters before getopts
  for BRDEXEC_INPUT_ITEM in ${@}; do
    if [ "${BRDEXEC_INPUT_ITEM}" = "-v" 2>/dev/null ] || [ "${BRDEXEC_INPUT_ITEM}" = "-vv" 2>/dev/null ] || [ "${BRDEXEC_INPUT_ITEM}" = "-vvv" 2>/dev/null ]; then
      VERBOSE="yes"; verbose 200 1
    fi
  done
  ### getting verbosity level
  if [ "$#" -ne 0 ]; then
    for PARAMETER in "${@}"; do
      if [ "${PARAMETER}" = "-vv" 2>/dev/null ]; then
        VERBOSITY_LEVEL=2
      fi
      if [ "${PARAMETER}" = "-vvv" 2>/dev/null ]; then
        VERBOSITY_LEVEL=3
      fi
    done
  fi
}

#201
brdexec_getopts_main () { verbose -s "brdexec_getopts_main ${@}"

  ### display help when no parameter is present
  if [ "${#}" -ne 0 ]; then

    ### backup all parameters for later
    BRDEXEC_PARAMETERS_BACKUP="${@}"

    ### custom getopts solution
    while true; do
      case ${1} in

        -v | -vv | -vvv | --verbose) shift
          case ${1} in
            -* | "")
              VERBOSE="yes" ;;
            *)
              display_error 214 2 ;;
          esac ;;

        -s | --script) shift
          case ${1} in
            -* | "") ;;
            *)
              if [ -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
                if [ -e "${1}" ]; then
                  BRDEXEC_INPUT_SCRIPT_PATH="${1}"
                  verbose 210 1
                else
                  display_error 2105 1
                fi
              else
                display_error 2104 1
              fi
              shift ;;
          esac ;;

        -f | --filter) shift
          case ${1} in
            -* | "") ;;
            *)
              ### enabling multiple filters at once
              if [ -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
                BRDEXEC_SERVERLIST_FILTER="${1}"
              else
                BRDEXEC_SERVERLIST_FILTER="${BRDEXEC_SERVERLIST_FILTER} ${1}"
              fi
              shift ;;
          esac ;;

        -q | -qq | --quiet) shift
          case ${1} in
            -* | "")
              BRDEXEC_QUIET_MODE="yes"; verbose 2102 1 ;;
            *)
              display_error 215 2 ;;
          esac ;;

        --external) shift
          case ${1} in
            -* | "")
              BRDEXEC_EXTERNAL="yes"; verbose 2103 1 ;;
            *)
              BRDEXEC_STATS_FILE="${1}"; shift ;;
          esac ;;

        --runid) shift
          case ${1} in
            -* | "")
              display_error 215 2 ;;
            *)
              BRDEXEC_EXTERNAL_RUNID="${1}"; shift ;;
          esac ;;

        -r | --report-path) shift
          case ${1} in
            -* | "") ;;
            *)
              BRDEXEC_REPORT_PATH="${OPTARG}"; verbose 2101 1; shift ;;
          esac ;;

        -e | --human-readable) shift
          case ${1} in
            -* | "")
              BRDEXEC_HUMAN_READABLE_OUTPUT=1 ;;
            *)
              display_error 216 2 ;;
          esac ;;

        -g | --grep) shift
          case ${1} in
            -* | "") ;;
            *)
              BRDEXEC_GREP_DISPLAY_ONLY_SERVERS="${1}"; shift ;;
          esac ;;

        -i | --case-insensitive) shift
          case ${1} in
            -* | "")
              BRDEXEC_GREP_DISPLAY_ONLY_SERVERS_INSENSITIVE="yes" ;;
            *)
              display_error 217 2 ;;
          esac ;;

        -u | --user) shift
          case ${1} in
            -* | "") ;;
            *)
              BRDEXEC_USER="${1}"; shift ;;
          esac ;;

        -a | --admin) shift
          case ${1} in
            -* | "")
              BRDEXEC_ADMIN_FUNCTIONS="yes" ;;
            *)
              brdexec_usage ;;
          esac ;;

        -h | --hostslist | -l | --list) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *)
              if [ -z "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
                BRDEXEC_SERVERLIST_CHOSEN="${1}"
                BRDEXEC_HOSTLIST_FROM_PARAMETER="yes"
                verbose 215 1
              else
                display_error 2103 1
              fi
              shift ;;
          esac ;;

        --exclude) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *)
              BRDEXEC_HOSTSLIST_EXCLUDE="${BRDEXEC_HOSTSLIST_EXCLUDE} ${1}"; shift ;;
          esac ;;

        -H | --hosts) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *)
              BRDEXEC_HOSTS="${BRDEXEC_HOSTS},${1}"; shift ;;
          esac ;;

        -c | --copy-file) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *)
              BRDEXEC_COPY_FILE="${1}"; shift ;;
          esac ;;

        -d | --destination) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *)
              BRDEXEC_COPY_DESTINATION="${1}"; shift ;;
          esac ;;

        -b | --batch) shift
          case ${1} in
            -* | "")
              BRDEXEC_BATCH_MODE="yes"; shift ;;
            *) ;;
          esac ;;

        --run-test-scenario) shift
          case ${1} in
            -* | "")
              echo "ERROR"; exit 1; shift ;;
            *)
              BRDEXEC_RUN_TEST_SCENARIO="yes"
              TESTING_SCENARIO_FILE="${1}"; shift ;;
          esac ;;

        --version)
              if [ ! -z "${BRDEXEC_VERSION}" ]; then
                echo "Broadexec version: ${BRDEXEC_VERSION}"
              else
                >&2 echo "ERROR: Unable to get Broadexec version."
                exit 1
              fi; exit 0 ;;

        --update) shift
          case ${1} in
            -* | "")
              BRDEXEC_RUN_UPDATE="yes"; shift ;;
            *) ;;
          esac ;;

        -? | --help) shift
          case ${1} in
            -* | "")
              brdexec_usage ;;
            *) ;;
          esac ;;

        -*) >&2 echo "Unrecognized option ${1}"; brdexec_usage; break ;;
        *)
          break ;;
      esac
    done

    ### restoring original parameters
    set -$- -- ${BRDEXEC_PARAMETERS_BACKUP}
  fi

  ### set very quiet mode
  for BRDEXEC_INPUT_ITEM in ${@}; do
    if [ "${BRDEXEC_INPUT_ITEM}" = "-qq" 2>/dev/null ]; then
      BRDEXEC_VERY_QUIET_MODE="yes"
    fi
  done
}

#204
brdexec_variables_init () { verbose -s "brdexec_variables_init ${@}"

  ### initiation of stats functionality by calling special broadexec run for this
  ### create stats files dir
  if [ ! -d "${BRDEXEC_LOG_PATH}/stats" ]; then
    mkdir ${BRDEXEC_LOG_PATH}/stats || display_error "21000" 0
  fi

  ### if file does not exist, this is external invocation, if it does, this is background run
  if [ -f "${BRDEXEC_STATS_FILE}" ]; then
    BRDEXEC_EXTERNAL_RUN="yes"
  else
    BRDEXEC_STATS_FILE="${BRDEXEC_LOG_PATH}/stats/${RUNID}.stats"
    touch ${BRDEXEC_STATS_FILE} || display_error "21001" 0
    ### write init state to stats file
    echo "STATE INIT" > ${BRDEXEC_STATS_FILE}
    echo "PROGRESS NULL NULL NULL NULL" >> ${BRDEXEC_STATS_FILE}
  fi

  ### set total progress init value
  BRDEXEC_STATS_PROGRESS_TOTAL=0

  ### display path to stats file and run special case of quiet broadexec with stats
  ### here first invocation ends before creating any temporary files
  if [ ! -z "${BRDEXEC_EXTERNAL}" ]; then
    echo "${BRDEXEC_STATS_FILE}"
    BRDEXEC_PARAMETERS_BACKUP="$(echo "${@}" | sed 's/--external//')"
    ./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP} --external ${BRDEXEC_STATS_FILE} --runid ${RUNID} -qq &
    exit
  fi

  ### reset runid in case it is provided via option
  BRDEXEC_RUNID="${BRDEXEC_EXTERNAL_RUNID}"


  ### check if user is loaded with config file or parameter
  if [ -z "${BRDEXEC_USER}" ] || [ "${BRDEXEC_USER}" = "" 2>/dev/null ]; then
    display_error 243 1
  fi

  ### check if there is SSH key specified and if it exists
  if [ ! -z "${BRDEXEC_USER_SSH_KEY}" ]; then
    if [ -s "${BRDEXEC_USER_SSH_KEY}" ]; then
      BRDEXEC_USER_SSH_KEY=" -i ${BRDEXEC_USER_SSH_KEY}"
    else
      unset BRDEXEC_USER_SSH_KEY
    fi
  fi

  ### check if hosts files path is loaded with config file, if not assume default
  brdexec_hosts init_default_hosts_folder

  ### check for hosts file in default directory and in team directory
  BRDEXEC_HOSTS_FILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_HOSTS_FILE}"
  brdexec_hosts check_and_generate_hosts_file

  ### skip hostsfile selection if hosts file is present via parameter
  brdexec_hosts check_hosts_file_from_parameter_input

  ### check if scripts path is loaded with config file, if not assume default
  brdexec_scripts init_default_scripts_folder
  ### check timeouts, if not loaded assume default
  if [ -z "${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ] || [ "${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -lt 1 2>/dev/null ] || [ "${BRDEXEC_SSH_CONNECTION_TIMEOUT}" = "${BRDEXEC_SSH_CONNECTION_TIMEOUT}" 2>/dev/null ]; then
    BRDEXEC_SSH_CONNECTION_TIMEOUT=10
  fi
  if [ -z "${BRDEXEC_SCRIPT_RUN_TIMEOUT}" ] || [ "${BRDEXEC_SCRIPT_RUN_TIMEOUT}" -lt 1 2>/dev/null ] || [ "${BRDEXEC_SCRIPT_RUN_TIMEOUT}" = "${BRDEXEC_SCRIPT_RUN_TIMEOUT}" 2>/dev/null ]; then
    BRDEXEC_SCRIPT_RUN_TIMEOUT=30
  fi
  if [ -z "${BRDEXEC_PROCESS_KILL_TIMEOUT}" ] || [ "${BRDEXEC_PROCESS_KILL_TIMEOUT}" -lt 0 2>/dev/null ] || [ "${BRDEXEC_PROCESS_KILL_TIMEOUT}" = "${BRDEXEC_PROCESS_KILL_TIMEOUT}" 2>/dev/null ]; then
    BRDEXEC_PROCESS_KILL_TIMEOUT=1
  fi

  ### check runshell settings
  if [ "${BRDEXEC_RUNSHELL}" = "sh" 2>/dev/null ] || [ "${BRDEXEC_RUNSHELL}" = "nosudo" 2>/dev/null ]; then
    BRDEXEC_RUNSHELL="sh -c"
  elif [ "${BRDEXEC_RUNSHELL}" = "sudo" 2>/dev/null ]; then
    BRDEXEC_RUNSHELL="sudo sh -c"
  elif [ "${BRDEXEC_RUNSHELL}" = "sudosu" 2>/dev/null ]; then
    BRDEXEC_RUNSHELL="sudo su - -c"
  else #default nosudo/sh
    BRDEXEC_RUNSHELL="sh -c"
  fi

  ### setting defaut value for error blacklist
  if [ -z "${BRDEXEC_ERROR_BLACKLIST_FILE}" ]; then
    if [ ! -z "${BRDEXEC_TEAM_CONFIG}" ]; then
      BRDEXEC_ERROR_BLACKLIST_FILE="./teamconfigs/${BRDEXEC_TEAM_CONFIG}/broadexec_error_blacklist.conf"
    fi
  fi

  ### setting default value for delimiter character between hostnames and gathered data
  if [ -z "${BRDEXEC_OUTPUT_HOSTNAME_DELIMITER}" ]; then
    BRDEXEC_OUTPUT_HOSTNAME_DELIMITER=" "
  fi

  ### setting reporting variables
  if [ "${BRDEXEC_REPORT_DISPLAY_ERRORS}" = "" 2>/dev/null ] || [ "${BRDEXEC_REPORT_DISPLAY_ERRORS}" != "no" 2>/dev/null ]; then
    BRDEXEC_REPORT_DISPLAY_ERRORS="yes"
  else
    BRDEXEC_REPORT_DISPLAY_ERRORS="no"
  fi
  if [ "${BRDEXEC_REPORT_PATH}" = "" >/dev/null ]; then
    if [ -d reports ]; then
      BRDEXEC_REPORT_PATH=reports
    else
      mkdir reports 2>/dev/null
      if [ "${?}" -eq 0 ]; then
	BRDEXEC_REPORT_PATH=reports
      else
	BRDEXEC_REPORT_PATH="$(pwd)"
      fi
    fi
  fi

  if [ ! -w "${BRDEXEC_REPORT_PATH}" ]; then
    display_error 242 1
  fi
  if [ -z "${BRDEXEC_HUMAN_READABLE_REPORT}" ] || [ "${BRDEXEC_HUMAN_READABLE_REPORT}" != "no" 2>/dev/null ]; then
    BRDEXEC_HUMAN_READABLE_REPORT=yes
  fi

  ### Loading default as defined option if no script parameter is selected
  brdexec_scripts check_script_file_from_parameter_input

  ### Create list of all temporary files to be cleaned up
  BRDEXEC_TEMP_FILES_LIST=""

  ### Create main broadexec error file
  BRDEXEC_MAIN_ERROR_CURLOG="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST+=" ${BRDEXEC_MAIN_ERROR_CURLOG}"

  ### trapping CRTL+C press
  if [ -z "${BRDEXEC_CTRLC_PROCESS_KILL_TIMEOUT}" ] || [ "${BRDEXEC_CTRLC_PROCESS_KILL_TIMEOUT}" -lt 0 ]; then
    BRDEXEC_CTRLC_PROCESS_KILL_TIMEOUT=2
  fi
  trap brdexec_interruption_ctrl_c SIGINT
}

#205
brdexec_temp_files () { verbose -s "brdexec_temp_files ${@}"

  ### create main temp files which names will be inserted into arrays with corresponding ssh PID
  ### once ssh session will be started
  if [ "${1}" = "create_exec" ]; then
    BRDEXEC_ERROR_LOGFILE_MESSAGE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
    BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_ERROR_LOGFILE_MESSAGE}"
    echo "${BRDEXEC_SERVER_NAME}" > ${BRDEXEC_ERROR_LOGFILE_MESSAGE}
    BRDEXEC_MAIN_RUN_OUTPUT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
    BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_MAIN_RUN_OUTPUT}"
    echo "${BRDEXEC_SERVER_NAME}" > ${BRDEXEC_MAIN_RUN_OUTPUT}

  ### create report temp files with corresponding names
  elif [ "${1}" = "create_report" ]; then
    if [ ! -z "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" ]; then
      BRDEXEC_REPORT_SCRIPT_NAME="$(echo "${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}" | awk -F "/" '{ print $NF }')"
    elif [ ! -z "${BRDEXEC_SCRIPT_TO_RUN}" ]; then
      BRDEXEC_REPORT_SCRIPT_NAME="$(echo "${BRDEXEC_SCRIPT_TO_RUN}"  | awk -F "/" '{ print $NF }' | sed -e 's/\//_/g')"
    else
      echo "ERROR while trying to get script name"
    fi
    BRDEXEC_REPORT_FILE="${BRDEXEC_REPORT_PATH}/broadexec_${BRDEXEC_REPORT_SCRIPT_NAME}_${BRDEXEC_START_TIME}.report"
    BRDEXEC_REPORT_ERROR_FILE="${BRDEXEC_REPORT_PATH}/broadexec_${BRDEXEC_REPORT_SCRIPT_NAME}_${BRDEXEC_START_TIME}.report_error"
    ### in case -g parameter is used additional list report will be created
    if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
      BRDEXEC_REPORT_FILE_LIST="${BRDEXEC_REPORT_FILE}_list"
      > ${BRDEXEC_REPORT_FILE_LIST}
    fi
    > ${BRDEXEC_REPORT_FILE}
    > ${BRDEXEC_REPORT_ERROR_FILE}

    ### display report paths for external runs
    if [ ! -z "${BRDEXEC_EXTERNAL_RUNID}" ]; then
      echo "REPORT_FILE ${BRDEXEC_REPORT_FILE}"
      echo "REPORT_ERROR ${BRDEXEC_REPORT_ERROR_FILE}"
    fi

  ### removal is run in loop outside this function based on which PID already finished
  elif [ "${1}" = "remove_main_output" ]; then
    [ -f "${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}" ] && rm ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}
  elif [ "${1}" = "remove_error_output" ]; then
    [ -f "${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}" ] && rm ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}
  elif [ "${1}" = "remove_temp_files" ]; then
    if [ ! -z "${BRDEXEC_TEMP_FILES_LIST}" ]; then
      for BRDEXEC_TEMP_FILE in ${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_HOSTS_FILE}; do
        if [ -f "${BRDEXEC_TEMP_FILE}" ]; then
          rm ${BRDEXEC_TEMP_FILE} 2>/dev/null
        fi
      done
    fi

  ### remove ssh temp files for now just placeholder FIXME
  elif [ "${1}" = "remove_ssh_temp_files" ]; then
    echo "ERROR?" > /dev/null
  fi
}

#206
brdexec_display_output_until_timeout () { verbose -s "brdexec_display_output_until_timeout ${@}"

  ### let's initialize death counter and count total number of running pids
  local BRDEXEC_DEATH_COUNTER="$(expr $(date +%s) - ${BRDEXEC_SCRIPT_RUN_TIMEOUT})"
  local BRDEXEC_SSH_PID_TOTAL_COUNT="$(echo ${BRDEXEC_SSH_PIDS}) | wc -w)"

  ### assume worst, hope for the best :)
  BRDEXEC_MAIN_RUN_TIMEOUTED="yes"

  ### looping answers from servers until timeout
  while [ "${BRDEXEC_DEATH_COUNTER}" -lt "${BRDEXEC_START_TIME}" ]; do

    ### setting death counter from this moment in time
    local BRDEXEC_DEATH_COUNTER="$(expr $(date +%s) - ${BRDEXEC_SCRIPT_RUN_TIMEOUT})"
    for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
      verbose 260 3
      BRDEXEC_SERVERNAME_DISPLAY="$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 | awk '{print $1}')"

      ### checking only not yet displayed outputs which are finished
      if [ "${BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]}" != "yes" ]; then
        ps -p ${BRDEXEC_SSH_PID} >/dev/null
        if [ "$?" -ne 0 ]; then
          BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]="yes"

          ### checking if there is empty output from server
          if [ ! -f "${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}" ] || [ ! -f "${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}" ]; then
            display_error "2060" 1
          fi
          if [ "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | wc -l)" -eq 1 2>/dev/null ]; then

            ### checking for ssh timeout error: Connection timed out
            if [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "Connection timed out")" -eq 1 ]; then
              BRDEXEC_CONNECTION_ERROR_LOG+=" ${BRDEXEC_SERVERNAME_DISPLAY}"
              if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
                echo "${BRDEXEC_SERVERNAME_DISPLAY} ERROR: ssh connection timeout occured." >> ${BRDEXEC_REPORT_FILE}
              fi

            ### solving issue of missing entries in ~/.ssh/known_hosts
            elif [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "No ECDSA host key is known for")" -eq 1 ]; then
              BRDEXEC_CONNECTION_ERROR_LOG+=" ${BRDEXEC_SERVERNAME_DISPLAY}"
              BRDEXEC_SSH_MISSING_KNOWN_HOSTS_ERROR_SERVERS+=" $(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 2 | tail -n 1 | awk '{print $1}')"

            ### solving all other kinds of login problems
            else
              BRDEXEC_CONNECTION_ERROR_LOG+=" ${BRDEXEC_SERVERNAME_DISPLAY}"
              if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
                echo "${BRDEXEC_SERVERNAME_DISPLAY} ERROR: server is not accessible at the moment or there was problem logging in." >> ${BRDEXEC_REPORT_FILE}
              fi
            fi

          ### solving cases of unsupported OS runs
          elif [ "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "BRD_UNSUPPORTED")" -gt 0 ]; then
          BRDEXEC_OS_UNSUPPORTED_HOSTS+=" $(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 2 | tail -n 1 | awk '{print $1}')"

          ### if there actually is something sensible to display, display it
          ### display function with "main" parameter is also logging output
          else

            ### update progress in stats file
            brdexec_update_stats -p 1

            if [ -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
              brdexec_display_output "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | tail -n +2)" main 255

            ### in case -g parameter is set, display only servers
            else
              if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS_INSENSITIVE}" ]; then
                if [ "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -ic "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}")" -gt 0 ]; then
                brdexec_display_output "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1)" main 255
                fi
                ### add host to list file
                cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 >> ${BRDEXEC_REPORT_FILE_LIST}
              else
                if [ "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}")" -gt 0 ]; then
                brdexec_display_output "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1)" main 255
                fi
                ### add host to list file
                cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 >> ${BRDEXEC_REPORT_FILE_LIST}
              fi
            fi
          fi
        fi
      fi
    done

    ### check if every pid has finished already to end this madness
    BRDEXEC_SSH_PID_TOTAL_COUNT="$(echo ${BRDEXEC_SSH_PIDS} | wc -w)"
    BRDEXEC_SSH_PID_TOTAL_FINISHED=0
    for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
      if [ "${BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]}" = "yes" ]; then
        ((BRDEXEC_SSH_PID_TOTAL_FINISHED++))
      fi
    done
    if [ "${BRDEXEC_SSH_PID_TOTAL_FINISHED}" -eq "${BRDEXEC_SSH_PID_TOTAL_COUNT}" ]; then
      BRDEXEC_DEATH_COUNTER=${BRDEXEC_START_TIME}
      BRDEXEC_MAIN_RUN_TIMEOUTED="no"

      ### set status in stats file to finished
      brdexec_update_stats -s FINISHED

      break
    fi

    ### easing demand for CPU in compatible way
    sleep 0.2 2>/dev/null || sleep 1

  ### end of while waiting for timeouts
  done
}

#207
brdexec_timeouted () { verbose -s "brdexec_timeouted ${@}"

  ### run only when there was some timeouted host
  if [ "${BRDEXEC_MAIN_RUN_TIMEOUTED}" = "yes" ]; then

    ### display warning when timeout is set to irrationally big number
    if [ "${BRDEXEC_SCRIPT_RUN_TIMEOUT}" -le "${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ]; then
      brdexec_display_output "\nWARNING: SSH timeout is configured to be equal or more than script timeout. This will cause servers with ssh timeout to be displayed as timeouted by script." 1
    fi

    for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
      if [ "${BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]}" != "yes" ]; then
        ### solving issue with catching ssh timeouts when ssh and script timeout is the same or ssh timeout is bigger
        if [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "Connection timed out")" -eq 1 ]; then
          if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
            brdexec_display_output "$(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 | awk '{print $1}') ERROR: ssh connection timeout occured." 1
          fi
          BRDEXEC_CONNECTION_ERROR_LOG+=" $(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 | awk '{print $1}')"
          BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]="yes"

        ### solving properly timeouted servers
        else
          BRDEXEC_MAIN_RUN_TIMEOUTED_SERVERS+=" $(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 | awk '{print $1}')"
          BRDEXEC_MAIN_OUTPUT_ALREADY_DISPLAYED_ARRAY[$BRDEXEC_SSH_PID]="yes"
        fi

        ### some trickery to silently kill remaining processes #FIXME move to more proper place?
        brdexec_ssh_pid kill
      fi
    done

    ### display and log what had timed out
    if [ ! -z "${BRDEXEC_MAIN_RUN_TIMEOUTED_SERVERS}" ]; then
      for BRDEXEC_TIMED_OUT_SERVER_ITEM in ${BRDEXEC_MAIN_RUN_TIMEOUTED_SERVERS}; do
        if [ "${BRDEXEC_REPORT_DISPLAY_ERRORS}" = "yes" ]; then
          if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
            echo "${BRDEXEC_TIMED_OUT_SERVER_ITEM} WARNING script execution was cancelled due to timeout" >> ${BRDEXEC_REPORT_FILE}
          fi
        fi
        brdexec_display_output "${BRDEXEC_TIMED_OUT_SERVER_ITEM} WARNING script execution was cancelled due to timeout" 1
      done
    fi
  fi

  ### set status in stats file to finished
  brdexec_update_stats -s FINISHED

  ### get list of servers which timeouted and kill didn't worked
  [ -z "${BRDEXEC_PROCESS_KILL_TIMEOUT}" ] && sleep 1 || sleep ${BRDEXEC_PROCESS_KILL_TIMEOUT} 2>/dev/null
  for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
    ps -p ${BRDEXEC_SSH_PID} >/dev/null 2>&1
    if [ "${?}" -eq 0 ]; then
      BRDEXEC_UNKILLABLE_PIDS+=" ${BRDEXEC_SSH_PID}"
    fi
  done

  ### display list of unkillable servers with pids
  if [ ! -z "${BRDEXEC_UNKILLABLE_PIDS}" ]; then
    echo "\nList of servers and pids which were not stopped in time after killing, please check:\n"
    for BRDEXEC_SSH_PID in ${BRDEXEC_UNKILLABLE_PIDS}; do
      BRDEXEC_UNKILLABLE_LIST+=" $(cat ${BRDEXEC_MAIN_RUN_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | head -n 1 | awk '{print $1}'):${BRDEXEC_SSH_PID}"
    done
    if [ ! -z "${BRDEXEC_UNKILLABLE_LIST}" ]; then
      echo "${BRDEXEC_UNKILLABLE_LIST}"
    fi
  fi
}

#208
brdexec_select_hosts_filter () { verbose -s "brdexec_select_hosts_filter ${@}"

  ### setting prompt
  PS3='Select host filter #> '

  ### for now selection works just for one so this condition is tested just once
  if [ -z "${BRDEXEC_SERVERLIST_FILTER}" ] || [ "${BRDEXEC_SELECT_ANOTHER_FILTER}" = "yes" ]; then

    ### reset another filter menu selection for multilevel filters
    unset BRDEXEC_SELECT_ANOTHER_FILTER

    ### check if there is second or more columns in selected hosts file on at leas one line
    BRDEXEC_HOSTS_FILTER_COLUMN_COUNT=1; BRDEXEC_COLUMN_EXISTS="yes"
    BRDEXEC_SERVERLIST_LOOP="$(cat ${BRDEXEC_SERVERLIST_CHOSEN} | grep -v ^# | sort | uniq | awk '{print $1}')"

    ### repeat while there are selectable fields in hostsfile
    while [ "${BRDEXEC_COLUMN_EXISTS}" = "yes" ] ; do

      ### create temporary filter hostslist
      BRDEXEC_TEMP_HOSTS_LIST="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
      BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_TEMP_HOSTS_LIST}"

      ### check this run for more columns
      unset -v BRDEXEC_HOSTS_FILTER_ITEM_EXIST
      for BRDEXEC_HOSTS_FILTER_ITEM in $(cat ${BRDEXEC_SERVERLIST_CHOSEN} | awk '{print NF}'); do
        if [ "${BRDEXEC_HOSTS_FILTER_ITEM}" -gt "${BRDEXEC_HOSTS_FILTER_COLUMN_COUNT}" ]; then
          BRDEXEC_HOSTS_FILTER_ITEM_EXIST="yes"
        fi
      done

      ### increment count for reuse of variable for awk
      ((BRDEXEC_HOSTS_FILTER_COLUMN_COUNT+=1))

      ### display menu in case there is something to filter
      if [ ! -z "${BRDEXEC_HOSTS_FILTER_ITEM_EXIST}" ]; then

        ### check and create select only based on previous selects to disregard all other unused lines in hosts file
        ### create temporary hosts list for checking and displaying filters
        if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
          BRDEXEC_SERVERLIST_FILTER_COUNT=$(echo "${BRDEXEC_SERVERLIST_FILTER}" | awk -F "." '{print NF}')
          BRDEXEC_SERVER_FILTER_OK="yes"

          ### stop in case broadexec made it this far without proper hostfile
          if [ ! -f "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
            display_error "2083" 1
          fi

          ### go through each host in hostslist
          for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
            ### reset column id for fresh host
            BRDEXEC_SERVERLIST_FILTER_COLUMN=1
            ### go through each filter item existing or already provided
            for BRDEXEC_SERVERLIST_FILTER_ITEM in $(echo "${BRDEXEC_SERVERLIST_FILTER}" | sed -e 's/\./\ /g'); do
              ### increment field number for checks starting with 2
              ((BRDEXEC_SERVERLIST_FILTER_COLUMN+=1))
              ### check and disregard this host from selection in case it does not match filter for this level
              if [ "$(cat ${BRDEXEC_SERVERLIST_CHOSEN} | grep -i ${BRDEXEC_SERVER} | head -n 1 | awk -v col="${BRDEXEC_SERVERLIST_FILTER_COLUMN}" '{print $col}')" != "${BRDEXEC_SERVERLIST_FILTER_ITEM}" ]; then
                BRDEXEC_SERVER_FILTER_OK="no"
              fi
            done ### end of checking filters for this host

            ### add whole hostsfile line with filters to temporary hostslist for further filter selection
            if [ "${BRDEXEC_SERVERLIST_FILTER_COLUMN}" -gt "${BRDEXEC_SERVERLIST_FILTER_COUNT}" ] && [ "${BRDEXEC_SERVER_FILTER_OK}" = "yes" ]; then
              echo "$(grep "${BRDEXEC_SERVER}" ${BRDEXEC_SERVERLIST_CHOSEN} | uniq | head -n 1)" >> ${BRDEXEC_TEMP_HOSTS_LIST}
            fi
          done

        ### use all hosts from hostfile for first run
        else
          cp ${BRDEXEC_SERVERLIST_CHOSEN} ${BRDEXEC_TEMP_HOSTS_LIST}
        fi

        ### create proper select filter list based on temporary hosts list of servers that match this level
        ### disregarding invalid options
        BRDEXEC_HOSTS_FILTER_LIST="ALL"
        while read BRDEXEC_SERVERLIST_CHOSEN_LINE; do
          for BRDEXEC_SERVER in $( awk '{print $1}' ${BRDEXEC_TEMP_HOSTS_LIST}); do
            if [ "$(echo "${BRDEXEC_SERVERLIST_CHOSEN_LINE}" | grep "^${BRDEXEC_SERVER}" | awk -v col="${BRDEXEC_HOSTS_FILTER_COLUMN_COUNT}" '{print $col}')" != "" ]; then
              BRDEXEC_HOSTS_FILTER_LIST="${BRDEXEC_HOSTS_FILTER_LIST} $(echo "${BRDEXEC_SERVERLIST_CHOSEN_LINE}" | grep "^${BRDEXEC_SERVER}" | awk -v col="${BRDEXEC_HOSTS_FILTER_COLUMN_COUNT}" '{print $col}')"
            fi
          done
        done < ${BRDEXEC_SERVERLIST_CHOSEN}

        ### reset and save of temporary hostslist
        if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
          BRDEXEC_ANOTHER_TEMP_HOSTS_LIST="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
          BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST}"
          cp ${BRDEXEC_TEMP_HOSTS_LIST} ${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST}
          > ${BRDEXEC_TEMP_HOSTS_LIST}

          ### go back one instance and check current filter
          ((BRDEXEC_HOSTS_FILTER_COLUMN_COUNT-=1))
          while read BRDEXEC_ANOTHER_TEMP_HOSTS_LIST_LINE; do
            if [ "$(echo "${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST_LINE}" | awk -v col="${BRDEXEC_HOSTS_FILTER_COLUMN_COUNT}" '{print $col}')" = "$(echo "${BRDEXEC_SERVERLIST_FILTER}" | awk -F "." '{print $NF}')" ]; then
              echo "${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST_LINE}" >> ${BRDEXEC_TEMP_HOSTS_LIST}
            fi
          done < ${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST}
          ((BRDEXEC_HOSTS_FILTER_COLUMN_COUNT+=1))
        fi

        ### create new menu selection
        BRDEXEC_HOSTS_FILTER_LIST="ALL $(cat ${BRDEXEC_TEMP_HOSTS_LIST} | awk -v col="${BRDEXEC_HOSTS_FILTER_COLUMN_COUNT}" '{print $col}' | sort -u)"

        ### if ALL option is selected, stop traversing more
        if [ "${BRDEXEC_HOSTS_FILTER_SELECT_ITEM}" = "ALL" 2>/dev/null ]; then
          BRDEXEC_COLUMN_EXISTS="no"

        ### if this is first run or some other filter was selected and
        ### there is something to choose, display menu
        else
          if [ "${BRDEXEC_COLUMN_EXISTS}" != "no" ] && [ "$(echo "${BRDEXEC_HOSTS_FILTER_LIST}" | wc -w)" -gt 1 ]; then
            ### Exit in batch mode
            if [ "${BRDEXEC_BATCH_MODE}" = "yes" ]; then
              display_error "2082" 1
            fi
            select BRDEXEC_HOSTS_FILTER_SELECT_ITEM in ${BRDEXEC_HOSTS_FILTER_LIST}
            do
              ### check for invalid inputs
              if [ "$(echo "${BRDEXEC_HOSTS_FILTER_LIST}" | wc -w)" -lt "${REPLY}" ] 2>/dev/null; then
                display_error "2081" 1
              fi
              if ! [ "${REPLY}" -eq "${REPLY}" ] 2>/dev/null; then
                display_error "2081" 1
              fi
              brdexec_display_output "${BRDEXEC_HOSTS_FILTER_SELECT_ITEM} was selected\n" 255
              break
            done
          fi

          ### update filter value depending on chosen one and
          ### if it is first multifilter or not
          if [ "${BRDEXEC_HOSTS_FILTER_SELECT_ITEM}" != "ALL" 2>/dev/null ] && [ "${BRDEXEC_COLUMN_EXISTS}" != "no" ] && [ "$(echo "${BRDEXEC_HOSTS_FILTER_LIST}" | wc -w)" -gt 1 ]; then
            if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
              BRDEXEC_SERVERLIST_FILTER="${BRDEXEC_SERVERLIST_FILTER}.${BRDEXEC_HOSTS_FILTER_SELECT_ITEM}"
            else
              BRDEXEC_SERVERLIST_FILTER="${BRDEXEC_HOSTS_FILTER_SELECT_ITEM}"
            fi
          fi
        fi

      ### stop checking if there is nothing to filter
      else
        BRDEXEC_COLUMN_EXISTS="no"
      fi
    done
  fi

  ### remove temp hostsfiles, it is over now, chill
  rm ${BRDEXEC_TEMP_HOSTS_LIST} ${BRDEXEC_ANOTHER_TEMP_HOSTS_LIST} 2>/dev/null

  ### update parameter info line
  if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
    BRDEXEC_SELECTED_PARAMETERS_INFO="${BRDEXEC_SELECTED_PARAMETERS_INFO} -f ${BRDEXEC_SERVERLIST_FILTER}"
    brdexec_display_output "If you wish to select more than one filter see usage of multiple -f parameters in documentation\n" 255
  fi
}

#209
brdexec_create_hosts_list_based_on_filter () { verbose -s "brdexec_create_hosts_list_based_on_filter ${@}"

  ### making sure serverist is unique
  BRDEXEC_SERVERLIST_LOOP="$(cat ${BRDEXEC_SERVERLIST_CHOSEN} | grep -v ^# | sort | uniq | awk '{print $1}')"

  ### create filter based on -f parameter
  if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ]; then
    BRDEXEC_SERVERLIST_FILTERED="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
    BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_SERVERLIST_FILTERED}"

    ### count how many -f parameters were entered
    BRDEXEC_SERVERLIST_FILTER_PHRASES_COUNT=$(echo "${BRDEXEC_SERVERLIST_FILTER}" | awk -F " " '{print NF}')

    ### run filtering for each one
    for BRDEXEC_SERVERLIST_FILTER_PHRASE in ${BRDEXEC_SERVERLIST_FILTER}; do
      brdexec_create_temporary_hosts_list_based_on_filter ${BRDEXEC_SERVERLIST_FILTER_PHRASE}
    done
    BRDEXEC_SERVERLIST_CHOSEN="${BRDEXEC_SERVERLIST_FILTERED}"
    BRDEXEC_SERVERLIST_LOOP="$(cat ${BRDEXEC_SERVERLIST_FILTERED})"
  fi
}

#211
brdexec_create_temporary_hosts_list_based_on_filter () { verbose -s "brdexec_create_temporary_hosts_list_based_on_filter ${@}"

  BRDEXEC_SERVERLIST_FILTER_COUNT=$(echo "${BRDEXEC_SERVERLIST_FILTER_PHRASE}" | awk -F "." '{print NF}')
  for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
    ### check for multiple filter words
    BRDEXEC_SERVERLIST_FILTER_COLUMN=1
    BRDEXEC_SERVER_FILTER_OK="yes"

    ### loop one filter word for one column
    for BRDEXEC_SERVERLIST_FILTER_ITEM in $(echo "${BRDEXEC_SERVERLIST_FILTER_PHRASE}" | sed -e 's/\./\ /g'); do
      ((BRDEXEC_SERVERLIST_FILTER_COLUMN+=1))
      if [ "$(cat ${BRDEXEC_SERVERLIST_CHOSEN} | grep -i ${BRDEXEC_SERVER} | head -n 1 | awk -v col="${BRDEXEC_SERVERLIST_FILTER_COLUMN}" '{print $col}')" != "${BRDEXEC_SERVERLIST_FILTER_ITEM}" ]; then
        BRDEXEC_SERVER_FILTER_OK="no"
      fi
    done

    ### if passed, add server to filtered hostslist
    if [ "${BRDEXEC_SERVERLIST_FILTER_COLUMN}" -gt "${BRDEXEC_SERVERLIST_FILTER_COUNT}" ]; then
      if [ "${BRDEXEC_SERVER_FILTER_OK}" = "yes" ]; then
        echo "${BRDEXEC_SERVER}" >> ${BRDEXEC_SERVERLIST_FILTERED}
      fi
    fi
  done

  ### check if filter is not creating empty list
  if [ "$(cat ${BRDEXEC_SERVERLIST_FILTERED} | wc -l)" -eq 0 ]; then
    rm ${BRDEXEC_SERVERLIST_FILTERED} 2>/dev/null
    display_error "110" 1
  fi

  ### getting rid of duplicates and saving temp list to be used
  BRDEXEC_TMP_LIST="$(cat ${BRDEXEC_SERVERLIST_FILTERED} | sort -u)"
  echo "${BRDEXEC_TMP_LIST}" > ${BRDEXEC_SERVERLIST_FILTERED}
}

#212
brdexec_make_temporary_script () {

  BRDEXEC_TMP_SCRIPT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_TMP_SCRIPT}"

  if [ -f "${1}" ]; then
    ### load first line of script ahead
    head -n 1 ${1} > ${BRDEXEC_TMP_SCRIPT}

    ### tell script that it is being run by broadexec
    echo "BRDEXEC_RUNBY=true" >> ${BRDEXEC_TMP_SCRIPT}

    ### include osrelease library only in case script specifies support level FIXME
    cat lib/osrelease_lib.sh >> ${BRDEXEC_TMP_SCRIPT}
    ### include rest of the script for now ignoring including check function on the right line
    if [ -f "${BRDEXEC_SCRIPT_EMBEDED}" ]; then
      rm ${BRDEXEC_TMP_SCRIPT} 2>/dev/null
      BRDEXEC_TMP_SCRIPT="${BRDEXEC_SCRIPT_EMBEDED}"
    else
      tail -n +2 ${1} >> ${BRDEXEC_TMP_SCRIPT}
    fi
    ### check OS check activation
    if [ "$(grep -v ^# ${BRDEXEC_TMP_SCRIPT} | grep -v 'osrelease_check () {' |  grep -c osrelease_check)" -eq 0 ] && [ "$(grep -v ^# ${BRDEXEC_TMP_SCRIPT} | grep -c ^BRDEXEC_SUPPORTED_)" -gt 0 ]; then
      display_error "2121" 1
    fi

    ### check embeded variables and discard invalid ones
    BRDEXEC_SCRIPT_EMBEDED="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
    BRDEXEC_TEMP_FILES_LIST+=" ${BRDEXEC_SCRIPT_EMBEDED}"
    while read BRDEXEC_SCRIPT_EMBEDED_LINE
    do
      if [ "$(echo "${BRDEXEC_SCRIPT_EMBEDED_LINE}" | grep -c ^BRDEXEC_)" -eq 1 ]; then
        while read BRDEXEC_SCRIPT_SUPPORTED_VARIABLE
        do
          if [ "$(echo "${BRDEXEC_SCRIPT_EMBEDED_LINE}" | awk -F "=" '{print $1}')" = "$(echo "${BRDEXEC_SCRIPT_SUPPORTED_VARIABLE}" | awk -F "=" '{print $1}')" ]; then
            echo "${BRDEXEC_SCRIPT_EMBEDED_LINE}" > ${BRDEXEC_SCRIPT_EMBEDED}
            . ${BRDEXEC_SCRIPT_EMBEDED}
          fi
        done < ./etc/enhanced_script_supported_variables.db
      fi
    done < ${BRDEXEC_TMP_SCRIPT}
    rm ${BRDEXEC_SCRIPT_EMBEDED}
  else
    display_error "2120" 1
  fi
}

#213
brdexec_verify_script_signature () {


	#TODO enable gpg verification based on different gpg versions
	return 0
  ### check script file signature
    ### check for custom hash
    BRDEXEC_SCRIPT_CUSTOM_HASH="$(grep ^#hsh ${1} | awk '{print $2}')"
    BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED="no"
    if [ -f etc/hush ]; then
      while read BRDEXEC_SCRIPT_CUSTOM_HASH_ITEM
      do
        if [ "$(echo "${BRDEXEC_SCRIPT_CUSTOM_HASH_ITEM}" | grep ^hsh | awk '{print $2}')" = "${BRDEXEC_SCRIPT_CUSTOM_HASH}" ]; then
          if [ "${BRDEXEC_SCRIPT_CUSTOM_HASH}" != "" 2>/dev/null ]; then
            BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED=yes
          fi
        fi
      done < etc/hush
      if [ "${BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED}" = "no" ]; then
        gpg --verify "${1}.asc" "${1}" 2>/dev/null
        if [ "$?" -ne 0 ]; then
          display_error "113" 1
        fi
	limit_file_size -m 1 etc/hush
        BRDEXEC_SCRIPT_SIGNATURE_ID="$(gpg --verify "${1}.asc" "${1}" 2>&1 | grep ID | awk -F " key ID " '{print $2}')"
        if [ ! -z "${BRDEXEC_SCRIPT_SIGNATURE_ID}" ]; then
          if [ "$(grep "^gpg " etc/hush | grep -c "${BRDEXEC_SCRIPT_SIGNATURE_ID}")" -eq 0 ]; then
            display_error "114" 1
          fi
        else
          display_error "114" 1
        fi
      fi
    else
      display_error "114" 1
    fi
}

#214
brdexec_check_for_conflicting_inputs () {

  verbose 217 2

  ### in case you have filter but no hostslist
  if [ ! -z "${BRDEXEC_SERVERLIST_FILTER}" ] && [ -z "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
    if [ -z "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ] || [ ! -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
      display_error "211" 1
    fi
  fi

  ### check for conflicts of selecting hostlists and manual selection via -H
  if [ ! -z "${BRDEXEC_HOSTS}" ] && [ ! -z "${BRDEXEC_SERVERLIST_CHOSEN}" ]; then
    display_error "2101" 1
  fi

  ### check conflicts for human readable and grep display
  if [ ! -z "${BRDEXEC_HUMAN_READABLE_OUTPUT}" ] && [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
    display_error "210" 1
  fi

  ### check for -i parameter without -g parameter
  if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS_INSENSITIVE}" ] && [ -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
    display_error "210" 1
  fi
  verbose 219 2

  ### check for conflicts with file copy operation
  if [ ! -z "${BRDEXEC_COPY_DESTINATION}" ] && [ -z "${BRDEXEC_COPY_FILE}" ]; then
    display_error "218" 1
  fi
  if [ ! -z "${BRDEXEC_COPY_FILE}" ] && [ ! -z "${BRDEXEC_ADMIN_FUNCTIONS}" ]; then
    display_error "219" 1
  fi
  if [ ! -z "${BRDEXEC_COPY_FILE}" ] && [ ! -z "${BRDEXEC_INPUT_SCRIPT_PATH}" ]; then
    display_error "2100" 1
  fi

  ### Check for conflicts with batch mode
  if [ ! -z "${BRDEXEC_BATCH_MODE}" ] && [ ! -z "${BRDEXEC_ADMIN_FUNCTIONS}" ]; then
    display_error "2102" 1
  fi
}

#300
display_error () {

  ### check for empty input :)
  if [ "$#" -lt 1 ]; then
    >&2 echo "ERROR: Error displaying error message."
    return 1
  fi

  ### reload errors library & setting defaults
  [ -f "./etc/display_error.db" ] && . ./etc/display_error.db
  ERROR_CODE=1

  ### if broadexec library is used, display error from database
  if [ "${1}" -eq "${1}" 2>/dev/null ]; then
    >&2 echo "ERROR [${1}] ${ERROR_MESSAGE[$1]}"
    log "ERROR [${1}] ${ERROR_MESSAGE[$1]}" 1
  ### display any other errors
  else
    >&2 echo "ERROR ${1}"
    log "${1}" 1
  fi

  ### write error into last run log
  script_specific "${SCRIPT_NAME}" "display_error" "write_last_run_log" "${1}"

  ### Check and reset error value if it is out of range
  local ERROR_CODE="${2}"
  if [ "${ERROR_CODE}" -lt 0 2>/dev/null ] || [ "${ERROR_CODE}" -gt 255 2>/dev/null ]; then
    local ERROR_CODE=1
  fi

  ### Main exit of script due to error
  if [ "${ERROR_CODE}" -ne 0 ]; then

    ### write error state to stats file for external reporting
    brdexec_update_stats -s ERROR

    ### if there is specific script with special exit procedure, run it
    if [ ! -z "${SCRIPT_NAME}" ]; then
      script_specific "${SCRIPT_NAME}" "display_error" "exit"
    fi
    exit ${ERROR_CODE}
  fi
}

#301
brdexec_usage () { verbose -s "brdexec_usage  ${@}"

  >&2 echo -e 'BROADEXEC HELP\n
When run without options, broadexec will display menu to choose hosts file, if present custom filters found in second column of customer hosts file and also script to run and execute it.
Available options:
  -h, --hostslist [HOSTS_FILE]
    Only supported hosts files are located in folder specified by BRDEXEC_DEFAULT_SCRIPTS_FOLDER variable in conf file. They can be 1 column lists with hostname or 2 column ones also with IP. When hosts file is with IP, IP will be used to connect throught ssh and hostname to display output and create reports.
  -H, --hosts [HOST1,HOST2,...]
    Do not use host lists, but use provided hosts. Multiple -H parameters are supported.
  -f, --filter [PHRASE]
    optional for -l parameter. Set filter word specified in second column of hosts file for each customer, eg prod, test etc. If filters are divided by comma they are used for third,fourth etc column.
  -s, --script [SCRIPT_FILE]
    Use any script to run. If it is specified without path, broadexec will search in folder speficied by BRDEXEC_DEFAULT_SCRIPTS_FOLDER variable in conf file.
  -e, --human-readable
    Use enhanced view in human readable format. Instead of 1 line per host output is displayed on multiple lines as it is provided from host with hostname on first line.
  -g, --grep [PHRASE]
    Behave sort of like grep. Instead of displaying whole output, broadexec will display just the hostnames of hosts were outputs contain PHRASE provided as argument to -g option.
  -i, --case-insensitive
    Only for use with -g parameter. When used case of PHRASE will be ignored by running grep -i.
  -r, --report-path [PATH]
    Override default path for storing report files for this run. Default can be found in BRDEXEC_REPORT_PATH variable in conf file.
  -c, --copy-file [FILE]
    Copy file to destination folder on selected hosts. Must be used with -d option.
  -d, --destination [PATH]
    Used only with -c option. Sets destination on remote hosts where to copy file. Only subfolders of /tmp and /home are allowed.
  -b, --batch
    Batch mode. Does not require any user interaction. In case user interaction is needed it will exit with error.
  -a, --admin
    Run admin mode with select menu to check logins, distribute ssh keys etc.
  -v, -vv, -vvv, --verbose
    Display verbose output. -v for just most important messages, -vv for more info and -vvv for almost everything.
  -q, qq, --quiet
    Quiet mode. -q display only main output, -qq display nothing, just write report.
  -h, --help, no parameter
    This output
'; exit 0
}

#302
verbose () {

  ### display this when wrong input
  if [ "$#" -lt 1 ]; then
    >&2 echo "   VERBOSE: Error displaying verbose output."
    return 1
  fi

  ### if only number is given assume loading message from library
  if [ "${1}" -eq "${1}" ] 2>/dev/null; then
    ### checking verbosity level
    if [ "$#" -eq 2 ]; then
      if [ "${2}" -le "${VERBOSITY_LEVEL}" ]; then
        ### load message from library
        [ -f "./etc/verbose.db" ] && . ./etc/verbose.db
        if [ "${VERBOSE}" = "yes" ]; then
          echo "   VERBOSE[${1}]: ${VERBOSE_MESSAGE[$1]}"
        fi
      fi
      script_specific "${SCRIPT_NAME}" "verbose" "write_last_run_log" "${1}"
    fi
  ### if -s is given as parameter display default function start message
  elif [ "${1}" = "-s" ]; then
    if [ "${VERBOSE}" = "yes" ]; then
      echo "   VERBOSE: Function ${2} START"
    fi
    if [ ! -z "${SCRIPT_NAME}" ]; then
      script_specific "${SCRIPT_NAME}" "verbose" "write_last_run_log_start"  "${2}"
    fi
  else
    ### if special verbose id or verbose parameters are not used, just write plain everything passed to verbose function
    if [ "${VERBOSE}" = "yes" ]; then
      echo "${@}"
    fi
    if [ ! -z "${SCRIPT_NAME}" ]; then
      script_specific "${SCRIPT_NAME}" "verbose" "write_anything_other" "${@}"
    fi
  fi
}

#303
brdexec_generate_error_log () { verbose -s "brdexec_generate_error_log ${@}"

  ### filter error output by removing lines with blacklisted errors
  if [ -f "${BRDEXEC_ERROR_BLACKLIST_FILE}" ]; then
    if [ "$(cat "${BRDEXEC_ERROR_BLACKLIST_FILE}" | wc -l)" -ne 0 ]; then
      while read BRDEXEC_ERROR_BLACKLIST_LINE; do

        ### discard commented out lines
        if [ "$(echo "${BRDEXEC_ERROR_BLACKLIST_LINE}" | grep -c '^#')" -eq 0 ]; then
          for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do

            ### We don't want to do filtering on runs without errors, saves time you know
            if [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | wc -l)" -gt 1 ]; then
              if [ "$(grep -c "${BRDEXEC_ERROR_BLACKLIST_LINE}" ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]})" -gt 0 ]; then

              ### if error line contains blacklisted phrase it will get deleted; because of mv there is no need to rm temp file
              BRDEXEC_ERROR_BLACKLIST_TEMP="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
              BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_ERROR_BLACKLIST_TEMP}"
              grep -v "${BRDEXEC_ERROR_BLACKLIST_LINE}" ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} > ${BRDEXEC_ERROR_BLACKLIST_TEMP} && mv ${BRDEXEC_ERROR_BLACKLIST_TEMP} ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}
              fi
            fi
          done
        fi
      done < ${BRDEXEC_ERROR_BLACKLIST_FILE}
    fi
  fi

  ### Generate error log from temporary files and do cleanup
  verbose 330 1
  for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do

    ### do stuff when there is some error
    verbose 331 2
    if [ -f "${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}" ]; then
      if [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | wc -l)" -gt 1 ]; then

        ### if ssh knownhost not added, display special error
        if [ "$(cat ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | grep -c "No ECDSA host key is known for")" -eq 1 ]; then
          echo "$(head -n 1 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}) ssh: No ECDSA host key is known for server and you have requested strict checking. Host key verification failed." >> ${BRDEXEC_MAIN_ERROR_CURLOG}

        ### catch all other errors
        else
          echo "$(head -n 1 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}) $(tail -n +2 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | perl -pe 's/\r?\n/,/')" >> ${BRDEXEC_MAIN_ERROR_CURLOG}
          if [ -f "${BRDEXEC_REPORT_ERROR_FILE}" ]; then
            if [ "${BRDEXEC_HUMAN_READABLE_REPORT}" = "yes" ]; then
              echo "$(head -n 1 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}) $(tail -n +2 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]})" >> ${BRDEXEC_REPORT_ERROR_FILE}
            else
              echo "$(head -n 1 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]}) $(tail -n +2 ${BRDEXEC_ERROR_OUTPUT_ARRAY[$BRDEXEC_SSH_PID]} | perl -pe 's/\r?\n/,/')" >> ${BRDEXEC_REPORT_ERROR_FILE}
            fi
          fi
        fi
      fi
    fi

    ### remove error files
    brdexec_temp_files remove_error_output
  done
}

#304
brdexec_display_error_log () { verbose -s "brdexec_display_error_log ${@}"

  ### Display error log and clear it
  if [ "${BRDEXEC_CONNECTION_ERROR_LOG}" != "" ] 2>/dev/null; then
    brdexec_display_output "\n List of servers with connection or log in problem:${BRDEXEC_CONNECTION_ERROR_LOG}" 255
  fi

  ### DIsplay unsupported OS hosts
  if [ "${BRDEXEC_OS_UNSUPPORTED_HOSTS}" != "" ] 2>/dev/null; then
    brdexec_display_output "\n List of hosts with unsupported OS version for this run:${BRDEXEC_OS_UNSUPPORTED_HOSTS}" 255
  fi

  ### when there are no errors in output
  if [ "$(cat ${BRDEXEC_MAIN_ERROR_CURLOG} 2>/dev/null | wc -l)" -eq 0 ]; then
    [ -f "${BRDEXEC_MAIN_ERROR_CURLOG}" ] && rm ${BRDEXEC_MAIN_ERROR_CURLOG}
    if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
      brdexec_display_output " Report has been saved in ${BRDEXEC_REPORT_FILE}" 255
    fi
    if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
      brdexec_display_output " Report list has been saved in ${BRDEXEC_REPORT_FILE_LIST}" 255
    fi

  ### when there are errors in output
  else
    brdexec_display_output " Errors collected during broadexec run:" 255
    if [ "${BRDEXEC_QUIET_MODE}" != "yes" ]; then
      awk ' NF>=2 {print $0} ' ${BRDEXEC_MAIN_ERROR_CURLOG} | sed -e 's/^/ /' && > ${BRDEXEC_MAIN_ERROR_CURLOG} || display_error 340 0
      awk ' NF>=2 {print $0} ' ${BRDEXEC_MAIN_ERROR_CURLOG} >> ${BRDEXEC_LOG_LAST_RUN}
    fi
    if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
      brdexec_display_output " Report has been saved in ${BRDEXEC_REPORT_FILE}" 255
    fi
    if [ ! -z "${BRDEXEC_GREP_DISPLAY_ONLY_SERVERS}" ]; then
      brdexec_display_output " Report list has been saved in ${BRDEXEC_REPORT_FILE_LIST}" 255
    fi

    ### display info about error report file
    if [ -s "${BRDEXEC_REPORT_ERROR_FILE}" ]; then
      if [ "$(cat ${BRDEXEC_REPORT_ERROR_FILE} | wc -l)" -gt 0 ]; then
        brdexec_display_output " Error report has been saved in ${BRDEXEC_REPORT_ERROR_FILE}" 255
      else
        rm ${BRDEXEC_REPORT_ERROR_FILE} || echo " Error deleting ${BRDEXEC_REPORT_ERROR_FILE}"
      fi
    else
      if [ -f "${BRDEXEC_REPORT_ERROR_FILE}" ]; then
        rm ${BRDEXEC_REPORT_ERROR_FILE}
      fi
    fi
    [ -f "${BRDEXEC_MAIN_ERROR_CURLOG}" ] && rm ${BRDEXEC_MAIN_ERROR_CURLOG}
  fi
}

#305
brdexec_repair_missing_known_hosts () { verbose -s "brdexec_repair_missing_known_hosts ${@}"

  for BRDEXEX_MISSING_KNOWN_HOSTS_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do

    ### reset variabe for checking default hosts file
    unset BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME

    ### checking hostname against broadexec hosts file
    if [ "$(grep -ic "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER}" ${BRDEXEC_HOSTS_FILE} 2>/dev/null)" -gt 0 ] 2>/dev/null; then
      BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME="${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER}"
      BRDEXEX_MISSING_KNOWN_HOSTS_SERVER="$(grep -i "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER}" ${BRDEXEC_HOSTS_FILE} | head -n 1 | awk '{print $1}')"
    fi

    if [ "${1}" = "shout" ]; then
      brdexec_display_output "Checking host ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME}" 1
    fi

    ### checking if current host is missing from known hosts
    if [ "$(awk '{print $1}' ~/.ssh/known_hosts 2>/dev/null | grep -c ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER})" -eq 0 ]; then
      if [ "${1}" = "shout" ]; then
        brdexec_display_output "Executing keyscan on host ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME}" 1
      fi
      ssh-keyscan ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} >/dev/null 2>&1
      if [ "$?" -eq 0 ]; then

        ### adding keys to knownhosts
        brdexec_display_output "  Adding IP ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} of ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME} to ~/.ssh/known_hosts" 2
        ssh-keyscan ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} 2>/dev/null | head -n 1 >> ~/.ssh/known_hosts

        ### checking if it worked
        ssh -o "StrictHostKeyChecking=yes" -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} uptime 2>&1 >/dev/null
        if [ "$?" -ne 0 ]; then
          brdexec_display_output "After adding ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} to ~/.ssh/known_hosts there is still problem connecting to server. Please check manually." 1
        fi

        ### add also hostname with IP address
        if [ ! -z "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME}" ]; then
          if [ "$(grep -c ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ~/.ssh/known_hosts)" -gt 0 ]; then
            brdexec_display_output "  Adding hostname ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME} to ~/.ssh/known_hosts" 2
            BRDEXEX_MISSING_KNOWN_HOSTS_TEMP="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
            BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEX_MISSING_KNOWN_HOSTS_TEMP}"
            BRDEXEX_MISSING_KNOWN_HOSTS_LINE_NUMBER="$(grep -n ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ~/.ssh/known_hosts | head -n 1 | awk -F ":" '{print $1}')"

            ### I am very proud of the following line!
            awk -v linenumber="${BRDEXEX_MISSING_KNOWN_HOSTS_LINE_NUMBER}" -v hostname="${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME}" '{if(NR==linenumber){$1=$1","hostname; print}else{print}}' ~/.ssh/known_hosts > ${BRDEXEX_MISSING_KNOWN_HOSTS_TEMP} && mv ${BRDEXEX_MISSING_KNOWN_HOSTS_TEMP} ~/.ssh/known_hosts
          fi
        fi
      else
        log "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} problem getting fingerprint information" 1
        if [ "${1}" = "shout" ]; then
          brdexec_display_output "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME} problem getting fingerprint information" 1
        fi
      fi
    else
      if [ "${1}" = "shout" ]; then
        brdexec_display_output "${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER} ${BRDEXEX_MISSING_KNOWN_HOSTS_SERVER_NAME} OK"
      fi
    fi
  done
}

#306
brdexec_display_output () {

  ### set redirection to STDERR
  if [ "${2}" = "error" 2>/dev/null ] || [ "${3}" = "error" ] || [ "${4}" = "error" ]; then
    local BRDEXEC_DISPLAY_OUTPUT_TO_STDERR
    BRDEXEC_DISPLAY_OUTPUT_TO_STDERR=true
  fi

  ### manage oneliner when -e option is not present
  if [ "${2}" = "main" 2>/dev/null ]; then

    ### display main output
    if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
      if [ "${BRDEXEC_HUMAN_READABLE_OUTPUT}" != 1 2>/dev/null ]; then
        if [ "${BRDEXEC_VERY_QUIET_MODE}" != "yes" ]; then
          echo -e "${1}" | sed ':a;N;$!ba;s/\n/ /g' | awk -v BRDEXEC_OUTPUT_HOSTNAME_DELIMITER="${BRDEXEC_OUTPUT_HOSTNAME_DELIMITER}" '{
            if (NF>1) {
              ORS=BRDEXEC_OUTPUT_HOSTNAME_DELIMITER;
            }
            print $1;
            ORS=" ";
            for (i=2; i<=NF; i++) {
              if (i<NF) {
                ORS=" "
              } else {
                ORS="\n"
              }
              print $i
            }
            }'
        fi
        echo -e "${1}" | sed ':a;N;$!ba;s/\n/ /g' | awk -v BRDEXEC_OUTPUT_HOSTNAME_DELIMITER="${BRDEXEC_OUTPUT_HOSTNAME_DELIMITER}" '{
          if (NF>1) {
            ORS=BRDEXEC_OUTPUT_HOSTNAME_DELIMITER;
          }
          print $1;
          ORS=" ";
          for (i=2; i<=NF; i++) {
            if (i<NF) {
              ORS=" "
            } else {
              ORS="\n"
            }
            print $i
          }
          }' >> ${BRDEXEC_REPORT_FILE}
      else
        BRDEXEC_ENHANCED_HEADLINE="$(echo -e "${1}" | head -n 1)"
        if [ "${BRDEXEC_VERY_QUIET_MODE}" != "yes" ]; then
          echo -e "${BRDEXEC_ENHANCED_HEADLINE} -----------------"
          echo -e "${1}" | tail -n +2
        fi
        if [ -z "${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY}" ]; then
          if [ "${BRDEXEC_HUMAN_READABLE_REPORT}" = "yes" ]; then
            echo -e "${BRDEXEC_ENHANCED_HEADLINE} -----------------" >> ${BRDEXEC_REPORT_FILE}
            echo -e "${1}" | tail -n +2 >> ${BRDEXEC_REPORT_FILE}
          else
            echo -e "${1}" | sed ':a;N;$!ba;s/\n/ /g' | awk -v BRDEXEC_OUTPUT_HOSTNAME_DELIMITER="${BRDEXEC_OUTPUT_HOSTNAME_DELIMITER}" '{ORS=BRDEXEC_OUTPUT_HOSTNAME_DELIMITER;print $1;ORS=" ";for (i=2; i<=NF; i++) { if (i<NF) { ORS=" " } else { ORS="\n" } print $i } }' >> ${BRDEXEC_REPORT_FILE}
          fi
        fi
      fi
    else

      ### display admin output
      if [ "$(echo "${@}" | wc -l)" -lt 2 ]; then
        echo -ne "\nERROR: Problem with connectivity or sudo on ${BRDEXEC_SERVERNAME_DISPLAY}"
      else
        echo -ne ".\c"
      fi
    fi
  else

    ### do not display anything else than main output when -q option is present
    if [ "${BRDEXEC_QUIET_MODE}" != "yes" ]; then
      if [ "${BRDEXEC_DISPLAY_OUTPUT_TO_STDERR}" = "true" 2>/dev/null ]; then
        (>&2 echo -e "${1}")
      else
        echo -e "${1}"
      fi
    fi
  fi

  ### write last run log
  echo -e "${1}" | sed ':a;N;$!ba;s/\n/ /g' >> ${BRDEXEC_LOG_LAST_RUN}

  ### write log
  if [ "${2}" = "main" ]; then
    if [ "${3}" != 255 ]; then
      log "${1}" ${3}
    fi
  else
    if [ "${2}" != 255 ]; then
      log "${1}" ${2}
    fi
  fi

  if [ ! -z "${BRDEXEC_DISPLAY_OUTPUT_TO_STDERR}" ]; then
    unset BRDEXEC_DISPLAY_OUTPUT_TO_STDERR
  fi
}

#307
brdexec_interruption_ctrl_c () { verbose -s "brdexec_interruption_ctrl_c ${@}"

  ### variable is "yes" when ctrl_c function is called by exit function
  if [ "${BRDEXEC_EXIT_IN_PROGRESS}" != "yes" ]; then
    echo -e "\nCTRL+C PRESSED"
  fi

  ### resetting value to check if there were some errors during exit process
  BRDEXEC_CTRLC_ERROR="no"

  ### doing cleanup
  if [ ! -z "${BRDEXEC_SSH_PIDS}" ]; then
    echo -e "Waiting for ssh sessions to terminate"
    BRDEXEC_SSH_PIDS_COUNT="$(echo "${BRDEXEC_SSH_PIDS}" | wc -w)"
    BRDEXEC_SSH_PIDS_COUNT_CURRENT=0
    for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
      ((BRDEXEC_SSH_PIDS_COUNT_CURRENT+=1))
      echo -ne "Waiting for PID ${BRDEXEC_SSH_PID} (${BRDEXEC_SSH_PIDS_COUNT_CURRENT} of ${BRDEXEC_SSH_PIDS_COUNT})    "'\r'
      ### killing any existing ssh sessions
      brdexec_ssh_pid kill
      ### removing main output and error files
      brdexec_temp_files remove_main_output
      brdexec_temp_files remove_error_output
    done
  fi

  ### removing report file
  if [ ! -z "${BRDEXEC_REPORT_FILE}" ] && [ -f "${BRDEXEC_REPORT_FILE}" ]; then
    rm ${BRDEXEC_REPORT_FILE}
  fi
  if [ ! -z "${BRDEXEC_REPORT_ERROR_FILE}" ] && [ -f "${BRDEXEC_REPORT_ERROR_FILE}" ]; then
    rm ${BRDEXEC_REPORT_ERROR_FILE}
  fi
  if [ ! -z "${BRDEXEC_REPORT_FILE_LIST}" ] && [ -f "${BRDEXEC_REPORT_FILE_LIST}" ]; then
    rm ${BRDEXEC_REPORT_FILE_LIST}
  fi

  ### displaying PIDS that could not be killed
  if [ ! -z "${BRDEXEC_SSH_PIDS}" ]; then
    echo -e "\nChecking if all PIDs are killed"
    sleep ${BRDEXEC_CTRLC_PROCESS_KILL_TIMEOUT} 2>/dev/null || sleep 2
  fi
  if [ ! -z "${BRDEXEC_SSH_PIDS}" ]; then
    BRDEXEC_SSH_PIDS_COUNT="$(echo "${BRDEXEC_SSH_PIDS}" | wc -w)"
    BRDEXEC_SSH_PIDS_COUNT_CURRENT=0
    for BRDEXEC_SSH_PID in ${BRDEXEC_SSH_PIDS}; do
      ((BRDEXEC_SSH_PIDS_COUNT_CURRENT+=1))
      echo -ne "Checking PID ${BRDEXEC_SSH_PID} (${BRDEXEC_SSH_PIDS_COUNT_CURRENT} of ${BRDEXEC_SSH_PIDS_COUNT})    "'\r'
      ps -p ${BRDEXEC_SSH_PID} >/dev/null
      if [ "${?}" -eq 0 ]; then
        echo "Process with PID ${BRDEXEC_SSH_PID} could not be killed"
      fi
    done
  fi

  ### Removing any other temp files
  if [ "${BRDEXEC_EXIT_IN_PROGRESS}" != "yes" ]; then
    echo -e "Removing temporary files      "
  fi
  brdexec_temp_files remove_temp_files

  ### Setting status in stats file to interrupted
  brdexec_update_stats -s INTERRUPTED

  ### Exitting
  if [ ! -z "${ERROR_CODE}" ]; then
    exit ${ERROR_CODE}
  else
    exit 1
  fi
}

#308
log () {

  LOG_LINE="$(date +"%y-%m-%d") $(uname -n) ${SCRIPT_NAME}[${RUNID}]: "

  ### check loglevel
  if [ "${2}" -le "${LOG_LEVEL}" ] 2>/dev/null; then
    echo "${LOG_LINE}${1}" | sed ':a;N;$!ba;s/\n/ /g' | sed 's/\\n//g' >> ${LOG_FILE}
  fi
}

#309
brdexec_questions () { verbose -s "brdexec_questions ${@}"

  if [ -z "${BRDEXEC_SCRIPT_TO_RUN}" ]; then
    BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"
  fi

  ### checking if there are any questions
  if [ "$(grep -ic ^BRDEXEC_SCRIPT_QUESTION_ ${BRDEXEC_SCRIPT_TO_RUN})" -ne 0 ]; then

    ### going through each script line searching for questions
    while read BRDEXEC_SCRIPT_QUESTION_LINE; do

      ### reset check variable for each run
      unset BRDEXEC_QUESTION_PARAMETERS_REQUIRED
      unset BRDEXEC_QUESTION_PARAMETER_DEFAULT

      ### reset check for valid question line
      BRDEXEC_SCRIPT_QUESTION_LINE_VALID="yes"
      if [ "$(printf "%q\n" "${BRDEXEC_SCRIPT_QUESTION_LINE}" | grep -ic ^BRDEXEC_SCRIPT_QUESTION_)" -eq 1 ]; then

        ### check if there are some question parameters
        BRDEXEC_QUESTION_CHECK_NUMBER="$(echo "${BRDEXEC_SCRIPT_QUESTION_LINE}" | awk -F "=" '{print $1}' | awk -F "_" '{print NF}')"

        ### get question options and parameter name for script and invalidate question in case it is not in correct format
        if [ "${BRDEXEC_QUESTION_CHECK_NUMBER}" -eq 7 ]; then
          BRDEXEC_QUESTION_OPTION="$(echo "${BRDEXEC_SCRIPT_QUESTION_LINE}" | awk -F "=" '{print $1}' | awk -F "_" '{print $6}')"
          if [ "${BRDEXEC_QUESTION_OPTION}" != "r" ] && [ "${BRDEXEC_QUESTION_OPTION}" != "o" ] && [ "${BRDEXEC_QUESTION_OPTION}" != "b" ]; then
            BRDEXEC_SCRIPT_QUESTION_LINE_VALID="no"
          fi
          BRDEXEC_QUESTION_PARAMETER_NAME="$(echo "${BRDEXEC_SCRIPT_QUESTION_LINE}" | awk -F "=" '{print $1}' | awk -F "_" '{print $7}')"
        else
          BRDEXEC_SCRIPT_QUESTION_LINE_VALID="no"
        fi
        if [ "${BRDEXEC_QUESTION_CHECK_NUMBER}" -eq 8 ]; then
          BRDEXEC_QUESTION_PARAMETER_DEFAULT="$(echo "${BRDEXEC_SCRIPT_QUESTION_LINE}" | awk -F "=" '{print $1}' | awk -F "_" '{print $8}')"
        fi
        BRDEXEC_QUESTION_CONTENT="$(echo "${BRDEXEC_SCRIPT_QUESTION_LINE}" | awk -F "=" '{print $2}' | awk -F "\"" '{print $2}')"
        if [ "$(echo "${BRDEXEC_QUESTION_OPTION}" | grep -ic r)" -eq 1 ]; then
          BRDEXEC_QUESTION_PARAMETERS_REQUIRED="yes"
        fi
        if [ "${BRDEXEC_SCRIPT_QUESTION_LINE_VALID}" = "yes" ]; then
          if [ ! -z "${BRDEXEC_QUESTION_PARAMETER_DEFAULT}" ]; then
            echo "${BRDEXEC_QUESTION_CONTENT} [${BRDEXEC_QUESTION_PARAMETER_DEFAULT}]"
          else
            echo "${BRDEXEC_QUESTION_CONTENT}"
          fi
          read -u 3 BRDEXEC_QUESTION_ANSWER
          if [ "${BRDEXEC_QUESTION_ANSWER}" = "" 2>/dev/null ] && [ "${BRDEXEC_QUESTION_PARAMETERS_REQUIRED}" = "yes" ]; then
            display_error "390" 1
          fi
          if [ "${BRDEXEC_QUESTION_ANSWER}" != "" 2>/dev/null ] || [ "${BRDEXEC_QUESTION_ANSWER}" -eq "${BRDEXEC_QUESTION_ANSWER}" 2>dev/null ]; then
            if [ "${BRDEXEC_QUESTION_OPTION}" = "b" 2>/dev/null ]; then
              BRDEXEC_QUESTION_SCRIPT_PARAMETERS="${BRDEXEC_QUESTION_SCRIPT_PARAMETERS} -${BRDEXEC_QUESTION_PARAMETER_NAME}"
            else
              BRDEXEC_QUESTION_SCRIPT_PARAMETERS="${BRDEXEC_QUESTION_SCRIPT_PARAMETERS} -${BRDEXEC_QUESTION_PARAMETER_NAME} ${BRDEXEC_QUESTION_ANSWER}"
            fi
          fi
        fi
      fi
    done 3<&0 < "${BRDEXEC_SCRIPT_TO_RUN}"
    brdexec_display_output "\nScript will be run as ${BRDEXEC_SCRIPT_TO_RUN}${BRDEXEC_QUESTION_SCRIPT_PARAMETERS}\nPress ENTER to confirm it..." 255
    read
  fi
}

#310
brdexec_custom_user_pwd () { verbose -s "brdexec_custom_user_pwd ${@}"

  if [ -z "${BRDEXEC_SCRIPT_TO_RUN}" ]; then
    BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_PREDEFINED_SCRIPTS_ITEM}"
  fi

  if [ "$(grep -ic ^BRDEXEC_SCRIPT_USER ${BRDEXEC_SCRIPT_TO_RUN})" -gt 0 ]; then
    BRDEXEC_SCRIPT_USER="$(grep -i ^BRDEXEC_SCRIPT_USER ${BRDEXEC_SCRIPT_TO_RUN} | head -n 1 | awk -F "=" '{for (i=2; i<=NF; i++) printf $i}')"
  fi
  if [ "$(grep -ic ^BRDEXEC_SCRIPT_PWD ${BRDEXEC_SCRIPT_TO_RUN})" -gt 0 ]; then
    BRDEXEC_SCRIPT_PWD="$(grep -i ^BRDEXEC_SCRIPT_PWD ${BRDEXEC_SCRIPT_TO_RUN} | head -n 1 | awk -F "=" '{for (i=2; i<=NF; i++) printf $i}')"
  fi
#echo "TEST: .${BRDEXEC_SCRIPT_USER}. .${BRDEXEC_SCRIPT_PWD}."
  if [ ! -z "${BRDEXEC_SCRIPT_USER}" ] && [ ! -z "${BRDEXEC_SCRIPT_PWD}" ]; then
    brdexec_display_output "\nWarning: Script will be run with custom user ${BRDEXEC_SCRIPT_USER} and password specified in script. Press ENTER to continue..." 255
    read
    BRDEXEC_SCRIPT_CUSTOM_CREDENTIALS="yes"
  fi
}

#311
brdexec_embeded_script () { verbose -s "brdexec_embeded_script ${@}"

  ### Check if there is correct embeded functionality - if not set this function is ignored
  if [ "$(grep -c '^###BRDEXEC_EMBEDED' ${BRDEXEC_SCRIPT_TO_RUN})" -gt 0 ]; then
    ### Check if both start and stop of embeded code is defined
    if [ "$(grep -c '^###BRDEXEC_EMBEDED START' ${BRDEXEC_SCRIPT_TO_RUN})" -eq 1 ] && [ "$(grep -c '^###BRDEXEC_EMBEDED STOP' ${BRDEXEC_SCRIPT_TO_RUN})" -eq 1 ]; then
      ### Check if position of start is before stop - paranoia
      if [ "$(grep -n '^###BRDEXEC_EMBEDED STOP' ${BRDEXEC_SCRIPT_TO_RUN} | awk -F ":" '{print $1}')" -gt "$(grep -n '^###BRDEXEC_EMBEDED START' ${BRDEXEC_SCRIPT_TO_RUN} | awk -F ":" '{print $1}')" ]; then

        ### Make and run embeded code
        BRDEXEC_SCRIPT_EMBEDED="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
        BRDEXEC_TEMP_FILES_LIST+=" ${BRDEXEC_SCRIPT_EMBEDED}"
        head -n 1 ${BRDEXEC_SCRIPT_TO_RUN} > ${BRDEXEC_SCRIPT_EMBEDED}
        sed '/^###BRDEXEC_EMBEDED START/,$!d' ${BRDEXEC_SCRIPT_TO_RUN} | sed '/^###BRDEXEC_EMBEDED STOP/q' >> ${BRDEXEC_SCRIPT_EMBEDED}
        chmod +x ${BRDEXEC_SCRIPT_EMBEDED}
        . ${BRDEXEC_SCRIPT_EMBEDED}
        if [ "${BRDEXEC_EMBEDED_ERROR}" -ne "true" 2>/dev/null ]; then
          rm ${BRDEXEC_SCRIPT_EMBEDED} 2>/dev/null
          display_error "312" 1
        else
          brdexec_display_output "\nScript will be run as ${BRDEXEC_SCRIPT_TO_RUN}${BRDEXEC_EMBEDED_PARAMETERS}\nPress ENTER to confirm it..." 255
          ### make temporary script without embeded code for proper broadexec run
          head -n 1 ${BRDEXEC_SCRIPT_TO_RUN} > ${BRDEXEC_SCRIPT_EMBEDED}
          cat lib/osrelease_lib.sh >> ${BRDEXEC_SCRIPT_EMBEDED}
          sed '/^###BRDEXEC_EMBEDED STOP/,$!d' ${BRDEXEC_SCRIPT_TO_RUN} >> ${BRDEXEC_SCRIPT_EMBEDED}
#          BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_SCRIPT_EMBEDED}"
#          BRDEXEC_TMP_SCRIPT="${BRDEXEC_SCRIPT_TO_RUN}"
        fi
      else
        rm ${BRDEXEC_SCRIPT_EMBEDED} 2>/dev/null
        display_error "311" 1
      fi
    else
      rm ${BRDEXEC_SCRIPT_EMBEDED} 2>/dev/null
      display_error "311" 1
    fi
  fi
}

#312
limit_file_size () {

  case "${1}" in
    -c)
      if [ "$(cat "${3}"| wc -c)" -gt "${2}" ]; then
        display_error "3120" 27
      fi
    ;;
    -l)
      if [ "$(cat "${3}"| wc -l)" -gt "${2}" ]; then
        display_error "3120" 27
      fi
    ;;
    -m)
      if [ "$(ls -ln --block-size=1M "${3}" 2>/dev/null | awk '{print $5}')" -gt "${2}" ]; then
        display_error "3120" 27
      fi
    ;;
  esac
}

#313
brdexec_update_stats () {

  ### do not run stats if stats file is not in use
  if [ ! -f "${BRDEXEC_STATS_FILE}" ]; then
    return 0
  fi

  ### Change status
  if [ "${1}" = "-s" ]; then
    if [ ! -z "${2}" ]; then
      BRDEXEC_STATS_STATUS="${2}"
    fi

  ### Change progress
  elif [ "${1}" = "-p" ]; then
    if [ ! -z "${2}" ]; then
      BRDEXEC_STATS_PROGRESS="${2}"
    fi
  fi

  ### possible states: INIT/ERROR/RUNNING/FINISHED/INTERRUPTED
  ### progress values: CURRENT TOTAL PERCENTAGE_COMPLETE SECONDS_RUNNING

  ### write state
  if [ ! -z "${BRDEXEC_STATS_STATUS}" ]; then
    BRDEXEC_STATS_LAST_LINE="$(tail -n 1 ${BRDEXEC_STATS_FILE})"
    echo -e "STATE ${BRDEXEC_STATS_STATUS}\n${BRDEXEC_STATS_LAST_LINE}" > ${BRDEXEC_STATS_FILE}

  ### write progress
  elif [ ! -z "${BRDEXEC_STATS_PROGRESS}" ]; then

    ### count and set number of total hosts to be processed
    if [ "${BRDEXEC_STATS_PROGRESS}" = "run_init_counts" 2>/dev/null ]; then
      BRDEXEC_STATS_TOTAL="$(echo ${BRDEXEC_SERVERLIST_LOOP} | wc -w)"
      echo "STATE RUNNING" > ${BRDEXEC_STATS_FILE}
      echo "PROGRESS 0 ${BRDEXEC_STATS_TOTAL} 0 0" >> ${BRDEXEC_STATS_FILE}

    ### calculate progress from current provided value and time
    elif [ "${BRDEXEC_STATS_PROGRESS}" -eq "${BRDEXEC_STATS_PROGRESS}" ]; then

      ((BRDEXEC_STATS_PROGRESS_TOTAL+=1))

      ### calculate percentage, in case of unexpected error report 0%
      BRDEXEC_STATS_PERCENTAGE="$(echo "${BRDEXEC_STATS_PROGRESS_TOTAL} * 100 / ${BRDEXEC_STATS_TOTAL}" | bc)"
      if [ -z "${BRDEXEC_STATS_PERCENTAGE}" ]; then
        BRDEXEC_STATS_PERCENTAGE=0
      fi

      ### calculate seconds running, report 0 until brdexec start time is initialized after all SSH commands have been executed
      if [ "${BRDEXEC_START_TIME}" -eq "${BRDEXEC_START_TIME}" 2>/dev/null ] && [ ! -z "${BRDEXEC_START_TIME}" ]; then
        BRDEXEC_STATS_CURRENT_TIME=$(date +%s)
        BRDEXEC_STATS_SECONDS="$(echo "${BRDEXEC_STATS_CURRENT_TIME} - ${BRDEXEC_START_TIME}" | bc)"
      else
        BRDEXEC_STATS_SECONDS=0
      fi

      ### write calculated values to file
      BRDEXEC_STATS_FIRST_LINE="$(head -n 1 ${BRDEXEC_STATS_FILE})"
      echo "${BRDEXEC_STATS_FIRST_LINE}" > ${BRDEXEC_STATS_FILE}
      echo "PROGRESS ${BRDEXEC_STATS_PROGRESS_TOTAL} ${BRDEXEC_STATS_TOTAL} ${BRDEXEC_STATS_PERCENTAGE} ${BRDEXEC_STATS_SECONDS}" >> ${BRDEXEC_STATS_FILE}
    fi
  fi

  ### reset values for next checks
  unset BRDEXEC_STATS_STATUS
  unset BRDEXEC_STATS_PROGRESS
  unset BRDEXEC_STATS_PERCENTAGE
  unset BRDEXEC_STATS_SECONDS
}

#41
brdexec_admin_functions () { verbose -s "brdexec_admin_functions ${@}"

  ### enable filtering in case hostslist supports it
  brdexec_create_hosts_list_based_on_filter

  select BRDEXEC_EXPECT_ADMIN_FUNCTION_ITEM in "Check and FIX ALL" "Check connectivity and sudo functionality" "Check and FIX password expiration" "Check and fix known hosts fingerprints" "Check and fix ssh keys" "Distribute ssh keys from teamfolder" "Select and delete particular ssh key from hosts" "Add hostnames and info from ${BRDEXEC_DEFAULT_HOSTS_FOLDER}/hosts and default/hosts/hosts to ~/.ssh/config - not included in check and fix all"
  do
    case ${BRDEXEC_EXPECT_ADMIN_FUNCTION_ITEM} in

      "Check and FIX ALL")
        echo "Checking missing known hosts"
        brdexec_repair_missing_known_hosts shout
        echo "Checking SSH keys and password                     "
        brdexec_admin_check_and_fix_ssh_keys
        echo "Checking and fixing password expiration                       "
        brdexec_admin_check_and_fix_password_expiration
        echo "Checking connectivity and sudo functionality       "
        brdexec_admin_check_connectivity_and_sudo_functionality
        break
      ;;

      "Check connectivity and sudo functionality")
        brdexec_repair_missing_known_hosts
        echo "Checking connectivity and sudo functionality (displays only hosts with issues)      "
        brdexec_admin_check_connectivity_and_sudo_functionality
        break
      ;;

      "Check and FIX password expiration")
        brdexec_repair_missing_known_hosts
        echo "Checking and fixing password expiration                       "
        brdexec_admin_check_and_fix_password_expiration
        break
      ;;

      "Check and fix known hosts fingerprints")
        echo "Checking missing known hosts"
        brdexec_repair_missing_known_hosts shout
        break
      ;;

      "Check and fix ssh keys")
        echo "Checking SSH keys and password                     "
        brdexec_repair_missing_known_hosts
        brdexec_admin_check_and_fix_ssh_keys
        break
      ;;

      "Distribute ssh keys from teamfolder")
        brdexec_admin_ask_password
        brdexec_repair_missing_known_hosts
        brdexec_admin_check_and_fix_ssh_keys from_teamconfig
        break
      ;;

      "Select and delete particular ssh key from hosts")
        brdexec_admin_ask_password
        brdexec_repair_missing_known_hosts
        brdexec_admin_check_and_fix_ssh_keys delete_particular
        break
      ;;

      "Add hostnames and info from ${BRDEXEC_DEFAULT_HOSTS_FOLDER}/hosts and default/hosts/hosts to ~/.ssh/config - not included in check and fix all")

        if [ -s "${BRDEXEC_HOSTS_FILE}" ]; then
          if [ "$(grep -v ^# ${BRDEXEC_HOSTS_FILE} | grep -v "^$" | wc -l)" -gt 0 ]; then
            BRDEXEC_SERVER_COUNTER=0
            BRDEXEC_SERVER_COUNT="$(cat ${BRDEXEC_HOSTS_FILE} | wc -l)"
            BRDEXEC_ETCHOSTS_TMPFILE="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
            BRDEXEC_ETCHOSTS_TMPFILE2="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
            BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_ETCHOSTS_TMPFILE}"
            grep -v "^#" ${BRDEXEC_HOSTS_FILE} > ${BRDEXEC_ETCHOSTS_TMPFILE}
            ### filter hosts file to use only selected hostlist
            echo "Generating hotst file according to selected hostlist. It may take a while, be patient..."
            BRDEXEC_TMPETCHOSTS_TOTAL="$(cat ${BRDEXEC_ETCHOSTS_TMPFILE} | wc -l)"
            BRDEXEC_TMPETCHOSTS_PROCESSED=0
            while read BRDEXEC_SERVER; do
              ((BRDEXEC_TMPETCHOSTS_PROCESSED+=1))
              if [ "${BRDEXEC_SERVER}" != "" 2>/dev/null ] || [ "$(echo "${BRDEXEC_SERVER}" | wc -w)" -lt 2 2>/dev/null ]; then
                echo -ne "Checking ${BRDEXEC_SERVER} (${BRDEXEC_TMPETCHOSTS_PROCESSED} of ${BRDEXEC_TMPETCHOSTS_TOTAL})                  \r"
                BRDEXEC_SERVER_NAME="$(echo "${BRDEXEC_SERVER}" | awk '{print $2}')"
                BRDEXEC_SERVER_IP="$(echo "${BRDEXEC_SERVER}" | awk '{print $1}')"
                if [ ! -z "${BRDEXEC_SERVER_NAME}" ]; then
                  if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep "${BRDEXEC_SERVER_NAME}" | wc -l)" -gt 0 ]; then
                    echo "${BRDEXEC_SERVER}" >> ${BRDEXEC_ETCHOSTS_TMPFILE2}
                  fi
                fi
                if [ ! -z "${BRDEXEC_SERVER_IP}" ]; then
                  if [ "$(echo "${BRDEXEC_SERVERLIST_LOOP}" | grep "${BRDEXEC_SERVER_IP}" | wc -l)" -gt 0 ]; then
                    echo "${BRDEXEC_SERVER}" >> ${BRDEXEC_ETCHOSTS_TMPFILE2}
                  fi
                fi
              fi
            done < ${BRDEXEC_ETCHOSTS_TMPFILE}
            mv ${BRDEXEC_ETCHOSTS_TMPFILE2} ${BRDEXEC_ETCHOSTS_TMPFILE}
            echo -ne "\nHosts file generated\n"

            ### add entries to ssh config of user
            BRDEXEC_SSH_CONFIG_ENTRIES_ADDED=0
            BRDEXEC_SSH_CONFIG_ENTRIES_UPDATED=0
            while read BRDEXEC_SERVER; do
              ((BRDEXEC_SERVER_COUNTER+=1))
              echo -ne "Checking entry ${BRDEXEC_SERVER} (${BRDEXEC_SERVER_COUNTER} of ${BRDEXEC_SERVER_COUNT})        "'\r'
              BRDEXEC_SERVER_IP="$(echo "${BRDEXEC_SERVER}" | awk '{print $1}')"
              BRDEXEC_SERVER_HOSTNAME="$(echo "${BRDEXEC_SERVER}" | awk '{print $2}')"
              ### change hostname to lowercase
              BRDEXEC_SERVER_HOSTNAME=$(echo ${BRDEXEC_SERVER_HOSTNAME} | tr '[:upper:]' '[:lower:]')
              BRDEXEC_CONFIG_CHECK_STRING=$(grep -A1 -i "^Host[[:space:]][[:space:]]*${BRDEXEC_SERVER_HOSTNAME}$" ~/.ssh/config 2>/dev/null)

              #does config contain Host...?
              if [ "${?}" -ne 0 ]; then
                echo "Adding ${BRDEXEC_SERVER_HOSTNAME}:${BRDEXEC_SERVER_IP}                           "
                echo -e "\nHost ${BRDEXEC_SERVER_HOSTNAME}\nHostname ${BRDEXEC_SERVER_IP}" >> ~/.ssh/config
                ((BRDEXEC_SSH_CONFIG_ENTRIES_ADDED+=1))
              else
                echo ${BRDEXEC_CONFIG_CHECK_STRING} | grep -qi "^Host[[:space:]][[:space:]]*${BRDEXEC_SERVER_HOSTNAME}[[:space:]][[:space:]]*Hostname[[:space:]][[:space:]]*${BRDEXEC_SERVER_IP}$"
                #does Hostname follow line after Host?
                if [ "${?}" -ne 0 ]; then
                  echo ${BRDEXEC_CONFIG_CHECK_STRING} | grep -qi "^Host[[:space:]][[:space:]]*${BRDEXEC_SERVER_HOSTNAME}[[:space:]][[:space:]]*Hostname[[:space:]][[:space:]]*"
                  if [ "$?" -eq 0 ]; then
                    >&2 echo "Wrong IP, expecting ${BRDEXEC_SERVER_IP} for ${BRDEXEC_SERVER_HOSTNAME}, you might want to fix your config manually"
                  fi
                  echo "Updating ${BRDEXEC_SERVER_HOSTNAME}:${BRDEXEC_SERVER_IP}                              "
                  sed -i 's/^Host[[:space:]][[:space:]]*'${BRDEXEC_SERVER_HOSTNAME}'$/&\nHostname '${BRDEXEC_SERVER_IP}'/' ~/.ssh/config
                  ((BRDEXEC_SSH_CONFIG_ENTRIES_UPDATED+=1))
                fi
              fi
            done < ${BRDEXEC_ETCHOSTS_TMPFILE}
            rm ${BRDEXEC_ETCHOSTS_TMPFILE}
            echo "Total entries added: ${BRDEXEC_SSH_CONFIG_ENTRIES_ADDED}"
            echo "Total entries updated: ${BRDEXEC_SSH_CONFIG_ENTRIES_UPDATED}"
          fi
        fi
        echo "                                                                          "
        break
      ;;

    esac
  done
}

#42
brdexec_admin_check_and_fix_ssh_keys () { verbose -s "brdexec_admin_check_and_fix_ssh_keys ${@}"

  if [ -z "${1}" ]; then
    ### get user password
    echo -n "Enter password of ${BRDEXEC_USER} user: "
    stty -echo
    read BRDEXEC_ADMPWD
    stty echo
    echo
  fi

  ### use askpass script to log in with password
  SSH_ASKPASS_SCRIPT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${SSH_ASKPASS_SCRIPT}"
  # $ (dollars) are not escaped in original script
  cat <<EOF >${SSH_ASKPASS_SCRIPT}
  if [ -n "\$SSH_ASKPASS_PASSWORD" ]; then
    cat <<< "\$SSH_ASKPASS_PASSWORD"
  elif [ \$# -lt 1 ]; then
    echo "Usage: echo password | \$0 <ssh command line options>" >&2
    exit 1
  else
    read SSH_ASKPASS_PASSWORD
    export SSH_ASKPASS=\$0
    export SSH_ASKPASS_PASSWORD
    [ "\$DISPLAY" ] || export DISPLAY=dummydisplay:0
    # use setsid to detach from tty
    exec setsid "\$@" </dev/null
  fi
EOF
  chmod 755 ${SSH_ASKPASS_SCRIPT}

  if [ "${1}" = "from_teamconfig" ] || [ "${1}" = "delete_particular" ]; then
    if [ "$(ls -1 ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/ 2>/dev/null | grep ".pub$" | wc -l)" -eq 0 ]; then
      >&2 echo "No ssh keys found in teamconfig folder."
      exit 0
    fi
  else

    ### check if default public keys are present
    if [ -s "$HOME/.ssh/id_rsa.pub" ]; then
      BRDEXEC_USER_SSH_PUBLIC_KEY="${HOME}/.ssh/id_rsa.pub"
    elif [ -s "$HOME/.ssh/id_dsa.pub" ]; then
      BRDEXEC_USER_SSH_PUBLIC_KEY="${HOME}/.ssh/id_dsa.pub"
    fi
    echo "${BRDEXEC_USER_SSH_PUBLIC_KEY} was found. Do you want to use it?"
    select BRDEXEC_USER_SSH_PUBLIC_KEY_QUESTION in "yes" "no"
    do
      case ${BRDEXEC_USER_SSH_PUBLIC_KEY_QUESTION} in
        "yes") break;;
        "no")
          echo "Do you want to choose from files located in ${HOME}/.ssh or enter full path yourself?"
          select BRDEXEC_USER_SSH_PUBLIC_KEY_ANOTHER_QUESTION in "I want to choose from my ssh folder" "I am grown up and can enter it correctly on my own!"
          do
            case ${BRDEXEC_USER_SSH_PUBLIC_KEY_ANOTHER_QUESTION} in
              "I want to choose from my ssh folder")
                ### display list of files in .ssh directory
                select BRDEXEC_USER_SSH_PUBLIC_KEY_ITEM in $(ls -1 ${HOME}/.ssh 2>/dev/null | grep .pub$)
                do
                  BRDEXEC_USER_SSH_PUBLIC_KEY="${HOME}/.ssh/${BRDEXEC_USER_SSH_PUBLIC_KEY_ITEM}"
                  break
                done
                break
              ;;
              "I will enter it on my own!")
                echo "Enter full path to your public key:"
                read BRDEXEC_USER_SSH_PUBLIC_KEY
                break
              ;;
            esac
          done
          break
        ;;
      esac
    done
  fi

  if [ "${1}" = "delete_particular" ]; then
    unset PS3
    select BRDEXEC_SSH_KEY_TO_BE_DELETED in $(ls -1 ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/ 2>/dev/null | grep ".pub$")
    do
      if [ "$(ls -1 ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/ 2>/dev/null | grep ".pub$" | wc -l)" -lt "${REPLY}" ] 2>/dev/null; then
        display_error "420" 1
      fi
      if ! [ "${REPLY}" -eq "${REPLY}" ] 2>/dev/null; then
        display_error "420" 1
      fi
      if [ "${REPLY}" -lt 0 ]; then
        display_error "420" 1
      fi
      brdexec_display_output "./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_SSH_KEY_TO_BE_DELETED} was selected\n" 255
      break
    done
  fi

  ### helper variables for progress display
  BRDEXEC_NUMBER_OF_SERVERS="$(echo ${BRDEXEC_SERVERLIST_LOOP} | wc -w)"
  BRDEXEC_SERVER_PROCESSED=0
  for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
    BRDEXEC_CHECK_PASSWORD="no"
    ((BRDEXEC_SERVER_PROCESSED+=1))
#    if [ "${1}" != "delete_particular" ]; then
      echo -ne "Checking server ${BRDEXEC_SERVER} (${BRDEXEC_SERVER_PROCESSED} of ${BRDEXEC_NUMBER_OF_SERVERS})"'\r'
#    fi
    ### check hostname against IP adress in default broadexec hosts file
    if [ -f "${BRDEXEC_HOSTS_FILE}" ]; then
      if [ "$(grep -ic "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE})" -gt 0 ]; then
        BRDEXEC_SERVER="$(grep -i "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE} | head -n 1 | awk '{print $1}')"
      fi
    fi
    ### check if passwordless connection is working or not
    ssh -q -o StrictHostKeyChecking=yes -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} true > /dev/null 2>&1
    ### if not try to add ssh key using password from input
    if [ "$?" -ne 0 ]; then
      echo -e "===============================================\nAdding SSH key for ${BRDEXEC_SERVER}"
      echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes ${BRDEXEC_USER}@${BRDEXEC_SERVER} "mkdir ~/.ssh 2>/dev/null ; chmod 700 ~/.ssh 2>/dev/null ; touch ~/.ssh/authorized_keys 2>/dev/null ; chmod 644 ~/.ssh/authorized_keys 2>/dev/null ; echo $(cat ${BRDEXEC_USER_SSH_PUBLIC_KEY}) >>  ~/.ssh/authorized_keys"
      if [ "$?" -ne 0 ]; then
        BRDEXEC_CHECK_PASSWORD="yes"
      fi
      ### check if SSH keys were added successfully or not
      ssh -q -o StrictHostKeyChecking=yes -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} true > /dev/null 2>&1
      if [ "$?" -ne 0 ]; then
        >&2 echo "There was problem adding ssh keys, check manually."
      else
        echo "SSH key for ${BRDEXEC_SERVER} added successfully."
      fi

      ### display info about unability to distribute teamconfig ssh keys in case standard admin user has issues
      if [ "${1}" = "from_teamconfig" ]; then
        >&2 echo "Teamconfig ssh keys for this server were not added. First fix admin user access and run distribution again."
      fi

    ### adding ssh keys from teamfolder
    else
      if [ "${1}" = "from_teamconfig" ]; then
        for BRDEXEC_TEAM_SSH_KEY in $(ls -1 ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/ 2>/dev/null| grep ".pub$")
        do
          ### check if passwordless connection is working or not
          BRDEXEC_REMOTE_AUTHORIZED_KEYS="$(ssh -q -o StrictHostKeyChecking=yes -o BatchMode=yes -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} "cat ~/.ssh/authorized_keys")"
          BRDEXEC_LOCAL_PUBLIC_KEY="$(cat ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_TEAM_SSH_KEY})"
          ### if not try to add ssh key
          if [ "$(echo "${BRDEXEC_REMOTE_AUTHORIZED_KEYS}" | grep -c "${BRDEXEC_LOCAL_PUBLIC_KEY}")" -eq 0 ]; then
            echo -e "===============================================\nAdding SSH key ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_TEAM_SSH_KEY} for ${BRDEXEC_SERVER}"
            echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes ${BRDEXEC_USER}@${BRDEXEC_SERVER} "echo $(cat ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_TEAM_SSH_KEY}) >> ~/.ssh/authorized_keys"
            if [ "$?" -ne 0 ]; then
              >&2 echo "There was problem adding ssh keys, check manually."
            else
              echo "SSH key for ${BRDEXEC_SERVER} added successfully."
            fi
          fi
        done

      ### remove particular ssh key from hosts
      elif [ "${1}" = "delete_particular" ]; then
        BRDEXEC_REMOTE_SSH_KEY_TO_DELETE_FOUND="$(ssh -q -o StrictHostKeyChecking=yes -o BatchMode=yes -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} "grep -c \"$(cat ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_SSH_KEY_TO_BE_DELETED})\" ~/.ssh/authorized_keys")"
        if [ "${BRDEXEC_REMOTE_SSH_KEY_TO_DELETE_FOUND}" -gt 0 2>/dev/null ]; then
          echo -e "===============================================\nDeleting SSH key ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_SSH_KEY_TO_BE_DELETED} from ${BRDEXEC_SERVER}"
          echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes ${BRDEXEC_USER}@${BRDEXEC_SERVER} "BRDEXEC_DEL_TMP_KEY=\"\$(mktemp /tmp/broadexec.XXXXXXXXXX)\"; grep -v \"$(cat ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/.ssh/${BRDEXEC_SSH_KEY_TO_BE_DELETED} | awk '{print $2}')\" ~/.ssh/authorized_keys >> \${BRDEXEC_DEL_TMP_KEY}; mv \${BRDEXEC_DEL_TMP_KEY} ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys "
          if [ "$?" -ne 0 ]; then
            >&2 echo "There was problem deleting ssh keys, check manually."
          else
            echo "SSH key for ${BRDEXEC_SERVER} removed successfully."
          fi
        fi
      fi

    fi

    if [ -z "${1}" ]; then
      ### test connection via password anyways in case it needs to be changed
      echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes ${BRDEXEC_USER}@${BRDEXEC_SERVER} true > /dev/null 2>&1 || BRDEXEC_CHECK_PASSWORD="yes"

      if [ "${BRDEXEC_CHECK_PASSWORD}" = "yes" ]; then
        echo -e "===============================================\nSetting password for ${BRDEXEC_USER} on ${BRDEXEC_SERVER}"
        ssh -q -o StrictHostKeyChecking=yes -o BatchMode=yes${BRDEXEC_USER_SSH_KEY} -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" ${BRDEXEC_USER}@${BRDEXEC_SERVER} "sudo su - -c \"echo \"${BRDEXEC_USER}:${BRDEXEC_ADMPWD}\"|$(whereis chpasswd | awk '{print $2}')\"i" 2>/dev/null
        ### check if password was set properly
        echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o PasswordAuthentication=yes ${BRDEXEC_USER}@${BRDEXEC_SERVER} true > /dev/null 2>&1
        if [ "$?" -eq 255 ]; then
          >&2 echo "There was problem setting password for ${BRDEXEC_USER} on ${BRDEXEC_SERVER}"
        else
          echo "Password was successfully set."
        fi
      fi
    fi
  done
  rm ${SSH_ASKPASS_SCRIPT}
}

#43
brdexec_admin_check_and_fix_password_expiration () { verbose -s "brdexec_admin_check_and_fix_password_expiration ${@}"

  if [ -z "${BRDEXEC_ADMPWD}" ]; then
    ### get user password
    echo -n "Enter password of ${BRDEXEC_USER} user (hit ENTER if you want to use SSH keys): "
    stty -echo
    read BRDEXEC_ADMPWD
    stty echo
    echo
    if [ ! -z "${BRDEXEC_ADMPWD}" ]; then
      BRDEXEC_ADMPWD_SET="yes"
    fi
  else
    BRDEXEC_ADMPWD_SET="yes"
  fi

  ### use askpass script to log in with password
  SSH_ASKPASS_SCRIPT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${SSH_ASKPASS_SCRIPT}"
  # $ (dollars) are not escaped in original script
  cat <<EOF >${SSH_ASKPASS_SCRIPT}
  if [ -n "\$SSH_ASKPASS_PASSWORD" ]; then
    cat <<< "\$SSH_ASKPASS_PASSWORD"
  elif [ \$# -lt 1 ]; then
    echo "Usage: echo password | \$0 <ssh command line options>" >&2
    exit 1
  else
    read SSH_ASKPASS_PASSWORD
    export SSH_ASKPASS=\$0
    export SSH_ASKPASS_PASSWORD
    [ "\$DISPLAY" ] || export DISPLAY=dummydisplay:0
    # use setsid to detach from tty
    exec setsid "\$@" </dev/null
  fi
EOF
  chmod 755 ${SSH_ASKPASS_SCRIPT}

  BRDEXEC_NUMBER_OF_SERVERS="$(echo ${BRDEXEC_SERVERLIST_LOOP} | wc -w)"
  BRDEXEC_SERVER_PROCESSED=0
  for BRDEXEC_SERVER in ${BRDEXEC_SERVERLIST_LOOP}; do
    BRDEXEC_CHECK_PASSWORD="no"
    ((BRDEXEC_SERVER_PROCESSED+=1))
    ### check hostname against IP adress in default broadexec hosts file
    if [ -f "${BRDEXEC_HOSTS_FILE}" ]; then
      if [ "$(grep -ic "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE})" -gt 0 ]; then
        BRDEXEC_SERVER="$(grep -i "${BRDEXEC_SERVER}" ${BRDEXEC_HOSTS_FILE} | head -n 1 | awk '{print $1}')"
      fi
    fi
    echo -ne "Checking server ${BRDEXEC_SERVER} (${BRDEXEC_SERVER_PROCESSED} of ${BRDEXEC_NUMBER_OF_SERVERS}) "
    if [ "${BRDEXEC_ADMPWD_SET}" = "yes" ]; then
      BRDEXEC_CHAGE_INFO="$(echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no ${BRDEXEC_USER}@${BRDEXEC_SERVER} "sudo su - -c \"passwd -S ${BRDEXEC_USER}\"" 2>/dev/null | awk '{print $4,$5,$7}')"
    else
      BRDEXEC_CHAGE_INFO="$(ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no ${BRDEXEC_USER}@${BRDEXEC_SERVER} "sudo su - -c \"passwd -S ${BRDEXEC_USER}\"" 2>/dev/null | awk '{print $4,$5,$7}')"
    fi
    if [ "${BRDEXEC_CHAGE_INFO}" != "" 2>/dev/null ]; then
      if [ "${BRDEXEC_CHAGE_INFO}" != "0 99999 -1" 2>/dev/null ]; then
        echo -e "===========================================\nUser info for ${BRDEXEC_USER} on ${BRDEXEC_SERVER} needs to be changed"
        if [ "${BRDEXEC_ADMPWD_SET}" = "yes" ]; then
          echo $BRDEXEC_ADMPWD | $SSH_ASKPASS_SCRIPT ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no ${BRDEXEC_USER}@${BRDEXEC_SERVER} "sudo su - -c \"chage -m 0 -M 99999 -I -1 -E -1 ${BRDEXEC_USER}\"" 2>/dev/null
        else
          ssh -o "ConnectTimeout=${BRDEXEC_SSH_CONNECTION_TIMEOUT}" -o StrictHostKeyChecking=no ${BRDEXEC_USER}@${BRDEXEC_SERVER} "sudo su - -c \"chage -m 0 -M 99999 -I -1 -E -1 ${BRDEXEC_USER}\"" 2>/dev/null
        fi
      else
        echo "OK: Password and expiration is set."
      fi
    else
      >&2 echo -e "===========================================\nUnable to get chage info from ${BRDEXEC_SERVER}"
    fi
  done
  rm ${SSH_ASKPASS_SCRIPT}
}

#44
brdexec_admin_check_connectivity_and_sudo_functionality () { verbose -s "brdexec_admin_check_connectivity_and_sudo_functionality ${@}"

  BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY="yes"
  BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT="$(mktemp /tmp/broadexec.XXXXXXXXXX)"
  BRDEXEC_TEMP_FILES_LIST="${BRDEXEC_TEMP_FILES_LIST} ${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT}"
  echo '#!/bin/bash' >> ${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT}
  echo 'sudo su - -c "uname -n"' >> ${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT}
  BRDEXEC_SCRIPT_TO_RUN="${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT}"
  # spring cleaning TODO: exchange script exec for new way once it is done
  #brdexec_script_exec
  brdexec_wait_for_pids_to_finish
  brdexec_generate_error_log
  brdexec_display_error_log
  echo -ne "\n"
  rm ${BRDEXEC_EXPECT_ADMIN_FUNCTION_CHECK_CONNECTIVITY_SCRIPT}
}

#45
brdexec_admin_cleanup_report_files () {

  ### run cleanup only when it is in config
  if [ ! -z "${BRDEXEC_REPORT_CLEANUP_DAYS}" ] && [ "${BRDEXEC_REPORT_CLEANUP_DAYS}" -eq "${BRDEXEC_REPORT_CLEANUP_DAYS}" ] 2>/dev/null && [ "${BRDEXEC_REPORT_CLEANUP_DAYS}" -gt 0 ] && [ ! -z "${BRDEXEC_REPORT_PATH}" ]; then
    ### and only if it has not been run last 24 hours
    if [ ! -f logs/report_cleanup_timestamp ]; then
      date +%s > logs/report_cleanup_timestamp
    else
      BRDEXEC_REPORT_CLEANUP_TIME_NOW="$(date +%s)"
      BRDEXEC_REPORT_CLEANUP_TIME_LOG="$(cat logs/report_cleanup_timestamp)"
      BRDEXEC_REPORT_CLEANUP_TIME_DIF="$(echo "${BRDEXEC_REPORT_CLEANUP_TIME_NOW} - ${BRDEXEC_REPORT_CLEANUP_TIME_LOG}" | bc)"
      if [ "${BRDEXEC_REPORT_CLEANUP_TIME_LOG}" -ne "${BRDEXEC_REPORT_CLEANUP_TIME_LOG}" 2>/dev/null ] || [ "${BRDEXEC_REPORT_CLEANUP_TIME_DIF}" -gt 86400 ]; then
        if [ "$(find ${BRDEXEC_REPORT_PATH} -type f -mtime +${BRDEXEC_REPORT_CLEANUP_DAYS} 2>/dev/null | grep -v tar.gz$ | wc -l)" -gt 0 ]; then
          BRDEXEC_REPORT_CLEANUP_FILES_LIST="${BRDEXEC_REPORT_CLEANUP_FILES_LIST} $(find ${BRDEXEC_REPORT_PATH} -type f -mtime +${BRDEXEC_REPORT_CLEANUP_DAYS} 2>/dev/null | egrep ".report$|.report_error$|report_list$" | sed ':a;N;$!ba;s/\n/ /g')"
          ### delete files
          for BRDEXEC_REPORT_CLEANUP_FILE in ${BRDEXEC_REPORT_CLEANUP_FILES_LIST}; do
            rm ${BRDEXEC_REPORT_CLEANUP_FILE}
          done
        fi
      fi
      date +%s > logs/report_cleanup_timestamp
    fi
  fi
}

#46
brdexec_check_updates () { verbose -s "brdexec_check_updates ${@}"

  ### create conf folder if missing
  if [ ! -d ./conf ]; then
    mkdir ./conf || display_error "474" 1
  fi

  ### create hosts folder if missing
  if [ ! -d ./hosts ]; then
    mkdir ./hosts || display_error "475" 1
  fi

  ### check config file
  if [ ! -f "conf/broadexec.conf" 2>/dev/null ]; then
    BRDEXEC_CREATE_CONFIG_FILE_ANSWER="yes"
  fi

  ### check and set SSH tunnel port
  verbose 461 2
  if [ -z "${BRDEXEC_SSH_PORT}" ] || [ "${BRDEXEC_CREATE_CONFIG_FILE_ANSWER}" = "yes" ]; then
    echo -e "\nEnter SSH tunnel port to use to get the files:"
    echo -n "# [2222] "
    read BRDEXEC_SSH_PORT
    if [ "${BRDEXEC_SSH_PORT}" = "" 2>/dev/null ]; then
      BRDEXEC_SSH_PORT=2222
    fi
    if ! [ "${BRDEXEC_SSH_PORT}" -eq "${BRDEXEC_SSH_PORT}" 2>/dev/null ]; then
      display_error "473" 1
    else
      echo "BRDEXEC_SSH_PORT=${BRDEXEC_SSH_PORT}" >> conf/broadexec.conf
    fi
  fi

  ### check and fix links
  #if [ ! -z "${BRDEXEC_TEAM_CONFIG}" ] || [ "${BRDEXEC_INSTALLED_NOW}" = "yes" ]; then
  #  ### check if default link is correct
  #  if [ "$(ls -la ./default 2>/dev/null | awk -F " -> " '{print $2}')" != "./teamconfigs/${BRDEXEC_TEAM_CONFIG}" ]; then
  #    if [ "${BRDEXEC_INSTALLED_NOW}" = "yes" ]; then
  #      brdexec_display_output "Fixing default link to teamconfigs/${BRDEXEC_TEAM_CONFIG}" 1
  #    fi
  #    if [ -h ./default ]; then
  #      unlink ./default 2>/dev/null
  #    fi
  #    ln -s ./teamconfigs/${BRDEXEC_TEAM_CONFIG} ./default 2>/dev/null
  #  fi
  #  for BRDEXEC_TEAM_CONFIG_SUBFOLDER in conf hosts scripts
  #  do
  #    if [ -d "${BRDEXEC_TEAM_CONFIG_SUBFOLDER}" ]; then
  #      if [ ! -h "${BRDEXEC_TEAM_CONFIG_SUBFOLDER}/${BRDEXEC_TEAM_CONFIG}" ]; then
  #        echo "Creating link ${BRDEXEC_TEAM_CONFIG_SUBFOLDER}/${BRDEXEC_TEAM_CONFIG} to teamconfigs/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_CONFIG_SUBFOLDER}"
  #        ln -s ../teamconfigs/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_CONFIG_SUBFOLDER} ${BRDEXEC_TEAM_CONFIG_SUBFOLDER}/${BRDEXEC_TEAM_CONFIG}
  #      fi
  #    fi
  #  done
  #fi

  ### import public gpg keys
  if [ -d etc/gpg_pubkeys ]; then
    if [ "$(find etc/gpg_pubkeys/ -name *.gpg | tr '\n' ' ' | wc -w)" -gt 0 ]; then
      if [ "${BRDEXEC_INSTALLED_NOW}" = "yes" ]; then
        brdexec_display_output "  Importing GPG signature keys" 1
      fi
      gpg --import $(find etc/gpg_pubkeys/ -name *.gpg | tr '\n' ' ') 2>/dev/null
    else
      ### there are no keys provided
      display_error "461" 1
    fi
  else
    ### folder with keys does not exist
    display_error "460" 1
  fi

  ### write to update log
  BRDEXEC_LOG_CHECK_UPDATES_GIT_UPDATE_INFO="$(cat "${BRDEXEC_LOG_CHECK_UPDATES_GIT_OUTPUT}" 2>/dev/null | sed ':a;N;$!ba;s/\n/ /g')"
  #echo "${BRDEXEC_LOG_CHECK_UPDATES_TIMESTAMP} ${BRDEXEC_LOG_CHECK_UPDATES_GIT_UPDATE_INFO}" >> "${BRDEXEC_LOG_CHECK_UPDATES}"
  echo "${BRDEXEC_LOG_CHECK_UPDATES_TIMESTAMP} ${BRDEXEC_LOG_CHECK_UPDATES_GIT_UPDATE_INFO}" >> "${BRDEXEC_LOG_CHECK_UPDATES}"
  if [ -f "${BRDEXEC_LOG_CHECK_UPDATES_GIT_OUTPUT}" ]; then
    rm "${BRDEXEC_LOG_CHECK_UPDATES_GIT_OUTPUT}"
  fi

  ### Exit in case install was done or team config was not loaded
  if [ "${BRDEXEC_TEAM_CONFIG_SELECTED}" = "yes" 2>/dev/null ] || [ "${BRDEXEC_INSTALLED_NOW}" = "yes" ]; then
    echo "Configuration finished, please restart broadexec."
    exit 0
  fi

  #check if update parameter is set so it can exit
  if [ ! -z "${BRDEXEC_RUN_UPDATE}" ]; then
    brdexec_temp_files remove_temp_files
    exit 0
  fi


  ##############
  ### disabled, but left for possible future use
  ##############
  ### write username of linux admin user into config in case team folder is not available
#  if [ -z "${BRDEXEC_TEAM_CONFIG}" ] || [ ! -f "./teamconfigs/${BRDEXEC_TEAM_CONFIG}/conf/broadexec.conf" ]; then
#  #if [ "$(grep -c "^BRDEXEC_USER" ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/conf/broadexec.conf)" -eq 0 ]; then
#    if [ -f "conf/broadexec.conf" ]; then
#      if [ "$(grep -c "^BRDEXEC_USER" conf/broadexec.conf)" -eq 0 ]; then
#        echo -e "\nEnter user name of admin user present on all hosts with admin rights:"
#        read BRDEXEC_USER
#        id ${BRDEXEC_USER} >/dev/null || display_error "472" 1
#        echo "BRDEXEC_USER=${BRDEXEC_USER}" >> conf/broadexec.conf
#        echo -e "\nUser added to config file. Run broadexec again."
#      fi
#    fi
#  fi

}

#48
brdexec_admin_ask_password () {

  ### ask for and check password
  echo "Enter username"
  echo -n "# [$(whoami)] "
  read BRDEXEC_ADMIN_USERNAME
  if [ "${BRDEXEC_ADMIN_USERNAME}" = "" 2>/dev/null ]; then
    BRDEXEC_ADMIN_USERNAME="$(whoami)"
  fi
  echo "Enter password"
  read -s BRDEXEC_ADMIN_PASSWORD
  if [ "$(echo "${BRDEXEC_ADMIN_PASSWORD}" | wc -c)" -lt 5 ]; then
    display_error "414" 1
  fi
  if [ ! -z "${BRDEXEC_ADMIN_USERNAME}" ]; then
    BRDEXEC_ADMIN_PASSWORD_INPUT="$(python -c 'import crypt; print crypt.crypt("'"${BRDEXEC_ADMIN_USERNAME}"'", "'"${BRDEXEC_ADMIN_PASSWORD}"'")')"
  else
    display_error "413" 1
  fi
  if [ -f "./teamconfigs/${BRDEXEC_TEAM_CONFIG}/etc/shadow" ]; then
    ### check shadow file hash and signature

    BRDEXEC_ADMIN_PASSWORD_STORE="$(grep "^${BRDEXEC_ADMIN_USERNAME}" ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/etc/shadow | head -n 1 | awk -F ":" '{print $2}')"
  else
    display_error "410" 1
  fi
  if [ "${BRDEXEC_ADMIN_PASSWORD_INPUT}" = "" 2>/dev/null ]; then
    display_error "411" 1
  fi
  if [ "${BRDEXEC_ADMIN_PASSWORD_INPUT}" != "${BRDEXEC_ADMIN_PASSWORD_STORE}" 2>/dev/null ]; then
    display_error "412" 1
  fi
}

#47
brdexec_create_config_file () {

  if [ ! -d ./conf ]; then
   mkdir ./conf || display_error "474" 1
  fi
  if [ ! -d ./hosts ]; then
    mkdir ./hosts || display_error "475" 1
  fi
  echo "Getting files from team group repository"
  if [ "$(grep -c "^BRDEXEC_SSH_PORT" conf/broadexec.conf 2>/dev/null)" -lt 1 ] 2>/dev/null || [ ! -f broadexec.conf ]; then
    echo -e "\nEnter SSH tunnel port to use to get the files:"
    echo -n "# [2222] "
    read BRDEXEC_SSH_PORT
    if [ "${BRDEXEC_SSH_PORT}" = "" 2>/dev/null ]; then
      BRDEXEC_SSH_PORT=2222
    fi
    if ! [ "${BRDEXEC_SSH_PORT}" -eq "${BRDEXEC_SSH_PORT}" 2>/dev/null ]; then
      display_error "473" 1
    else
      echo "BRDEXEC_SSH_PORT=${BRDEXEC_SSH_PORT}" >> conf/broadexec.conf
    fi
  fi

  ### get list of team folders
  if [ "$(ls -1 teamconfigs 2>/dev/null | wc -l)" -gt 0 ]; then
    echo -e "\nSelect your team group"
    select BRDEXEC_TEAM_CONFIG in $(ls -1 teamconfigs | grep -v brd-teams)
    do
      if [ "$(ls -1 teamconfigs 2>/dev/null | wc -w)" -lt "${REPLY}" ] 2>/dev/null; then
        display_error "471" 1
      fi
      if ! [ "${REPLY}" -eq "${REPLY}" ] 2>/dev/null; then
        display_error "471" 1
      fi
      if [ "${REPLY}" -lt 1 ]; then
        display_error "471" 1
      fi
      echo "${BRDEXEC_TEAM_CONFIG} was selected"
      break
    done
  else
    >&2 echo "Unable to fetch teamconfigs, probably wrong SSH tunnel settings."
    exit 1
  fi

  ### create config file and links
  echo "BRDEXEC_TEAM_CONFIG=${BRDEXEC_TEAM_CONFIG}" >> conf/broadexec.conf
  echo -e "\nCreating links to team folder"

  for BRDEXEC_TEAM_CONFIG_SUBFOLDER in conf hosts scripts
  do
    if [ -d "${BRDEXEC_TEAM_CONFIG_SUBFOLDER}" ]; then
      cd "${BRDEXEC_TEAM_CONFIG_SUBFOLDER}"
      if [ "$(find ! -name . -prune -type l | wc -l)" -gt 0 ]; then
        for BRDEXEC_TEAM_CONFIG_SUBLINK in $(find ! -name . -prune -type l); do
          echo "Removing old link ${BRDEXEC_TEAM_CONFIG_SUBLINK} from ${BRDEXEC_TEAM_CONFIG_SUBFOLDER}"
          unlink ${BRDEXEC_TEAM_CONFIG_SUBLINK}
        done
      fi
      cd ..
    fi
    echo "Creating link ${BRDEXEC_TEAM_CONFIG_SUBFOLDER}/${BRDEXEC_TEAM_CONFIG} to teamconfigs/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_CONFIG_SUBFOLDER}"
    ln -s ../teamconfigs/${BRDEXEC_TEAM_CONFIG}/${BRDEXEC_TEAM_CONFIG_SUBFOLDER} ${BRDEXEC_TEAM_CONFIG_SUBFOLDER}/${BRDEXEC_TEAM_CONFIG}
  done
  echo "Creating default link"
  if [ ! -h ./default 2>/dev/null ]; then
    ln -s ./teamconfigs/${BRDEXEC_TEAM_CONFIG} ./default
  fi

  ### write username of admin user into config in case team folder is not available
  if [ -z "${BRDEXEC_TEAM_CONFIG}" ] || [ ! -f "./teamconfigs/${BRDEXEC_TEAM_CONFIG}/conf/broadexec.conf" ]; then
  #if [ "$(grep -c "^BRDEXEC_USER" ./teamconfigs/${BRDEXEC_TEAM_CONFIG}/conf/broadexec.conf)" -eq 0 ]; then
    if [ -f "conf/broadexec.conf" ]; then
      if [ "$(grep -c "^BRDEXEC_USER" conf/broadexec.conf)" -eq 0 ]; then
        echo -e "\nEnter user name of admin user present on all hosts with admin rights:"
        read BRDEXEC_USER
        id ${BRDEXEC_USER} >/dev/null || display_error "472" 1
        echo "BRDEXEC_USER=${BRDEXEC_USER}" >> conf/broadexec.conf
        echo -e "\nUser added to config file. Run broadexec again."
      fi
    fi
  fi
  exit 1
}

#48
brdexec_install () {

  ### check for conflicting config files/folders that would prevent installation to continue
  if [ -e conf ] && [ ! -d conf ]; then
    echo "ERROR: There seems to be file instead of folder named conf in broadexec directory. Unable to continue with installation unless it is removed."
    brdexec_interruption_ctrl_c
  fi

  if [ ! -d conf ]; then
    mkdir conf
  fi

  echo "##########################################################################"
  echo "######################### Broadexec installation #########################"
  echo "##########################################################################"

  echo "--------------------------------------------------------------------------"
  echo "This is your first run of broadexec, welcome and hope you will enjoy it ! "
  echo "Please consider reading man and docs and configure your broadexec properly"
  echo "--------------------------------------------------------------------------"

  echo -e "\nIf you wish to skip or cancel installation, write to any of "
  echo "the prompts \"skip\" or \"cancel\""
  echo "In case you don\'t want installation to start automatically, write \"abort\""
  echo "To invoke installation again just delete \"#already installed\""
  echo "line from conf/broadexec.conf and run broadexec"
  echo "If installation is cancelled, it will restart on next run with possibility"
  echo "to skip already configured items"

  ### Username selection
  echo
  echo "##########################################################################"
  echo "### Default username selection ###########################################"
  echo

  ### check if user already added in conf or not
  if [ !  -z "${BRDEXEC_USER}" ]; then
    echo -e "Default username already in config: ${BRDEXEC_USER}. Do you wish to edit it anyways [skip] (yes/skip):"
    read BRDEXEC_USER_FOUND
    if [ "${BRDEXEC_USER_FOUND}" = "" 2>/dev/null ]; then
      BRDEXEC_USER_FOUND=skip
    fi
  fi

  case "${BRDEXEC_USER_FOUND}" in
    skip)
      BRDEXEC_INSTALL_USER=skip ;;
    *)
      echo "Enter default username used for connecting to hosts [$(logname)]:"
      read BRDEXEC_INSTALL_USER ;;
  esac

  if [ "${BRDEXEC_INSTALL_USER}" = "" 2>/dev/null ]; then
    BRDEXEC_INSTALL_USER="$(logname)"
  fi

  case "${BRDEXEC_INSTALL_USER}" in
    skip)
      echo "WARNING: Skipping User selection" ;;
    cancel)
      echo "WARNING: Cancelling installation"
      brdexec_interruption_ctrl_c ;;
    abort)
      echo "#already installed" >> conf/broadexec.conf
      echo "\n   \"#already installed\" written into conf/broadexec.conf"
      brdexec_interruption_ctrl_c ;;
    *)
      echo "OK: Default user selected"
      echo "BRDEXEC_USER=${BRDEXEC_INSTALL_USER}" >> conf/broadexec.conf
      echo "   BRDEXEC_USER=${BRDEXEC_INSTALL_USER} written into conf/broadexec.conf"
  esac

  echo "### TIP: You can always override this with \"-u\" parameter"

  ### SSH key selection
  echo
  echo "##########################################################################"
  echo "### SSH key selection ####################################################"
  echo
  echo "Broadexec is supposed to run scripts on many hosts so SSH keys are a must"
  echo "NOTE: Your private SSH keys are not copied anywhere, broadexec just needs"
  echo "to know which one to use"

  if [ -f ~/.ssh/id_rsa ]; then
    BRDEXEX_INSTALL_PROPOSED_KEY="~/.ssh/id_rsa"
  elif [ -f ~/.ssh/id_dsa ]; then
    BRDEXEX_INSTALL_PROPOSED_KEY="~/.ssh/id_dsa"
  fi

  if [ ! -z "${BRDEXEC_USER_SSH_KEY}" ]; then
    echo "SSH key already in config: ${BRDEXEC_USER_SSH_KEY}. Do you wish to edit it anyways [skip] (yes/skip):"
    read BRDEXEC_USER_SSH_KEY_FOUND
    if [ "${BRDEXEC_USER_SSH_KEY_FOUND}" = "" 2>/dev/null ]; then
      BRDEXEC_USER_SSH_KEY_FOUND=skip
    fi
  fi

  case "${BRDEXEC_USER_SSH_KEY_FOUND}" in
    skip)
      BRDEXEC_INSTALL_USER_SSH_KEY=skip ;;
    *)
      echo -e "Enter location of your private SSH key\c"
      if [ ! -z "${BRDEXEX_INSTALL_PROPOSED_KEY}" ]; then
        echo -e " [${BRDEXEX_INSTALL_PROPOSED_KEY}]\c"
      else
	echo -e " [skip]\c"
      fi
      echo ": "
      read BRDEXEC_INSTALL_USER_SSH_KEY ;;
  esac

  if [ "${BRDEXEC_INSTALL_USER_SSH_KEY}" = "" 2>/dev/null ]; then
    if [ -z "${BRDEXEX_INSTALL_PROPOSED_KEY}" ]; then
      BRDEXEC_INSTALL_USER_SSH_KEY="skip"
    else
      BRDEXEC_INSTALL_USER_SSH_KEY="${BRDEXEX_INSTALL_PROPOSED_KEY}"
    fi
  fi

  case "${BRDEXEC_INSTALL_USER_SSH_KEY}" in
    skip)
      echo "WARNING: Skipping SSH key selection" ;;
    cancel)
      echo "WARNING: Cancelling installation"
      exit 0 ;;
    abort)
      echo "#already installed" >> conf/broadexec.conf
      echo "\"   #already installed\" written into conf/broadexec.conf"
      exit 0 ;;
    *)
      echo "OK: SSH Key selected"
      echo "BRDEXEC_USER_SSH_KEY=${BRDEXEC_INSTALL_USER_SSH_KEY}" >> conf/broadexec.conf
      echo "BRDEXEC_USER_SSH_KEY=${BRDEXEC_INSTALL_USER_SSH_KEY} written into conf/broadexec.conf"
  esac

  echo -e "\n### That is it! ###"
  echo -e "\nThis is enough to get you started. To explore more configuration"
  echo "options you can check out config templates in templates/conf folder."

  echo "#already installed" >> conf/broadexec.conf
  echo -e "\n   \"#already installed\" written into conf/broadexec.conf"
  echo -e "\n\n### Broadexec installation is now finished! \n"

  echo "Example:"
  echo "Make sure you have ssh_key added (ssh-copy-id ${BRDEXEC_INSTALL_USER}@localhost)"
  echo "Make sure you can execute \"sudo\" without password"
  echo "\$ ./broadexec.sh -s scripts/uptime.sh -H localhost"

  ### we can get away without cleanup during installation, no tmp files written at this stage
  exit 0
}

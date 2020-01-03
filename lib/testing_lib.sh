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

###
### Library for testing broadexec scenarios after various fixes and during script development
### 

testing_init_checks () {

  ### check if there is no other checks running for this user as this library can mess up git if run more than once at a time
  #TESTING_NUM_OF_INSTANCES="$(ps -ef | grep -- '--run-test-scenario' | wc -l)"
  #if [ "${TESTING_NUM_OF_INSTANCES}" -gt 1 ]; then
  #  echo "There is already test scenarion in progress, wait for it or stop it to continue."
  #  ps -ef | grep -- -X '--run-test-scenario'
  #  exit 1
  #fi

  echo >/dev/null
}


testing_load_scenario () {

  #testing_checkout_branch teamconfigs testing_suite

  ### check if list/scenario files are existing
  if [ ! -f "${TESTING_SCENARIO_FILE}" ]; then
    echo "Scenario or list provided does not exists"
    exit 1
  fi

  ### for now only providing lists works
  echo -e "\nLoading scenario list"
  if [ "$(echo "${TESTING_SCENARIO_FILE}" | grep -c ".list$")" -ne 1 ]; then
    echo "List provided seems not be proper list. File needs to be ending with .list. Name of your file: ${TESTING_SCENARIO_FILE}"
    exit 1
  fi

  ### displaying scenario list message
  TESTING_SCENARIO_LIST_MESSAGE="$(cat "${TESTING_SCENARIO_FILE}" | grep "^message " | tail -n 1 | cut -d " " -f2-)"
  if [ "${TESTING_SCENARIO_LIST_MESSAGE}" = "" 2>/dev/null ]; then
    echo "No scenario list message found. Consider adding it for convenience of your colleagues."
  else
    echo -e "\nScenario ${TESTING_SCENARIO_FILE} message:\n${TESTING_SCENARIO_LIST_MESSAGE}\n"
  fi

  ### load scenario files list
  TESTING_SCENARIO_LIST="$(cat "${TESTING_SCENARIO_FILE}" | grep "^scenario " | awk '{print $2}')"
  TESTING_SCENARIO_FOLDER="$(cat "${TESTING_SCENARIO_FILE}" | grep "folder " | awk '{print $2}')"
  if [ "${TESTING_SCENARIO_FOLDER}" != "" ]; then
    TESTING_SCENARIO_LIST="$(echo "${TESTING_SCENARIO_LIST}" | sed 's,'"^"','"$TESTING_SCENARIO_FOLDER/",'g')"
  fi

  ### check scenario files
  for TESTING_SCENARIO_FILE in ${TESTING_SCENARIO_LIST}; do
    if [ ! -f "${TESTING_SCENARIO_FILE}" ]; then
      echo "Scenario file ${TESTING_SCENARIO_FILE} is missing"
      TESTING_SCENARIO_FILE_ERROR="YES"
    else
      if [ "$(grep -c "^broadexec_parameters " "${TESTING_SCENARIO_FILE}")" -ne 1 ]; then
        echo "Scenario file ${TESTING_SCENARIO_FILE} is invalid"
        TESTING_SCENARIO_FILE_ERROR="YES"
      else
        echo "Scenario file ${TESTING_SCENARIO_FILE} is OK"
      fi
    fi
  done
  if [ -z "${TESTING_SCENARIO_FILE_ERROR}" ] && [ ! -z "${TESTING_SCENARIO_LIST}" ]; then
    echo -e "ALL scenario files seems to be OK."
  else
    echo "There is some issues with scenario files, please resolve em and run session again."
    exit 1
  fi
}

testing_execute_scenarios () {

  for TESTING_SCENARIO_FILE in ${TESTING_SCENARIO_LIST}; do

    ### display 4 horizontal lines between testing scenarios
    echo -e "\n"
    for whatever in 1 7 9 2; do #like for real look up that number, it is interesting
      printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    done

    ### load scenario data
    TESTING_SCENARIO_FILE_MESSAGE="$(cat "${TESTING_SCENARIO_FILE}" | grep "^message " | tail -n 1 | cut -d " " -f2-)"
    TESTING_SCENARIO_PARAMETERS="$(cat "${TESTING_SCENARIO_FILE}" | grep "^broadexec_parameters " | tail -n 1 | cut -d " " -f2-)"
    if [ "$(cat "${TESTING_SCENARIO_FILE}" | grep -c "^expect_start")" -eq 1 ] && [ "$(cat "${TESTING_SCENARIO_FILE}" | grep -c "^expect_end")" -eq 1 ]; then
      ### Check if position of start is before stop - paranoia
      if [ "$(grep -n '^expect_end' ${TESTING_SCENARIO_FILE} | awk -F ":" '{print $1}')" -gt "$(grep -n '^expect_start' ${TESTING_SCENARIO_FILE} | awk -F ":" '{print $1}')" ]; then
        TESTING_SCENARIO_EXPECT_AUTO_RESULTS="yes"

        ### load expect to file
        TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
        TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE_TEMP="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
        sed '/^expect_start/,$!d' ${TESTING_SCENARIO_FILE} | sed '/^expect_end/q' >> ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE_TEMP}
        sed -i '1d; $d' ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE_TEMP}
        cat ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE_TEMP} | sort -rn > ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE}
        rm ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE_TEMP}
      fi
    fi

    ### display scenario message
    if [ "${TESTING_SCENARIO_FILE_MESSAGE}" = "" 2>/dev/null ]; then
      echo -e "\nNo scenario file message found. Consider adding it for convenience of your colleagues."
    else
      echo -e "\nScenario ${TESTING_SCENARIO_FILE} message:\n${TESTING_SCENARIO_FILE_MESSAGE}\n"
    fi
    echo -e "\nExecuting ./broadexec.sh ${TESTING_SCENARIO_PARAMETERS}"
    echo "Press ENTER to continue..."
    read

    ### run scenario
    if [ "${TESTING_SCENARIO_PARAMETERS}" = "" 2>/dev/null ]; then
      echo "Failed to obtain parameters for broadexec run, please check manually."
    else
      if [ "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS}" = "yes" ]; then
        TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
        ./broadexec.sh ${TESTING_SCENARIO_PARAMETERS} | sort -rn > ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
      else
        ./broadexec.sh ${TESTING_SCENARIO_PARAMETERS}
      fi
    fi

    ### check auto results
    if [ "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS}" = "yes" ]; then
      if [ "$(diff ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE} | wc -l)" -eq 0 ]; then
        echo -e "\nTEST SUCCESSFULL\n"
#diff ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
#echo "RETURN $?"
#
#echo
#echo "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE}"
#cat ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE}
#echo "${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}"
#cat ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
      else
        echo -e "\nERROR: There are differences between expectation and real results. CHECK!\n"
        diff ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
      fi
      rm ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
    fi
  done
}

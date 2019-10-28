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

  if [ ! -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
    echo "BRDEXEC SELFTEST: Running $(cat "${TESTING_SCENARIO_FILE}" | grep -c "^scenario ") test cases."
  fi

  ### check if list/scenario files are existing
  if [ ! -f "${TESTING_SCENARIO_FILE}" ]; then
    echo "Scenario or list provided does not exists"
    exit 1
  fi

  ### displaying scenario list message
  TESTING_SCENARIO_LIST_MESSAGE="$(cat "${TESTING_SCENARIO_FILE}" | grep "^message " | tail -n 1 | cut -d " " -f2-)"
  #if [ "${TESTING_SCENARIO_LIST_MESSAGE}" = "" 2>/dev/null ]; then
  #  echo "No scenario list message found. Consider adding it for convenience of your colleagues."
  #else
  #echo -e "\nScenario ${TESTING_SCENARIO_FILE} message:\n${TESTING_SCENARIO_LIST_MESSAGE}\n"
  #fi

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
        if [ -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
          echo -e "Scenario file ${TESTING_SCENARIO_FILE} is \e[32mOK\e[0m"
        fi
      fi
    fi
  done
  if [ -z "${TESTING_SCENARIO_FILE_ERROR}" ] && [ ! -z "${TESTING_SCENARIO_LIST}" ]; then
    if [ -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
      echo -e "ALL scenario files are \e[32mOK\e[0m"
    fi
  else
    echo "There is some issues with scenario files, please resolve them and run session again."
    exit 1
  fi
}

testing_execute_scenarios () {

  if [ -f ./conf/selftest.conf ]; then
    . ./conf/selftest.conf
  fi

  for TESTING_SCENARIO_FILE in ${TESTING_SCENARIO_LIST}; do

    ### load scenario data
    TESTING_SCENARIO_FILE_MESSAGE="$(cat "${TESTING_SCENARIO_FILE}" | grep "^message " | tail -n 1 | cut -d " " -f2-)"
    TESTING_SCENARIO_PARAMETERS="$(cat "${TESTING_SCENARIO_FILE}" | grep "^broadexec_parameters " | tail -n 1 | cut -d " " -f2-)"
    TESTING_SCENARIO_PARAMETERS_NEW="$(echo "${TESTING_SCENARIO_PARAMETERS}" | sed -e "s|TESTING_SCENARIO_FOLDER|${TESTING_SCENARIO_FOLDER}|g" )" && TESTING_SCENARIO_PARAMETERS="${TESTING_SCENARIO_PARAMETERS_NEW}"
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
        testing_filter_host "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE}"
      fi
    fi

    #  echo -e "\nScenario ${TESTING_SCENARIO_FILE} message:\n${TESTING_SCENARIO_FILE_MESSAGE}\n"
    if [ -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
      echo -e "\nExecuting ${TESTING_SCENARIO_FILE}\n./broadexec.sh ${TESTING_SCENARIO_PARAMETERS}"
    fi

    ### run scenario
    if [ "${TESTING_SCENARIO_PARAMETERS}" = "" 2>/dev/null ]; then
      echo "Failed to obtain parameters for broadexec run, please check manually."
      if [ ! -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
        exit 1
      fi
    else
      if [ "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS}" = "yes" ]; then
        TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
        TESTING_SCENARIO_TEMP_FILE="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
        ./broadexec.sh ${TESTING_SCENARIO_PARAMETERS} > ${TESTING_SCENARIO_TEMP_FILE} 2>&1
        cat $TESTING_SCENARIO_TEMP_FILE | sort -rn > ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
      else
        ./broadexec.sh ${TESTING_SCENARIO_PARAMETERS}
      fi
    fi

    testing_filter_host "${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}"

    TESTING_SCENARIO_TEMP_EXCLUDE_FILE="$(mktemp /tmp/broadexec_testing_lib.XXXXXXXXXX)"
    while read TESTING_EXCLUDE_LINE; do
      if [ "$(echo "${TESTING_EXCLUDE_LINE}" | grep -c "^exclude_line ")" -eq 1 ]; then
        cp -p "${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}" $TESTING_SCENARIO_TEMP_EXCLUDE_FILE
        cat $TESTING_SCENARIO_TEMP_EXCLUDE_FILE | grep -v "$(echo "${TESTING_EXCLUDE_LINE}"  | cut -d " " -f2- )" > "${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}"
      fi
    done < "${TESTING_SCENARIO_FILE}"
    rm $TESTING_SCENARIO_TEMP_EXCLUDE_FILE

    ### check auto results
    if [ "${TESTING_SCENARIO_EXPECT_AUTO_RESULTS}" = "yes" ]; then
      if [ "$(diff ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE} | wc -l)" -eq 0 ]; then
        if [ ! -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
          echo -e "$(echo "${TESTING_SCENARIO_FILE}" | awk -F "/" '{print $4}' | awk -F "_" '{print $1}'): \e[32mOK\e[0m; \c"
        else
          echo -e "\e[32mTEST SUCCESSFULL\e[0m"
        fi

      else
        if [ ! -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
          echo -e "$(echo "${TESTING_SCENARIO_FILE}" | awk -F "/" '{print $4}' | awk -F "_" '{print $1}'): \e[91mFAIL\e[0m; \c"
          BRDEXEC_TESTING_GITHOOK_ERROR=true
        else
          echo -e "\n\e[91mERROR:\e[0m There are differences between expectation and real results. \e[91mCHECK!\e[0m\n"
          diff ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
        fi
      fi
      rm ${TESTING_SCENARIO_EXPECT_AUTO_RESULTS_FILE} ${TESTING_SCENARIO_REAL_AUTO_RESULTS_FILE}
    fi
  done
  if [ ! -z "${BRDEXEC_TESTING_GITHOOK}" ]; then
    echo
    if [ ! -z "${BRDEXEC_TESTING_GITHOOK_ERROR}" ]; then
      exit 1 # tell git not to commit if any of the tests fail
    fi
  fi
}

testing_filter_host () {

  for BRDEXEC_HOST_ITEM in $(seq 10); do
    if [ ! -z "${BRDEXEC_TEST_HOST[$BRDEXEC_HOST_ITEM]}" ]; then
      sed -i "s/brdexec_test_host${BRDEXEC_HOST_ITEM}/${BRDEXEC_TEST_HOST[$BRDEXEC_HOST_ITEM]}/g" "${1}"
    fi
  done
}

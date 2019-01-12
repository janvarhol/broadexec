### this is os release library for broadexec

osrelease_get_os_version () {

  OS_PLATFORM="$(uname -s)"
  #FIXME - add hw platform based on "dmidecode -t system" - vmware,hp,dell,fujitsu

  #FIXME - add case condition to start the following code only in case of Linux platform
  ### check strict os_release files
  if [ -f /etc/oracle-release ]; then
    BRDEXEC_OS_RELEASE=oracle
    BRDEXEC_OS_MAJOR_VERSION="$(cat /etc/oracle-release | sed 's/.*release \([0-9.][0-9.]*\).*/\1/' | awk -F "." '{print $1}')"
    BRDEXEC_OS_MINOR_VERSION="$(cat /etc/oracle-release | sed 's/.*release \([0-9.][0-9.]*\).*/\1/' | awk -F "." '{print $2}')"
  elif [ -f /etc/redhat-release ]; then
    BRDEXEC_OS_RELEASE=redhat
    BRDEXEC_OS_MAJOR_VERSION="$(cat /etc/redhat-release | sed 's/.*release \([0-9.][0-9.]*\).*/\1/' | awk -F "." '{print $1}')"
    BRDEXEC_OS_MINOR_VERSION="$(cat /etc/redhat-release | sed 's/.*release \([0-9.][0-9.]*\).*/\1/' | awk -F "." '{print $2}')"
  elif [ -f /etc/SuSE-release ]; then
    BRDEXEC_OS_RELEASE=sles
    
    BRDEXEC_OS_MAJOR_VERSION="$(grep VERSION /etc/SuSE-release | awk -F "=" '{print $2}' | awk '{$1=$1};1')"
    BRDEXEC_OS_MINOR_VERSION="$(grep PATCHLEVEL /etc/SuSE-release | awk -F "=" '{print $2}' | awk '{$1=$1};1')"
  else
    echo "BRD_UNSUPPORTED Unable to get OS version."
    exit 1
  fi

  ### check OS detection results
  if ! [ "${BRDEXEC_OS_MAJOR_VERSION}" -eq "${BRDEXEC_OS_MAJOR_VERSION}" ]; then
    echo "BRD_UNSUPPORTED Unable to get OS version."
    exit 1
  fi
  if ! [ "${BRDEXEC_OS_MINOR_VERSION}" -eq "${BRDEXEC_OS_MINOR_VERSION}" ]; then
    echo "BRD_UNSUPPORTED Unable to get OS version."
    exit 1
  fi
  if [ -z "${BRDEXEC_OS_MAJOR_VERSION}" ]; then
    echo "BRD_UNSUPPORTED Unable to get OS version."
    exit 1
  fi
}

osrelease_check () {

  osrelease_get_os_version

  ### check if version control is activated
  if [ ! -z "${BRDEXEC_SUPPORTED_OS}" ]; then
    ### check if it is on supported OS release
    if [ "$(echo "${BRDEXEC_SUPPORTED_OS}" | grep -c ${BRDEXEC_OS_RELEASE})" -gt 0 ]; then

      ### check against min OS version
      if [ ! -z "${BRDEXEC_SUPPORTED_OS_VERSION_MIN[$BRDEXEC_OS_RELEASE]}" ]; then
        ### check against min major version
        if [ "${BRDEXEC_OS_MAJOR_VERSION}" -ge "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MIN[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $1}')" ]; then
          ### check against min minor version in case minimum major is the same as actual
          if [ "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MIN[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $1}')" -eq "${BRDEXEC_OS_MAJOR_VERSION}" ]; then
            if [ "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MIN[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print NF}')" -gt 1 ]; then
              if [ "${BRDEXEC_OS_MINOR_VERSION}" -lt "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MIN[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $2}')" ]; then
                echo "BRD_UNSUPPORTED Minor release of OS is older than supported for this script."
                exit 1
              fi
            fi
          fi
        else
          echo "BRD_UNSUPPORTED Major release of OS is older than supported for this script."
          exit 1
        fi
      fi

      ### check against max OS version
      if [ ! -z "${BRDEXEC_SUPPORTED_OS_VERSION_MAX[$BRDEXEC_OS_RELEASE]}" ]; then
        ### check against max major version
        if [ "${BRDEXEC_OS_MAJOR_VERSION}" -le "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MAX[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $1}')" ]; then
          ### check against min minor version in case minimum major is the same as actual
          if [ "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MAX[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $1}')" -eq "${BRDEXEC_OS_MAJOR_VERSION}" ]; then
            if [ "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MAX[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print NF}')" -gt 1 ]; then
              if [ "${BRDEXEC_OS_MINOR_VERSION}" -gt "$(echo "${BRDEXEC_SUPPORTED_OS_VERSION_MAX[$BRDEXEC_OS_RELEASE]}" | awk -F "." '{print $2}')" ]; then
                echo "BRD_UNSUPPORTED Minor release of OS is newer than supported for this script."
                exit 1
              fi
            fi
          fi
        else
          echo "BRD_UNSUPPORTED Major release of OS is newer than supported for this script."
          exit 1
        fi
      fi

    else
      echo "BRD_UNSUPPORTED OS release not supported for this script."
      exit 1
    fi
  fi
}

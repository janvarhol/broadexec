#!/bin/bash

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


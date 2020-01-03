# Release notes

Broadexec is in beta. It's functional, tested, but there might be some bugs. 

Starting with beta release backwards compatibility is one of our priorities. Development info and date of a new release can be found at the end of this document. Versioning is A.B.C (If A is 0, it's still beta, when B is increased there was functional update adding some feature, if C is increased there was hotfix update; there is no correlation between B and C).

## Known issues

- Admin functions are not able to fix any unwanted state, eg. when admin user is locked

## 0.8.2 coming soon

  * fixed os detection library not working when using embeded code
  * fixed report file not being enhanced when normal output was
  * fixed bug in menu for selection of hostlists, default hostlist selectable just via ENTER had numbes as any other menu item, but it was disabled

## 0.8.1 first hotfix - released

  * os detection library is now detecting OS platform as well (linux, HPUX, Solaris, aix)
  * added/fixed -H option to enable running scripts on selection of hosts without hostlist
  * added testing library for extensive automated testing of any scripts with output checking for consistency during development
  * admin function for adding entries to ssh config file is now considerably faster (taking seconds instead of minutes)

## 0.8.0 first beta - released

  * Fixed links created during installation to teamconfig entries
  * Fixed undeleted files in /tmp with etchosts entries and in case CTL+C is pressed
  * Fixed wrong display of error output with special characters in main error output, this solution now requires perl to be installed on jump server
  * Fixed not writing reports while in very quiet mode
  * Fixed autoupdate feature for core broadexec files and teamconfigs
  * <del>Fixed -H parameter that was disabled during development</del>
  * Fixed admin function to generate ssh_config  to scan and add only hosts from current hostlist, not every host ftom hosts file
  * Added --version parameter to display broadexec version
  * Enhanced admin function to display progress at any time to prevent "blind waiting" for check of connection and check & fix password expiration

## 0.8.x cumulative initial internal release

  * Basic broadexec functionality: run script on hosts from hostlist on many hosts at the same time
  * Ability to specify list of hosts via command line parameter
  * Possibility to display human readable code (by default script output from one host is displayed on one line)
  * Possibility to display only list of hosts with keyword, grep like behavior, only instead of script output it displays hostname
  * Ability to blacklist unwanted phrases eg. logname errors on some distros
  * Hostfile filters: multiple multilevel filters for better targeting are possible to use, see documentation
  * Ability to distribute files to multiuple hosts
  * Admin mode: ability to distribute ssh keys, fill known hosts, check connectivity or delete ssh keys of not used accounts
  * Quiet mode that displays only script outputs or nothing (only writes report files)
  * Reporting: every broadexec run creates report + error report (if run with grep option it will create list of hosts)
  * Logging: by default all errors are logged, in config file logging can be switched off of set to log all warnings and messages, not only errors
  * Configuration: Almost all broadexec variables are configurable on personal or team level (by using teamfolders only team admin has to prepare config, scripts and hostlists, others can download them via automatic updates), some of them can be overriden by command line parameters or set inside custom scripts. For more info see documentation.
  * OS detection: if enabled in custom script (see documentation) broadexec can detect what kine of OS and what major/minor version is installed and prevent unsupported scripts from running there. Completely manageable by script developer.
  * Teamfolders: every team can have common teamfolder with custom scripts, hostfiles and configurations.
  * Questions and embeded built in framework: before scripts are distributed, broadexec have 2 ways of asking for/checking information from user or environment. Questions are for fast and easy questions, embeded framework is without limitations of complexity, see documentation for details.
  * Security: Everything can be hacked, security in broadexec is based upon access rights. You can't do something nasty with broadexec which you couldn't do by yourself. However to prevent running anything accidentally by anyone with access, broadexec verifies it's consistency and consistency of libraries. Scripts used by broadexec are checked against GPG and must be signed so in case somebody modified it, broadexec will stop with error.
  * Cleanup: during broadexec run many temp files are created, broadexec is not leaving anything behind apart from logs (which can be switched off) and reports (which can be set to automatically cleaned up in config file). In case broadexec is interrupted by CTRL+C it will first perform cleanup and then exits. In case there are some scripts running via ssh it will first try and stop them, then perform cleanup.

## Development version 0.9 to be released: unknown

  * DONE:TESTED:current progress is adding more test scenarios - Testing library version 2: Added automatic checking of outputs by testing scripts, so code integrity verification is automatic and human checking of different behaviour after update is no longer needed.
  * DONE:TESTED - Fixed all tmp files created by broadexec by mktemp are now labelled with broadexec in the name for better tracking.
  * WIP - Getopts library - broadexec solution of getting parameters in better way than bash getopts, but usable by any script.
  * WIP - Broadexec progress stats - ability to call broadexec from other script and getting proper data. Pilot script is checking if new UID is really unique on all hosts before creating user with it. It can also display just progress without output which is read just by external script.
  * <del>DONE:UNDERGOING TESTS - Embeded custom scripts parameters - ability to forward parameters for script run by broadexec via command line. Needed for scripts which requires them and are needed to run in batch mode.</del> Moved and implemented in hotfixes.
  * <del>DONE:TESTED - Fixed -H parameter that was disabled during development</del> Moved and implemented in hotfixes.


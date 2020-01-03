# User's manual

## Installation

Broadexec need connection to git server in case to be installed or updated. After it is installed, it can run without this connection.

## First use

Just run it. Without any parameters, broadexec will guide you through menu to select script and hostfile available for you and run it. Run broadexec.sh -h for more options. Also note the helper line that displays how you can run it in the future without the use of interactive menu. 

## Formatting output

Default view of broadexec output may depend on settings in scripts or of your teamconfigs folder, but you can alter it to your needs. 
-e (enhanced, human readable) parameter stops default display of all output from host in one line.
-g behaves like grep, only displays hostnames with phrase in script output; -i behaves like grep -i with case insensitivity

In case there are some unwanted lines or annoying messages in output, they can be blacklisted via blacklist file in your teamconfig conf folder. 

There are more ways to change output in template config file in templates/conf folder.

## Hostfile filters

You can specify filters in columns of hostfiles (or use provided filtering) for better hostfiles customization. You don't need to track as many changes in more than one file. You can use multilevel filtering or combine more filters at once. For example if you use filter -f prod for this hostfile
   host1 prod
   host2 test pilot
   host3 test
   host4 prod
broadexec will execute script only on host1 and host4.

Example of multilevel filtering would be using pilot testing -f test.pilot on hostlist above. Broadexec will execute script only on host2. It will first filter every line where there is test in first filter column and then searches for all lines where there is pilot in second filter column. 

Here is another example using more customers in one hostfile. Using multiple filters ./broadexec -f customer1.test.pilot -f customer2.test.pilot on following hostlist
   host1 customer1 prod
   host2 customer1 test pilot
   host3 customer1 test
   host4 customer2 test
   host5 customer2 test pilot
   host6 customer2 prod
will execute script on host2 and host5. 

You can combine as many filters and use as many levels as you wish, there are no limits.

## Reporting

Output of each broadexec run is stored as report. If there are some errors, separate error report is created. In case broadexec grep functionality is used, also list report file is created. Default path is ./reports folder. By default reports are stored indefinetly, if you want old reports to be deleted automatically, add followinh line into your config and set number of days you want to keep reports.
BRDEXEC_REPORT_CLEANUP_DAYS=90

## Distributing files

You can distribute any file provided to -c parameter to /tmp or any home (sub)directory provided by -d (destination) parameter. Destination directory must exist on all hosts. File size is not limited. Files are not distributed at once so the jump server up-link does not get overloaded.

## Configuration

Generally there is no need to configure anything after successful installation. If there were no issues during installation, you can find conf/broadexec.conf file containing at least name of your team and SSH tunnel port number. Everything else should already be configured from your teamconfig conf/broadexec.conf file or in script itself. 

## Errors

  * 0 - successful run
  * 1 - wrong input: used as default output in case actual issue could not be determined
  * 110 - Wrong filter. You probably have typo or trying to use wrong hostlist with not existing filter.
  * 112 - Hostfile is empty or you made typo
  * 113,114 - Script is not signed. You probably modified the script and broadexec is preventing you to run it due to security checks. You probably need to make fresh install
  * 120 - Wrong menu selection
  * 121 - Script not found. You probably need fresh install or update of broadexec
  * 123 - Report file could not be created. Either issue with permissions or specified folder for reporting does not exist
  * 124 - Incomplete specification while in batch mode. Broedexec needed to display menu while in batch mode
  * 170 - When copying files, destination should be defined only as absolute path to prevent any mishaps
  * 171 - Source file is missing when trying to copy files
  * 172 - You tried to provide destination folder for copying using 2 dots which is forbidden to prevent any mishaps
  * 173 - Broadexec is not allowed to copy anywhere else than /tmp and subfolders of /home, see documentation for more details
  * 180 - Folder with hostfiles is missing. You probably need to reinstall or update broadexec
  * 181 - No hostfiles can be found in host folder. You probably need to reinstall or update broadexec
  * 200 - Folder for logfiles is missing and could not be created. Check permissions or configuration
  * 201 - Broadexec is unable to reset last run logfile. Check permissions of logs folder
  * 2060 - Highly improbable, but in case important file with script output data is deleted during broadexec run, this is displayed 
  * 211 - When filter is specified but hostlist is not. Either run broadexec without -h and -f parameter and use menus, or provide both on command line
  * 213,214,215,216,217 - Wrong input, you user parameter which does not require parameter but you used one. Probably typo
  * 218 - You dit not provided file to be copied in command line or typo
  * 219,2100,2101,2102 - Conflicting input. You are trying to use different functions of broadexec which does not go together
  * 2103,2104 - More than one hostlist/script provided. Broadexec can't utilize multiple hostlists/scripts in one run
  * 2120 - Script provided is not a file. It might be missing, folder or link. For security reasons broadexec will not run it

## Advanced configuration

templates/broadexec.conf.template is pretty selfexplanatory and shows you what you can configure. Most of things needed would be already configured by install.

  * BRDEXEC_USER - is usually defined by teamconfig, can be also overriden by command line parameter at runtime
  * BRDEXEC_USER_SSH_KEY - in case broadexec is using other than default ssh keys for your user
  * BRDEXEC_RUNSHELL - in case broadexec needs to be run on hosts with different sudo capabilities you can change sudo behaviour with runshell setting
  * BRDEXEC_TEAM - team is set during install, but can be overriden with this setting without reinstall
  * BRDEXEC_DEFAULT_TEAMCONFIG_FOLDER - this is added for backwards compatibility, you should not change it unless you know what you are doing
  * BRDEXEC_DEFAULT_HOSTS_FOLDER - used to override path to default hosts folder
  * BRDEXEC_DEFAULT_HOSTS_FILE_PATH - used to set default hostlist file path for example if you are using one hostlist most of the time and you are not specifying it via -h parameter, this can help you save some time as this entry is automatically preloaded when menu selection is displayed and you just need to press ENTER
  * BRDEXEC_ERROR_BLACKLIST_FILE - override of default blacklist file to prevent unwanted messages from showing up
  * BRDEXEC_REPORT_PATH - used to override default path to reports
  * BRDEXEC_LOG_PATH - used to override default path to logfiles
  * BRDEXEC_SSH_CONNECTION_TIMEOUT - override for default ssh connection timeout
  * BRDEXEC_SCRIPT_RUN_TIMEOUT - override for total timeout for broadexec script run. It is counted from last ssh initiation
  * BRDEXEC_PROCESS_KILL_TIMEOUT - override for how long should broadexec wait after killing processes in case of timeout or CTRL+c
  * BRDEXEC_CTRLC_PROCESS_KILL_TIMEOUT - override of timeout for CTRL+c command for proper clearing stopped processes
  * BRDEXEC_REPORT_DISPLAY_ERRORS - used to override for not showing errors in case it is fully sorted by scripts you are using
  * BRDEXEC_HUMAN_READABLE_REPORT - override for sticking report format in oneliner format and not human readable even when broadexec is run via human readable mode
  * BRDEXEC_REPORT_CLEANUP_DAYS - disabled by default, reports older than this setting will be automatically deleted
  * LOG_LEVEL - used for troubleshooting/development, default log level is 1, logging just errors and issues. Logs can be disabled by setting this to 0 or put to fully verbose by setting it to 2
  * BRDEXEC_OUTPUT_HOSTNAME_DELIMITER - override for hostname delimiter for oneline outputs, if not set, default is space

## Broadexec inbuilt admin functions

TODO

## Signing scripts

TODO

## Questions framework

FIXME

Declaration of questions from scripts should be variable name in special format and string attached to variable is question asked.
Variable format:
BRDEXEC_SCRIPT_QUESTION_{parameter}_{parameter_name_to_be_passed_to_script}

First parameter is mandatory to be "r", "o" or "b".
r - question is required and without answer, script will not be run
o - question is optional and answer to it can be skipped by pressing ENTER
b - used for situation for parameters without options

For example this question in script
BRDEXEC_SCRIPT_QUESTION_r_username
will ask for username and if provided will pass answer to the script as parameter: -username ${ANSWER}

## Embedded script framework

If questions are not enough, you can ask your own, or gather other info as you wish and provide parameters with values to broadexec or interrupt broadexec run to prevent running script with improper/incomplete values.

See ./templates/scripts/broadexec_example_embeded_script_framework.sh as example how to use this functionality. \\
Basically code you specify between ###BRDEXEC_EMBEDED START and ###BRDEXEC_EMBEDED STOP (both needs to be on beginning of line with nothing more on that line) is executed first on jump server and is omitted from your script distributed and run on selected hosts. You as script developer are responsible for correctly providing list of parameters with leading space in BRDEXEC_EMBEDED_PARAMETERS variable. In case you encounter issue or wrong user input and wish to cancel broadexec execution during this stage, you can do it by setting BRDEXEC_EMBEDED_ERROR variable to true and broadexec will exit immediately with an error. It is recommended to place this code just after shell declaration on second line as this code will be stripped together with anything before it except shell declaration line.  

## Providing parameters for script via broadexec parameter

You can forward parameters directly to script run by broadexec via -p parameter. It is useful when broadexec is run in batch mode via other script and you don't want it to ask any questions. Example:
   ./broadexec.sh  -h hosts/XXXXXXXX -s scripts/XXXXXXXX/broadexec_example_unlock_user_with_parameters.sh -p 'u admin_user'

will result in broadexec running script like this
scripts/XXXXXXXX/broadexec_example_unlock_user_with_parameters.sh  -u admin_user

You can provide multiple -p parameters. You need to ommit - character and have no other whitespaces as it can result in usage error or improper forwarding of values. Inside of embedded code you can check and interact with this parameters through BRDEXEC_QUESTION_SCRIPT_PARAMETERS variable.

## OS release detection library

All scripts are run by default without any limitation. However you can set minimum and maximum supported OS releases via variables inside scripts. Example settings for

FIXME

## Testing suite library

As broadexec got big during development with many parameters, settings and possibilities there was need to create testing/selftesting framework primarily for broadexec, but it's usable for any other scripts as well. 

To create own scenario file see some example scenario files. Until more developed, scenario is just message with what you are testing and what are you expecting. Example scenario for normal broadexec run
   message 001: normal run with hostlist and script provided by parameters. Uptime should be displayed from all hosts in hostfile.
   broadexec_parameters -h test_scenarios/broadexec_development/test_hosts -s scripts/uptime.sh
It's simple, testing algorithm searches for lines with keywords and loads the data for test. See that we am using test hostsfile so we can predict results and check output more easily and in the future, algorithm can selftest and compare results itself and just let us know if there were some issues.

Okay, one scenario is not enough, go on and create more so explanation about scenario lists will make sense. List of scenarios is config file which you will use to run all test scenarios inside, WIP version looks like this
   message This is for now main list for broadexec test scenarios. folder test_scenarios/broadexec_development
   scenario 001_normal_run.scenario
   scenario 002_one_filter.scenario
   scenario 003_one_multilevel_filter.scenario
   scenario 004_simple_grep.scenario
Message will be displayed before any scenario run with info about this list. You can create lists just for checking some parameters based on your needs. Folder keyword is just shorthand you can use if you don't want to provide all relative/absolute path to every scenario.Then every scenario is run in order it is written in the list.

Example test suite run with broadexec dev testing scenario
   ./broadexec.sh --run-test-scenario test_scenarios/broadexec_dev.list

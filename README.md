# broadexec

=== unfinished ===

Simple execute everywhere via ssh script that does not need any clients installed.

## What is Broadexec

* runs your scripts on many hosts at the same time
* userfriendly and usable out of the box, but customizable as hell if needed
* framework - you need to tell it which scripts and where you want to be executed
* very fast, compatible with any linux running bash 3+ (and some additional SW like gpg, nothing special...)
* clientless and secure (completely opensource)
* some of the main advanced features: use own hostlists with unlimited multilevel filters, reporting, enhanced output manipulation, own test library and many more

## What it isn't

* no, it's not "just a looop" - scripts must be verified, reports re created, each standard/error output is being checked
* complete automation solution - broadexec was always quick and dirty way to execute something relatively safely, without the hassle of big automation software, but also without risks and limitations of manually distributing custom scripts

## Prerequisities

* jump server or linux workstation from which all hosts in hostfile(s) are accessible
* user with admin righs to run the scripts on all hosts with the same password
* bash 3+, perl, GPG
* Python - only for admin options


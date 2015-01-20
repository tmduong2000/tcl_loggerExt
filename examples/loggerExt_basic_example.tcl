#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

################################################################################
# AUTHOR  : Tuyen M. Duong (http://www.tduongsj.com)                           #
# DATE    : 2015-01-02                                                         #
################################################################################

package require Tcl 8.4

lappend ::auto_path .
package require loggerExt 1.0.0

namespace import ::loggerExt::*

proc test_loggerExt { logObj msg } {
    foreach lvl [::logger::levels] {
        ${logObj}::$lvl $msg
    }
}

# configure all log levels with
#   - france-date-style at the following format
#        abbr. moth and time zone (e.g Dec 11-12-2014 PST),
#   - user name
#   - caller where log is invoked
#   - log service name
#   - log prirority
#   - message is enclosed by double quoute, other are enclosed by square bracket

set log [::logger::init logConsole]
configureLogger ${log} \
    -levels {all}\
    -custom {[exec date "+%a %d-%m-%Y %T %Z"]}\
    -custom1 {[exec whoami]}\
    -format {[%custom%] [%custom1%] [%caller%]\
        [%category%] [%priority%] "%message%"}

test_loggerExt ${log} "Good morning America!"


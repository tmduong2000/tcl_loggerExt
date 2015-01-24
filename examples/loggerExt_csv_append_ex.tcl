#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

################################################################################
# AUTHOR  : Tuyen M. Duong (http://www.tduongsj.com)                           #
# DATE    : 2015-01-23                                                         #
################################################################################

package require Tcl 8.4

lappend ::auto_path ./../
package require loggerExt 1.0.0

namespace import ::loggerExt::*

proc test_loggerExt { logObj msg } {
    foreach lvl [::logger::levels] {
        ${logObj}::$lvl $msg
    }
}

# configure all log levels with
#   - date-style at the following format: [Full month dd, yyyy HH:MM::SS timezone]
#   - [hostname, username]
#   - [caller where log is invoked]
#   - [log prirority]
#   - message is enclosed by double quote
#   - append all log message to file: csv_append_example.csv at current
#        working directory

set log [::logger::init logConsole]

setConfigOption filename "csv_append_example.csv"

configureLogger ${log} \
    -levels {all}\
    -custom {[exec date "+%B %d, %Y %T %Z"]}\
    -custom1 {[exec whoami]}\
    -writetype {filename}\
    -filetype {csv}\
    -format {[%custom%] _csv_ [%hostname%, %custom1%] _csv_ \
        [%caller%] _csv_ [%priority%] _csv_ "%message%"}

${log}::info "Hey, why do my computer is so slow?"
after 1000
${log}::info "Really, I have this experience a few ago.  Now, it is OK."
after 1000
${log}::info "Wow, terrific, how can I fix my PC?"
after 1000
${log}::info "Try to close unused application"
after 1000
${log}::info "Oh yah, this is sound good to me.  Thanks."
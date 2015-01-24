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

set log [::logger::init logConsole]

setConfigOption filename "csv_header_prepend_example.csv"
setConfigOption writeaccessmode "prepend"

# use seperator "_c_" instead of "_csv_"
setConfigOption seperator "_c_"

# part 1
# ------
# create header log message file and prepend to file: csv_header_prepend_example.csv
#    at current working directory
# the header will be "date", "hostname, username", "called method", "log priority"
#     , and "data""

setConfigOption prependposition "0"
configureLogger ${log} \
    -levels {all}\
    -custom1 {Date}\
    -custom2 {Hostname, Username}\
    -custom3 {Called method}\
    -custom4 {Log priority}\
    -custom5 {Data}\
    -writetype {filename}\
    -filetype {csv}\
    -format {%custom1% _c_ %custom2% _c_ \
        %custom3% _c_ %custom4% _c_ %custom5%}

${log}::info "dont' care"

# part 2
# configure all log levels with
#   - date-style at the following format: [Full month dd, yyyy HH:MM::SS timezone]
#   - [hostname, username]
#   - [caller where log is invoked]
#   - [log prirority]
#   - message is enclosed by double quote
#   - prepend all log messages to file: csv_header_prepend_example.csv at current
#        working directory
#   - prepended log message must be logged at second line (Note: assuming header
#        is occupied the first line.  If header contaning more than one line,
#        then use the prepending position to insert new log message to file.
#        In this example, insert at second line)

# insert log after header (assuming header is defined at first line)
setConfigOption prependposition "1"
configureLogger ${log} \
    -levels {all}\
    -custom {[exec date "+%B %d, %Y %T %Z"]}\
    -custom1 {[exec whoami]}\
    -writetype {filename}\
    -filetype {csv}\
    -format {[%custom%] _c_ [%hostname%, %custom1%] _c_ \
        [%caller%] _c_ [%priority%] _c_ "%message%"}

${log}::info "Hey, why do my computer is so slow?"
after 1000
${log}::info "Really, I have this experience a few ago.  Now, it is OK."
after 1000
${log}::info "Wow, terrific, how can I fix my PC?"
after 1000
${log}::info "Try to close unused application"
after 1000
${log}::info "Oh yah, this is sound good to me.  Thanks."
after 1000
${log}::info "uhm, my girlfriend told me: \"You open to many window!!\""
after 1000
${log}::info "Well, PC experts suggest : \"Reserve your PC resource.\""
after 1000
${log}::info "That's it.  Now, I know what is going on with my PC."

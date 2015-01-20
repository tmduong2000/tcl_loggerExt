#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

################################################################################
# copyright © 2104 Tuyen M. Duong (http://www.tduongsj.com)                    #
#       under GNU GPL v3 licence (http://www.gnu.org/licenses/gpl-3.0.html)    #
################################################################################
# configureLogger v.1.0.0 copyright © 2014  Tuyen M. Duong                     #
# This program comes with ABSOLUTELY NO WARRANTY.  This is free software, and  #
# you are welcome to redistribute it under certain condition.                  #
################################################################################
#                                                                              #
# AUTHOR  : Tuyen M. Duong (http://www.tduongsj.com)                           #
# DATE    : 2014-12-12 (December 12, 2014)                                     #
#                                                                              #
################################################################################

package require Tcl 8.4
package require fileutil

lappend ::auto_path .
package require loggerExt 1.0.0

namespace import ::loggerExt::*

proc execAllLogMessages { logObj msg } {
    foreach lvl [::logger::levels] {
        ${logObj}::$lvl $msg
    }
}

# EXAMPLE 1: configure all log levels with france-date-style at the following format
#   abbr. moth and time zone (e.g Dec 11-12-2014 PST), user name, caller
#   where log is invoked, log prirority, and log message.  message is enclosed
#   by double quoute, other are enclosed by square bracket

puts "Example 1: apply 'log' service for all log levels to console with this format,"
puts [string repeat - 9]

set log [::logger::init logConsole]

configureLogger ${log} \
    -levels all\
    -custom {[exec date "+%D %T"]}\
    -custom1 {[exec whoami]}\
    -format {[%custom%] [%category%] [%priority%] "%message%"}

execAllLogMessages ${log} "Good morning America!"

puts "\n[string repeat * 80]\n"

# EXAMPLE 2: reset all log levels to default setting

puts "Example 2: restore 'log' service for all log levels to console  with this format,"
puts [string repeat - 9]
configureLogger ${log} -reset all

execAllLogMessages ${log} "all log mesages being reset to default format."


puts "\n[string repeat * 80]\n"

# EXAMPLE 3: Write log message to ./demo_log.txt file where log is configured
#   all log with American date time at the following format abbr. weekday, abbr.
#   moth, date time, and time zone (e.g. Thu Dec 12/11/2104 PST), caller
#   where log is invoked, log prirority, and log message.  message is enclosed
#   by single quoute, other are enclosed by square bracket.
#
#   second, configure the same log service for (debug, error) with additional
#   working directory, user name, pid, hostname that must follow this format
#   [date] [pid@hostname of user name] [directory:pwd] [caller] [priority] 'message'
#
set logfile [::logger::init logFile]
set fileName {demo_log.txt}
set fH [open $fileName a]

puts "Example 3-1: apply 'logFile' service for all log levels to file with this format,"
puts [string repeat - 11]
configureLogger ${logfile} \
    -channel $fH\
    -levels all\
    -date {%a %b %m/%d/%Y %T %Z}\
    -format {[%date%] [%fullcategory%] [%caller%] [%priority%] '%message%'}

execAllLogMessages ${logfile} "all log messages having a same format in log file."

#eval "exec tail -8 $fileName"
puts [join [lrange [split [::fileutil::cat $fileName] "\n"] end-8 end] "\n"]

puts [string repeat - 60]


puts "Example 3-2: apply 'logFile' service to (debug, error) to file with this format,"
puts [string repeat - 11]
configureLogger ${logfile} \
    -channel $fH\
    -levels {debug error}\
    -date {%a %b %m/%d/%Y %T %Z}\
    -format {[%date%] [pid(%pid%) of %hostname%]\
        [%fullcategory%]\
        [%caller%] [%priority%] '%message%'}

execAllLogMessages ${logfile} "(debug, error) messages being configured\
    with additional data."

#eval "exec tail -8 $fileName"
puts [join [lrange [split [::fileutil::cat $fileName] "\n"] end-8 end] "\n"]

puts "\n[string repeat * 80]\n"

#
# EXAMPLE 4: reset log service logFile to default setting.
#
puts "Example 4: restore 'logFile' service to all log levels with this format,"
puts [string repeat - 9]
configureLogger ${logfile} -reset all

execAllLogMessages ${logfile} "${logfile} being reset to default\
    format.  No data is written in $fileName"

puts "\n[string repeat * 80]\n"


#
# EXAMPLE 5: to rewrite log message to log file, must apply another
#   setting to configureLogger with channel setting.  configure this format in file
#   [date (e.g. abbr. weekday abbr. moth dd HH:MM:SS time zone yyyy)] [category] [log priority] 'message'

puts "Example 5: apply 'logFile' service to all og levels with this default format,"
puts [string repeat - 9]
configureLogger ${logfile} \
    -channel $fH\
    -levels all

execAllLogMessages ${logfile} "Hello World"
#exec tail -8  $fileName
puts [join [lrange [split [::fileutil::cat $fileName] "\n"] end-7 end] "\n"]

close $fH



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

namespace eval loggerExt {
    set pkgLst {Tcl logger uuid cmdline textutil}
    foreach pkg $pkgLst {
        catch {package present $pkg} msg
        if {[string match -nocase {package*is not present} $msg]} {
            package require $pkg    
        }  
    }
    namespace export configureLogger
    
    set currentOptions {
        -levels all
        -date default
    }
}


################################################################################
# AUTHOR  : Tuyen M. Duong (http://www.tduongsj.com)
# DATE    : 2014-12-10 (December 10, 2014)
# VERSION : 1.0.0 
# FUNCTION: configureLogger
# PURPOSE : customize logger service logging new log message format to console
#    or file.  This function supports 24 flags to customize log messages.
#    These flags are:
#           %date%,     %category%, %fullcategory%, %priority%,
#           %hostname%, %pid%,      %caller%,   %message%,
#           %custom%,   %custom1%,  %custom2%,  %custom3%,
#           %custom%4,  %custom5%,  %custom6%,  %custom7%,
#           %custom%8,  %custom9%,  %custom10%, %custom11%,
#           %custom12%, %custom13%, %custom14%, %custom15%
#
#    There is available 22 options to set custom data to log.
#    These options are:
#       -channel: stdout|stderr|file handler
#       -overwrite: 1 is overwrite or 0 is not overwrite
#           + this option is only used in case of logging data to console.
#             By default, log priorities of (debug, info, notice, warning)
#             is logging stdout channel to console and vs.
#             (error, critical, alert, emergency) is logging stderr to console.
#           + if overwrite is set to 1, then any log priorities will instantiate
#             to given channel that log priorities
#           + e.g, given channel is stdout, and configure log priorities are
#             (debug, info, notice, warning, error, critical), then these
#             log levels will log to stdout
#       -reset: no or all or list of log priorities. None, or any, or all of
#           these log priorities will restore back to origin setting
#       -levels: no or all or list of log priorities. None, or any, or all of 
#           these log priorities will change to the new format of log
#       -date: default or default1 or default2 or default3 or or default4 or
#           custom format where
#           + default format:     {%Y/%m/%d %T}    ,e.g. 2014/12/11 20:50:30
#           + default1 format:   {%Y/%m/%d %T %Z}  ,e.g. 2014/12/11 20:50:30 PST
#           + default2 format: {%a %Y/%m/%d %T %Z} ,e.g. Thu 2014/12/11 20:50:30 PST
#           + default3 format:   {%Y-%m-%d %T %Z}  ,e.g. 2014-12-11 20:50:30 PST
#           + default4 format: {%a %Y-%m-%d %T %Z} ,e.g. Thu 2014-12-11 20:50:30 PST
#           + end-user can defined their custom date format based on Tcl clock command
#       -custom: end-user can specified their own command that is understood
#           by Tcl environment.
#           e.g. -custom {working directory: [exec pwd]} will print out the output
#             to stdout or stderr or file as working directory: /Users/Documents/
#       -custom1: end-unser has other option to specify second command that is
#           understood by Tcl environment.
#           e.g. -custom1 {user name: [exec whoami] } or
#           e.g. -custom1 {file demo_log.txt size: [file size ./demo_log.txt] bytes}
#           e.g. -custom1 {uname: [uname -v]}
#           e.g. -custom1 {[exec date "+%a %b %D %T %Z"]}
#       -custom2:
#        ....
#       -custom15:
#
# PARAMETERS:
#   logObj: is instance of log service
#   args: is a group of option and value
#      e.g. -reset no -channel $fileHandler -level {debug info notice} \
#               -custom1 {[exec date "+%a %b %D %T %Z"]} \
#               -format {[%custom1] [%caller%] [%priority%] [%message]}
#
# SYNOPSIS:
#   configureLogger ${logObj} ?option value? ?option value? ....
#
# -----------------------------------------------------------------------------
# EXAMPLE 1: configure all log levels with france-date-style at the following format
#   abbr. moth and time zone (e.g Dec 11-12-2014 PST), user name, caller
#   where log is invoked, log prirority, and log message.  message is enclosed
#   by double quoute, other are enclosed by square bracket
#
#       set log [::logger::init logConsole]
#       configureLogger ${log} \
#           -levels all\
#           -custom {[exec date "+%b %d-%m-%Y %T %Z"]}\
#           -custom1 {[exec whoami]}\
#           -format {[%custom%] [user: %custom1%] [%caller%] [%priority%] "%message%"}
#
# ------------------------------------------------------------------------------
# EXAMPLE 2: reset all log levels to default setting
#
#       configureLogger ${log} -reset all
#
# ------------------------------------------------------------------------------
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
#       set logfile [::logger::init logFile]
#       set fH [open "./demo_log.txt" a]
#       configureLogger ${logfile} \
#           -channel $fH\
#           -levels all\
#           -date {%a %b %m/%d/%Y %T %Z}\
#           -format {[%date%] [%fullcategory%] [%caller%] [%priority%] '%message%'}
#        
#       configureLogger ${logfile} \
#           -channel $fH\
#           -levels {debug error}\
#           -date {%a %b %m/%d/%Y %T %Z}\
#           -custom {[exec whoami]}\
#           -custom1 {[exec pwd]}\
#           -format {[%date%] [%pid%@%custom% of %hostname%]\
#                    [directory: %custom1%] [%fullcategory%]\
#                    [%caller%] [%priority%] '%message%'}
#
# ------------------------------------------------------------------------------
# EXAMPLE 4: reset log service logFile to default setting, and then close file
#   handler fH
#
#       configureLogger ${logfile} -reset all
#       close $fH
################################################################################

proc ::loggerExt::configureLogger {logObj args} {
    
    # configureLogger process comprises 6 parts
    #   - part 1: if option -help is used, then display configureLogger usage
    #   - part 2: call getoptions and validate its params
    #   - part 3: make sure logger service is available for use
    #   - part 4: assigned defaultformat, category, and fullcategory to
    #       logger service
    #   - part 5: call ::loggerExt::_applyLogServiceProc to apply the default format to
    #       any logger levels
    #   - part 6: call ::loggerExt::_applyLogServiceProc to apply new format to any logger levels
    
    
    set options [::loggerExt::_getUsageStr options]
    set usage   [::loggerExt::_getUsageStr usage]
    
    
    # part 1
    # print configureLogger usage if -help or -? flag is used
    if { [lsearch -regexp $args {^-(help|\?)$}] >= 0} {
        puts [::cmdline::usage $options $usage]
        return 0
    }
    
    
    # part 2
    array set params [::cmdline::getoptions args $options $usage]
    # validate params
    if { ![::loggerExt::_validateParams params] } {
        return 0
    }
    
    
    # part 3
    # make sure log service is available for use
    if { [catch {${logObj}::servicename } errMsg ] } {
        ::loggerExt::_genError $errMsg
        return 0
    }
    
    
    # part 4
    # assign defaultformat, category, fullcategory, hostname, proccessid,
    #    and caller to params
    set params(defaultformat) {[%date%] [%category%] [%priority%] '%message%'}
    #set params(category)      [${logObj}::servicename]
    #set params(fullcategory)  ${logObj}
    
    
    # part 5
    # reset log service to default format
    if {[string length $params(reset)] > 0 } {
        ::loggerExt::_applyLogServiceProc ${logObj} params reset    
    }
    
    
    # part 6
    # apply new format for log service
    if {[string length $params(levels)] > 0 } {
        ::loggerExt::_applyLogServiceProc ${logObj} params levels    
    }
    #::loggerExt::_applyLogServiceProc ${logObj} params levels
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-11)
# FUNCTION: ::loggerExt::_getUsageStr
# PURPOSE : return either options string or usage string to be used
#   for cmdline library
# PARAMS  :
#   gUsageType: can be either "options" or "usage"
# RETURN  :
#   options string if gUsageType is "options"
#   usage string if gUsageType is "usage"
proc ::loggerExt::_getUsageStr {gUsageType} {
    set channelStr "value: stdout|stderr|open file handler.  Default value is"
    set overwriteStr "value: 0|1 .  if 1 is used, then defined channel will use\
            for given log priority.  Default value is"
    set resetStr "value: no|all|sub_list of log levels.  Default value is"
    set levelsStr "value: no|all|sub_list of log levels.  Default value is"
    set dateStr "value: default|default1|default2|default3|clock format flags.\
            \n\t\t      Default value is"
    set customStr "value: any value | tcl command.  Default value is empty"
    
    set formatStr "value: concatenate string of \
            \n\t\t\t    %date%,     %category%, %fullcategory%, %priority%,\
            \n\t\t\t    %hostname%, %pid%,      %caller%,   %message%,\
            \n\t\t\t    %custom%,   %custom1%,  %custom2%,  %custom3%,\
            \n\t\t\t    %custom%4,  %custom5%,  %custom6%,  %custom7%,\
            \n\t\t\t    %custom%8,  %custom9%,  %custom10%, %custom11%,\
            \n\t\t\t    %custom12%, %custom13%, %custom14%, %custom15%.\
            \n\t\t      Default value is"
    
    set options {
        {channel.arg     stdout  $channelStr}
        {overwrite.arg   0       $overwriteStr}
        {reset.arg       no      $resetStr}
        {levels.arg      no      $levelsStr}
        {date.arg        default $dateStr}
        {custom.arg      ""      $customStr}
        {custom1.arg     ""      $customStr}
        {custom2.arg     ""      $customStr}
        {custom3.arg     ""      $customStr}
        {custom4.arg     ""      $customStr}
        {custom5.arg     ""      $customStr}
        {custom6.arg     ""      $customStr}
        {custom7.arg     ""      $customStr}
        {custom8.arg     ""      $customStr}
        {custom9.arg     ""      $customStr}
        {custom10.arg    ""      $customStr}
        {custom11.arg    ""      $customStr}
        {custom12.arg    ""      $customStr}
        {custom13.arg    ""      $customStr}
        {custom14.arg    ""      $customStr}
        {custom15.arg    ""      $customStr}
        {format.arg      {[%date%] [%category%] [%priority%] '%message%'} $formatStr}
    }
    
    set options [subst -nobackslashes -nocommands $options]
    
    set usage "usage: configureLogger log_service_cmd_var\
        ?-option value? ?-option value? ?....?\nOption:"
    
    return [eval {set $gUsageType}]
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-31)
# FUNCTION: ::loggerExt::_isExistProc
# PURPOSE : check whether log instance is already assigned new proc or not
# RETURN  :
#   1 if new proc already assign
#   0 if not
proc ::loggerExt::_isExistProc {logObj level} {
    
    if {[catch {set procName [${logObj}::logproc $level]}]} {
        return 0
    }
    
    if { $procName == "${logObj}::${level}cmd"} {
        return 0
    }
    
    return 1
}


# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_genProcName
# PURPOSE : generate a unique procName with the following format
#    ${currentNameSpace}_log_${logLevel}cmd_${serviceName}_UUID
# RETURN  :
#   return procName where format is
#       ${currentNameSpace}_log_${logLevel}cmd_${serviceName}_UUID
proc ::loggerExt::_genProcName {serviceName level} {
    
    regsub -all {::} $serviceName {_} serviceName
    set ns [namespace current]
    set lstFuncts [info procs "${ns}::log_*"]
    set id [uuid::uuid generate]
    
    set srch "${ns}::log_${level}cmd_${serviceName}"
    set tmpProcName "${srch}_${id}"
    
    if { [llength $lstFuncts] == 0} {
        return $tmpProcName
    } else {
        
        set index [lsearch -glob $lstFuncts "${srch}_*"]
        if { $index >= 0} {
            return [lindex $lstFuncts $index]
        } else {
            return $tmpProcName
        }
    }
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-11)
# FUNCTION: ::loggerExt::_getProcBody
# PURPOSE : generate procBody for ${log instance}::logproc
#    hardware options are date, priority, caller, hostname, pid, and message
#    the rest options category, fullcategory, custom, custom1-15 are set
#    to its value
# PARAMS  :
#    params: is array of all parameter
#    bodyType: selecting body format which is either default or regular.
#       Default is regular procBody, other procBody is default procBody
#
proc ::loggerExt::_getProcBody {params {bodyType regular}} {
    
    upvar $params _params
    #array set _params $params
    
    set log_prior $_params(priority)
    
    set pat {debug|info|notice|warning}
    if {[string equal -nocase $bodyType "default"]} {
        set channel [expr { [regexp $pat $log_prior] ? "stdout" : "stderr" } ]
        set formatstr $_params(defaultformat)
        set lst {date category priority message}
    } else {
        set channel $_params(channel)
        if { [regexp {^std(out|err)$} $channel] } {
            if {!$_params(overwrite)} {
                set channel [expr { [regexp $pat $log_prior] ? "stdout" : "stderr" } ]
            }
        }
        set formatstr $_params(format)
        set lst {date    category fullcategory priority\
                hostname pid      caller   message\
                custom   custom1  custom2  custom3\
                custom4  custom5  custom6  custom7\
                custom8  custom9  custom10 custom11\
                custom12 custom13 custom14 custom15}
    }
    
    regsub -all {([\[\]\(\)"])} $formatstr {\\\1} formatstr
    
    foreach key $lst {
        set item "%${key}%"
        if {$key == "date"} {
            if {[string equal -nocase $bodyType "default"]} {
                set replaceDate [clock format [clock seconds]]
            } else {
                set replaceDate [clock format [clock seconds] -format $_params(date)]
            }
            set formatstr [string map -nocase [list $item $replaceDate] $formatstr]
        } elseif {$key == "priority"} {
            set strWidth [expr {$bodyType == "default" ? "" : "-9"}]
            set replace_prior [format "%${strWidth}s" $log_prior]
            set formatstr [string map -nocase [list $item $replace_prior] $formatstr]
        } elseif {$key == "message"} {
            set formatstr [string map -nocase [list $item {$txt}] $formatstr]
        } elseif {$key == "caller"} {
            set replace_caller {[expr {[info level] >= 2 ? [lindex [info level -1] 0] : {global}}]}
            set formatstr [string map -nocase [list $item $replace_caller] $formatstr]
        } elseif {$key == "hostname"} {
            set formatstr [string map -nocase [list $item {[info hostname]}] $formatstr]
        } elseif {$key == "pid"} {
            set formatstr [string map -nocase [list $item {[pid]}] $formatstr]
        } else {
            set formatstr [string map -nocase [list $item $_params($key)] $formatstr]
        }
    }
    
    return "puts $channel \"$formatstr\";"
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_genError
# PURPOSE : throw error code and errorInfo to Tcl if message is really a
#    error message.
# ERROR CODE:
#    NO_LOGGER_SERVICE
#    INVALID_CHANNEL
#    NONE
#    and will support other ERROR CODE later
#
proc ::loggerExt::_genError {msg} {
    if {[string match "invalid command name \"::logger::tree*" $msg]} {
        set code "NO_LOGGER_SERVICE"
    } elseif { [string match {can not find channel named*} $msg] } {
        set code "INVALID_CHANNEL"
    } else {
        # define later, temporary return "NONE"
        set code "NONE"
    }
    error "ERROR($code): $msg" $msg $code
}
    
# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_configureBufferingChannel
# PURPOSE : configure stdout channel with buffering = line
#                    stderr channel with buffering = none
#                    file handler channel with buffering = none
# RETURN  :
#    if failed to configuring a channel, will throw out error code
#       and error info, and then return 0
#    otherwise, return 1
#
proc ::loggerExt::_configureBufferingChannel {chan} {
    if { [string equal -nocase $chan "stdout"] } {
        # stdout channel: reset buffering to line
        if { [catch {fconfigure stdout -buffering line } errMsg ] } {
            ::loggerExt::_genError $errMsg
            return 0
        }
    } elseif { [string equal -nocase $chan "stderr"] } {
        # stderr channel: reset buffering to none
        if { [catch {fconfigure stderr -buffering none } errMsg ] } {
            ::loggerExt::_genError $errMsg
            return 0
        }
    } else {
        # file channel: set buffering to none
        if { [catch {fconfigure $chan -buffering none } errMsg ] } {
            ::loggerExt::_genError $errMsg
            return 0
        }
    }
    return 1
}
    
# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_validateLevels
# PURPOSE : verify that the provided log priorities is a valid log levels
# RETURN  :
#    if invalid log priority, will throw out error code
#       and error info, and then return _error_
#    otherwise, return a list of valid log levels
#
proc ::loggerExt::_validateLevels {levels} {
    set log_levels [::logger::levels]
    array set arr {}
    
    foreach lvl $levels {
        set lvl [string tolower $lvl]
        set index [lsearch -glob $log_levels "${lvl}*"]
        if {$index >= 0} {
            set arr([lindex $log_levels $index]) 1
        } else {
            set code "INVALID_LOG_LEVEL"
            error "ERROR($code): $msg" $msg $code
            return "_error_"
        }
    }
    return [array names arr]
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_getLogLevels
# PURPOSE : get log levels based on provided value, given value can be
#   no, all, or list of log priorities.
# RETURN  :
#    empty list if given value = "no"
#    all log priorities if given value = "all"
#    whatever from proc validateLevel if given value isn't "no" or "all"
#
proc ::loggerExt::_getLogLevels {val} {        
    if {[string equal -nocase $val "no"]} {
        return [list]
    } elseif {[string equal -nocase $val "all"]} {
        return [::logger::levels]
    } else {
        regsub -all -- {[\s,]+} $val " " val
        return [::loggerExt::_validateLevels $val]
    }
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_getDateFormat
# PURPOSE : generat date format based on given value
# RETURN  :
#    fomrat (yyyy/mm/dd HH:MM:SS)                        if val = default
#    fomrat (yyyy/mm/dd HH:MM:SS timezone)               if val = default1
#    fomrat (abbr. weekday yyyy/mm/dd HH:MM:SS timezone) if val = default2
#    fomrat (yyyy-mm-dd HH:MM:SS timezone)               if val = default3
#    fomrat (abbr. weekday yyyy-mm-dd HH:MM:SS timezone) if val = default4
#    else, don't change anything, just return its given value
#
proc ::loggerExt::_getDateFormat {val} {
    array set mapFormatTime {
        default     {%Y/%m/%d %T}
        default1    {%Y/%m/%d %T %Z}
        default2 {%a %Y/%m/%d %T %Z}
        default3    {%Y-%m-%d %T %Z}
        default4 {%a %Y-%m-%d %T %Z}
    }
    
    if { [regexp -nocase {^default\d*$} $val] } {
        return $mapFormatTime($val)
    }
    return $val
}
    
# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-10)
# FUNCTION: ::loggerExt::_validateParams
# PURPOSE : performing action and also making sure that
#    - channel can be configured
#    - log priorities must be a valid log levels and assigned to reset and levels
#    - get date format
# RETURN  :
#   1 on success to validate params
#   0 on failed
#
proc ::loggerExt::_validateParams {params} {
    upvar $params _params
    
    foreach key {channel reset levels date} {
        set val [string trim $_params($key)]
        if { $key == "channel" } {
            if { ![::loggerExt::_configureBufferingChannel $val] } {
                return 0
            }
        } elseif {$key == "reset" || $key == "levels"} {
            set new_val [::loggerExt::_getLogLevels $val]
            set _params($key) $new_val
            if { $_params($key) == "_error_"} {
                return 0
            }
        } elseif {$key == "date"} {
            set _params($key) [::loggerExt::_getDateFormat $val]
        }
    }
    return 1
}

# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-11)
# FUNCTION: ::loggerExt::_applyLogServiceProc
# PURPOSE : set the new procedure to logger on the given log priorities
#
# CHANGE: Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-31)
#    - recursive applying new proc to children and grand children log.
#
proc ::loggerExt::_applyLogServiceProc {logObj params {procType levels}} {
    upvar $params _params
    
    ::loggerExt::_applyNewProc ${logObj} _params $procType
    
    # tmduong2000 (2014-12-31)
    #recursive apply new proc to children or grand children log
    foreach service [${logObj}::services] {
        set childLog [::logger::servicecmd $service]
        
        ::loggerExt::_applyNewProc ${childLog} _params $procType
        ::loggerExt::_applyLogServiceProc ${childLog} _params $procType
    }
}


# AUTHOR  : Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-15)
# FUNCTION: ::loggerExt::_applyNewProc
# PURPOSE : set the new procedure to logger at the given log levels
#
# CHANGE: Tuyen M. Duong (tmduong2000@yahoo.com) (2014-12-31)
#    - check log instance is already owned the new proc,
#      + if log instance is being assigned the new proc, then just eval
#        proc only
#      + else, create new proc name, then eval proc and apply new proc to
#        log instance
#
proc ::loggerExt::_applyNewProc {logObj params procType} {
    upvar $params _params
    
    set bodyType [expr { $procType == "reset" ? "default" : "regular" }]
    set serviceName            [${logObj}::servicename]
    set _params(category)      $serviceName
    set _params(fullcategory)  ${logObj}
    
    foreach lvl $_params($procType) {
        
        # tmduong2000 (2014-12-31) - check whether the new proc is being assigned
        set isProcExist [::loggerExt::_isExistProc ${logObj} $lvl]
        
        if {$isProcExist} {
            # retrieve proc name from command log proc
            set procName [${logObj}::logproc $lvl]
        } else {
            # else, get new proce from api _genProcName
            set procName [::loggerExt::_genProcName $serviceName $lvl]    
        }
        
        set _params(priority) $lvl
        set procBodyTxt [::loggerExt::_getProcBody _params $bodyType]
        set procTxt [list proc $procName txt $procBodyTxt]
        # evaluate proc
        eval $procTxt
        
        # tmduong2000 (2014-12-31)
        # if new proc isn't being assigned, then assign log proc with new proc
        if {!$isProcExist} {
            ${logObj}::logproc $lvl $procName    
        }
    }
}

package provide loggerExt 1.0.0
#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

################################################################################
# AUTHOR  : Tuyen M. Duong (http://www.tduongsj.com)                           #
# DATE    : 2015-01-03                                                         #
################################################################################

package require Tcl 8.4
package require fileutil

#source ./configureLogger.tcl

lappend ::auto_path .
package require loggerExt 1.0.0

namespace import ::loggerExt::*

set log_site                 [::logger::init site]

set log_site_otherfeature    [::logger::init site::otherfeature]

set log_site_login           [::logger::init site::login]
set log_site_login_employee  [::logger::init site::login::employee]
set log_site_login_admin     [::logger::init site::login::admin]
set log_site_login_customer  [::logger::init site::login::customer]

set log_site_pages           [::logger::init site::pages]
set log_site_pages_main      [::logger::init site::pages::main]
set log_site_pages_product   [::logger::init site::pages::product]
set log_site_pages_sale      [::logger::init site::pages::sale]
set log_site_pages_portfolio [::logger::init site::pages::portfolio]
set log_site_pages_contact   [::logger::init site::pages::contact]


# configure ${log_site}
#   - date as yyyy/mm/dd HH:MM:SS timezone, e.g. 2015/01/02 23:11:09 PST
#   - caller where logger being used
#   - log service name
#   - log priority
#   - message enclosed by double quote
#   - format will be [date] [caller] [log service name] [log priority] "message"

configureLogger ${log_site} \
    -levels all\
    -custom {[exec date "+%Y/%m/%d %T %Z"]}\
    -format {[%custom%] [%caller%] [%category%] [%priority%] "%message%"}
    
# configure ${log_site_login}
#   - date as abbr. weekday abbr. month yyyy/mm/dd HH:MM:SS timezone, e.g. Fri Jan 2015/01/02 23:11:09 PST
#   - user name / machine name
#   - caller where logger being used
#   - log service name
#   - log priority
#   - message enclosed by double quote
#   - format will be [date] [user name@machine name] [caller] [log service name] [log priority] "message"

configureLogger ${log_site_login} \
    -levels all\
    -custom {[exec date "+%Y/%m/%d %T %Z"]}\
    -custom1 {[exec whoami]}\
    -format {[%custom%] [%custom1%@%hostname%] [%caller%] [%category%] [%priority%] "%message%"}

# configure ${log_site_login_customer}
#   - date as abbr. weekday abbr. month yyyy/mm/dd HH:MM:SS timezone, e.g. Fri Jan 2015/01/02 23:11:09 PST
#   - caller where logger being used
#   - log priority
#   - message will be enclosed wiht "customer: ..." 
#   - format will be [date] [caller] [log priority] "customer: message"

configureLogger ${log_site_login_customer} \
    -levels all\
    -custom {[exec date "+%Y/%m/%d %T %Z"]}\
    -format {[%custom%] [%caller%] [%priority%] "customer: %message%"}

set msg {Good morning America!}

${log_site}::info $msg

${log_site_otherfeature}::info $msg

${log_site_pages}::info $msg
${log_site_pages_main}::info $msg
${log_site_pages_product}::info $msg
${log_site_pages_sale}::info $msg
${log_site_pages_portfolio}::info $msg
${log_site_pages_contact}::info $msg


${log_site_login}::info $msg
${log_site_login_employee}::info $msg
${log_site_login_admin}::info $msg
${log_site_login_customer}::info $msg
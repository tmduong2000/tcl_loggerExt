### Usage: loggerExt library 
***

####loggerExt public VARIABLE
ATTR | DESC | v1.1.0 | v1.0.0 
--- | --- | :---: | :---:
configOptions | array type: **::loggerExt::configOptions**<br>**Purpose**: to store any extra option arguments | **Y**  | *N/A*
<br>
####current hard-code implementing in array **::loggerExt::configOptions**
KEY | VALUE | DESC 
--- | --- | ---
filename | filename (default: temp_logfile_<uuid>.txt) | writing logs to csv, html, or xml must set configOption with file name, otherwise, default file name will be used
seperator | any customized separator (default: **\_csv\_**) | only used in case of logging messages to csv-based file
writeaccessmote | **prepend**\|**append** (default: **append**) | in **append** case: will append message to end of file (text-based or csv-base) or to end of xml or html node<br>in **prepend** case: will prepend log message to prependposition starting from first line (text-based or csv-based) or html or xml node
prependposition | number (default: **0**) |


<br>
####loggerExt public API
API | SYNOPSIS / DESC | v1.1.0 | v1.0.0 
--- | --- | :---: | :---:
configLogger | **configureLogger** *${logObj} ?option value? ?option value? ....*<br>**Purpose**: customizing logger service to log messages to screen, text-based file, csv-based file, html-based file, xml-based file, writing to DB, and more ...<br>will integrate with automated test suite | **BWC** | **Y**
setConfigOption | **::loggerExt::setConfigOption** *key value*<br>**Purpose**: set public config options to array **::loggerExt::configOptions** | **Y** | *N/A*
getConfigOption | **::loggerExt::getConfigOption** *key value*<br>**Purpose**: get public config options from array **::loggerExt::configOptions**  | **Y** | *N/A*
<br/>

<span style='color: blue;'>**Note**: **BWC** stands for Backward compatible with newer version</span>

<br/>

***

####API: configLogger options
OPTION | VALUE (DEFAULT) | DESC 
--- | :---: | ---
-channel | stdout \| stderr \| open file handler **(stdout)** | I/O stream.  In this case, only used stdout, stderr, or file stream
-overwrite | 0 \| 1 **(0)** | if 1 is used, then defined channel will use for given log priority.
-writetype | filestream \| filename **(filestream)** | if -writetype is filestream (i.e I/O stream), will write logs based on -channel value, otherwise, -writetype is filename, will write logs from file name
-filetype | txt \| csv \| xml \| html **(txt)** | four file type: either text-based, csv-based, xml-based, or html-based
-reset | no \| all \| sub_list of log levels **(no)** | no: don't do reseting log service to default<br>all: reset log service to default log message format<br>any sub list of (debug, info, notice, warn, error, critical, alert, emergency)
-level | no \| all \| sub_list of log levels **(no)** | no: don't do any setting<br>all: set log service with new log message format at all log levels<br>any sub list of (debug, info, notice, warn, error, critical, alert, emergency)
-date | default \| default1-4 \| clock format flags **(default)** | **default** format: {%Y/%m/%d %T}, e.g. 2014/12/11 20:50:30<br>**default1** format: {%Y/%m/%d %T %Z}, e.g. 2014/12/11 20:50:30 PST<br>**default2** format: {%a %Y/%m/%d %T %Z}, e.g. Thu 2014/12/11 20:50:30 PST<br>**default3** format: {%Y-%m-%d %T %Z}, e.g. 2014-12-11 20:50:30 PST<br>**default4** format: {%a %Y-%m-%d %T %Z}, e.g. Thu 2014-12-11 20:50:30 PST<br>**using Tcl clock format**: end-user can defined their custom date format based on Tcl clock command
-format | anly list of flags **([%date%] [%category%] [%priority%] '%message%')** | -format option can be used with any flag or user text data<br>These flags are:<br>%date%, %category%, %fullcategory%, %priority%,<br>%hostname%, %pid%, %caller%, %message%,<br>%custom%, %custom1%, %custom2%, %custom3%,<br>%custom4%, %custom5%, %custom6%, %custom7%,<br>%custom8%, %custom9%, %custom10%, %custom11%,<br>%custom12%, %custom13%, %custom14%, %custom15%  
-custom | any custom data or function **(empty)** | user can specify his/her own function that is understood by Tcl environment.<br>e.g. -custom {working directory: [exec pwd]} will print out the output to stdout or stderr or file as working directory: /Users/Documents/ 
-custom1 | any custom data or function **(empty)** | e.g -custom1 {[exec date "+%a %b %D %T %Z"]}
-custom2 | any custom data or function **(empty)** | e.g. -custom1 {user name: [exec whoami] }
-custom3 | any custom data or function **(empty)** | e.g. -custom3 {uname: [uname -v]}
-custom4 | any custom data or function **(empty)** | ...
-custom5 | any custom data or function **(empty)** | ...
-custom6 | any custom data or function **(empty)** | ...
-custom7 | any custom data or function **(empty)** | ...
-custom8 | any custom data or function **(empty)** | ...
-custom9 | any custom data or function **(empty)** | ...
-custom10 | any custom data or function **(empty)** | ...
-custom11 | any custom data or function **(empty)** | ...
-custom12 | any custom data or function **(empty)** | ...
-custom13 | any custom data or function **(empty)** | ...
-custom14 | any custom data or function **(empty)** | ...
-custom15 | any custom data or function **(empty)** | ...

<br>
===
####API: configLogger flags
FLAG | TYPE | DESC 
--- | :---: | ---
%category% | built-in | display log service name
%fullcategory% | built-in | display fully qualified log service name
%priority% | built-in | display log priority of current calling log command
%hostname% | built-in | display hostname
%pid% | built-in | display process id of current executing script
%message% | built-in | message of log
%date% | user-defined | using aside with option -date
%custom% | user-defined | using aside with option -custom
%custom1% | user-defined | using aside with option -custom1
%custom2% | user-defined | using aside with option -custom2
%custom3% | user-defined | using aside with option -custom3
%custom4% | user-defined | using aside with option -custom4
%custom5% | user-defined | using aside with option -custom5
%custom6% | user-defined | using aside with option -custom6
%custom7% | user-defined | using aside with option -custom7
%custom8% | user-defined | using aside with option -custom8
%custom9% | user-defined | using aside with option -custom9
%custom10% | user-defined | using aside with option -custom10
%custom11% | user-defined | using aside with option -custom11
%custom12% | user-defined | using aside with option -custom12
%custom13% | user-defined | using aside with option -custom13
%custom14% | user-defined | using aside with option -custom14
%custom15% | user-defined | using aside with option -custom15

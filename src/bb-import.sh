#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2015,SC2034,SC2155
# ==================================================================
# bb-import
# ==================================================================
# Bash-Bits Importer
#
# File:         bb-import
# Author:       Ragdata
# Date:         15/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# @name BB-Import
# @file bb-import
# @brief Bash-Bits Importer - HEAVILY inspired by Nathan Railich's `import`
# ==================================================================
# ATTRIBUTION:	This script has been HEAVILY influenced & guided by
#               Nathan Rajlich's brilliant `import` script. (see
#               ATTRIBUTION section of README.md for a link.)
# COPYRIGHT:	Copyright © 2018-2020 the Import authors
# ==================================================================
# PREFLIGHT
# ==================================================================
# set debug mode = false
declare -gx IMPORT_TEST=false
# if script is called with 'test' as an argument, then set debug mode
if [[ "${1,,}" == "test" ]]; then shift; IMPORT_TEST=true; set -- "${@}"; fi
# set debug mode = false
declare -gx IMPORT_DEBUG=0
# if script is called with 'debug' as an argument, then set debug mode
if [[ "${1,,}" == "debug" ]]; then shift; IMPORT_DEBUG=1; set -- "${@}"; set -axeET; else set -aeET; fi
# ==================================================================
# VARIABLES
# ==================================================================
#
# DEFAULT PATHS
#
[[ -z "${BB_BASE_DIR}" ]] && declare -gx BB_BASE_DIR="$HOME/.bb"
[[ -z "${BB_CACHE_DIR}" ]] && declare -gx BB_CACHE_DIR="${BB_BASE_DIR}/cache"
[[ -z "${BB_LOG_DIR}" ]] && declare -gx BB_LOG_DIR="${BB_BASE_DIR}/log"
[[ -z "${BB_LOG}" ]] && declare -gx BB_LOG="${BB_LOG_DIR}/import"
#
# DEFAULT VARIABLES
#
[[ -z "${IMPORT_SERVER_DEFAULT}" ]] && declare -gx IMPORT_SERVER_DEFAULT="raw.githubusercontent.com"
[[ -z "${IMPORT_TEMPLATE_IMPLICIT}" ]] && declare -gx IMPORT_TEMPLATE_IMPLICIT="https://${IMPORT_SERVER_DEFAULT}/bash-bits/<%repo%>/<%tag%>/src/<%file%>"
[[ -z "${IMPORT_TEMPLATE_NAMESPACED}" ]] && declare -gx IMPORT_TEMPLATE_NAMESPACED="https://${IMPORT_SERVER_DEFAULT}/<%org%>/<%repo%>/<%tag%>/src/<%file%>"
[[ -z "${BB_LOG_SIZE}" ]] && declare -gx BB_LOG_SIZE=1048576
[[ -z "${BB_LOG_BACKUPS}" ]] && declare -gx BB_LOG_BACKUPS=5
[[ -z "${BB_LOG_ARCHIVE}" ]] && declare -gx BB_LOG_ARCHIVE=1
[[ -z "${IMPORT_RELOAD}" ]] && declare -gx IMPORT_RELOAD=0
#
# ANSI VARIABLES
#
[[ -z "$ANSI_ESC" ]] && declare ANSI_ESC=$'\033'
[[ -z "$ANSI_CSI" ]] && declare ANSI_CSI="${ANSI_ESC}["
[[ -z "$ANSI_OSC" ]] && declare ANSI_OSC="${ANSI_ESC}]"
[[ -z "$ANSI_ST" ]] && declare ANSI_ST="${ANSI_ESC}\\"
#
# SYMBOLS
#
[[ -z "${SYMBOL_ERROR}" ]] && declare -gx SYMBOL_ERROR="🚫"
[[ -z "${SYMBOL_WARNING}" ]] && declare -gx SYMBOL_WARNING="⚠️"
[[ -z "${SYMBOL_INFO}" ]] && declare -gx SYMBOL_INFO="ℹ️"
[[ -z "${SYMBOL_SUCCESS}" ]] && declare -gx SYMBOL_SUCCESS="✅"
#
# COLOR VARIABLES
#
[[ -z "$RED" ]] && declare RED="$(printf '%s31m' "$ANSI_CSI";)"
[[ -z "$BLUE" ]] && declare BLUE="$(printf '%s94m' "$ANSI_CSI";)"
[[ -z "$GREEN" ]] && declare GREEN="$(printf '%s32m' "$ANSI_CSI";)"
[[ -z "$GOLD" ]] && declare GOLD="$(printf '%s33m' "$ANSI_CSI";)"
[[ -z "$WHITE" ]] && declare WHITE="$(printf '%s37m' "$ANSI_CSI";)"
[[ -z "$RESET" ]] && declare RESET="$(printf '%s0m' "$ANSI_CSI";)"
#
# REGEX VARIABLES
#
[[ -z "$isINT" ]] && declare isINT='^[-+]?\d+$'
[[ -z "$isOPT" ]] && declare isOPT='^(-([A-Za-z]+)[\s]?([A-Za-z0-9_\.]*))$|^(--(([A-Za-z0-9_\.]+)=?([A-Za-z0-9_\.]*)))$'
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# bb::scriptPath
# ------------------------------------------------------------------
# @description Determine the calling script's current path
#
# @noargs
#
# @stdout The calling script's current path
# ------------------------------------------------------------------
bb::scriptPath() { printf '%s' "$(realpath "${BASH_SOURCE[0]}")"; }
# ------------------------------------------------------------------
# bb::errorHandler
# ------------------------------------------------------------------
# @description Generic Error Handler for use by all elements of BB
#
# @arg		$1		[integer]		LineNo
# @arg		$2		[integer]		BashLineNo
# @arg		$3		[string]		Last Command
# @arg		$4		[integer]		Error Code
#
# @stderr Error Information
#
# @exitcode (as per $4)
# ------------------------------------------------------------------
bb::errorHandler()
{
	local -n lineNo="${1:-LINENO}"
	local -n bashLineNo="${2:-BASH_LINENO}"
	local lastCommand="${3:-BASH_COMMAND}"
	local code="${4:-0}"

	local lastCommandHeight

	[[ "$code" -eq 0 ]] && return 0

	# workaround for EOF combo tripping traps
	((code)) || return "${code}"

	lastCommandHeight="$(wc -l <<<"${lastCommand}")"

	local -a outputArray=()

	outputArray+=(
		'---'
		"Line History: [${lineNo} ${bashLineNo[*]}]"
		"Function Trace: [${FUNCNAME[*]}}]"
		"Exit Code: ${code}"
	)

	[[ "${#BASH_SOURCE[@]}" -gt 1 ]] && {
		outputArray+=('source_trace:')
		for item in "${BASH_SOURCE[@]}"
		do
			outputArray+=(" - ${item}")
		done
	} || outputArray+=("source_trace: [${BASH_SOURCE[*]}]")

	[[ "${lastCommandHeight}" -gt 1 ]] && {
		outputArray+=('last_command: ->' "${lastCommand}")
	} || outputArray+=("last_command: ${lastCommand}")

	outputArray+=('---')
	printf '%s\n' "${outputArray[@]}" >&2
	exit "${code}"
}
# ------------------------------------------------------------------
# bb::package
# ------------------------------------------------------------------
# ------------------------------------------------------------------
bb::package()
{
	local module="${1:-}"
}
# ------------------------------------------------------------------
#
# DISPLAY FUNCTIONS
#
# ------------------------------------------------------------------
# import::echoAlias
# ------------------------------------------------------------------
# @description Master alias function for `echo` command
#
# @arg  $1			[string]        String to be rendered
# @arg  -c="$VAR"   [option]        Color alias as defined above 				(required)
# @arg  -p='string' [option]        String to prefix to $1 						(optional)
# @arg  -s='string' [option]        String to suffix to $1 						(optional)
# @arg  -e          [option]        Enable escape codes 						(optional)
# @arg  -n          [option]        Disable newline at end of rendered string 	(optional)
#
# @exitcode     0   Success
# @exitcode     1   Failure
# ------------------------------------------------------------------
import::echoAlias()
{
    local msg="${1:-}"
    local COLOR OUTPUT PREFIX SUFFIX _0 options
    local STREAM=1
    local -a OUTARGS

    shift

    [[ -z "$msg" ]] && { echo "${RED}${SYMBOL_ERROR} ERROR :: install::echoAlias :: Requires Argument!${RESET}"; return 2; }

    options=$(getopt -l "color:,prefix:,suffix:,escape,noline" -o "c:p:s:en" -a -- "$@")

    eval set --"$options"

    while true
    do
        case "$1" in
            -c|--color)
                COLOR="$2"
                shift 2
                ;;
            -p|--prefix)
                PREFIX="$2"
                shift 2
                ;;
            -s|--suffix)
                SUFFIX="$2"
                shift 2
                ;;
            -e|--escape)
                OUTARGS+=("-e")
                shift
                ;;
            -n|--noline)
                OUTARGS+=("-n")
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "${RED}ERROR :: echoAlias ::Invalid Argument '$1'!${RESET}"
                return 1
                ;;
        esac
    done

    [[ -n "$COLOR" ]] && _0="${RESET}" || _0=""

    OUTPUT="${COLOR}${PREFIX}${msg}${SUFFIX}${_0}"

    [[ "$STREAM" -eq 2 ]] && echo "${OUTARGS[@]}" "${OUTPUT}" >&2 || echo "${OUTARGS[@]}" "${OUTPUT}"

    return 0
}
#
# COLOUR ALIASES
#
echoRed() { import::echoAlias "$1" -c "${RED}" "${@:2}"; }
echoBlue() { import::echoAlias "$1" -c "${BLUE}" "${@:2}"; }
echoGreen() { import::echoAlias "$1" -c "${GREEN}" "${@:2}"; }
echoGold() { import::echoAlias "$1" -c "${GOLD}" "${@:2}"; }
echoWhite() { import::echoAlias "$1" -c "${WHITE}" "${@:2}"; }
#
# MESSAGE ALIASES
#
echoError() { import::echoAlias "$SYMBOL_ERROR $1" -e -c "${RED}" "${@:2}"; }
echoWarning() { import::echoAlias "$SYMBOL_WARNING $1" -e -c "${GOLD}" "${@:2}"; }
echoInfo() { import::echoAlias "$SYMBOL_INFO $1" -c "${BLUE}" "${@:2}"; }
echoSuccess() { import::echoAlias "$SYMBOL_SUCCESS $1" -c "${GREEN}" "${@:2}"; }
errorExit() { echoError "$1"; exit "${2:-1}"; }
errorReturn() { echoError "$1"; return "${2:-1}"; }
exitReturn()
{
	local r="${1:-0}"
	[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return "$r" || exit "$r"
}
errorExitReturn() { echoError "$1"; exitReturn "${2:-1}"; }
# ------------------------------------------------------------------
#
# LOGGING FUNCTIONS
#
# ------------------------------------------------------------------
# import::log::checkLog
# ------------------------------------------------------------------
# @description Checks import log file integrity
#
# @noargs
#
# @exitcode 0   Success (log file is OK)
# @exitcode 1   Failure (log file is NOT OK)
# ------------------------------------------------------------------
import::log::checkLog()
{
    local size
    # initialize logfile if it doesn't exist
    [[ ! -f "${BB_LOG}" ]] && { import::log::init import || errorReturn "Import Log Failed Integrity Check ('$?')" 2; }
    # check logfile size
    size=$(wc -c "${BB_LOG}" | awk '{print $1}')
    # rotate logfile if necessary
    [[ $size -ge $BB_LOG_SIZE ]] && { import::log::rotate || errorReturn "Import Log Failed Integrity Check ('$?')" 2; }
    # return success if we got this far
    return 0
}
# ------------------------------------------------------------------
# import::log::init
# ------------------------------------------------------------------
# @description Initializes a logfile for bb-import
#
# @arg  $1  [string]    Log File Name
# ------------------------------------------------------------------
import::log::init()
{
    local fileName="${1:-"debug"}"

    [[ ! -d "$BB_LOG_DIR" ]] && { mkdir -p "$BB_LOG_DIR" || return 1; }
    [[ ! -f "$BB_LOG_DIR/$fileName" ]] && { touch "$BB_LOG_DIR/$fileName" || return 1; }

    return 0
}
# ------------------------------------------------------------------
# import::log::rotate
# ------------------------------------------------------------------
# @description Provides basic logging services to bb-import
#
# @noargs
#
# @exitcode 0   Success
# @exitcode 1   Failure
# ------------------------------------------------------------------
import::log::rotate()
{
    local filePath="${BB_LOG}"
    local fileName="${filePath##*/}"
    local timestamp="$(date +%s)"
    local archive="${BB_LOG_ARCHIVE}"
    local files diff c
    # archive file if configured to do so
    [[ "$archive" ]] && tar -czf "$filePath" "$filePath.tar.gz" && filePath="$filePath.tar.gz"
    # timestamp the current logfile
    mv "$filePath" "$filePath.$timestamp"
    # cull excess backups
    files="$(find "$BB_LOG_DIR" -name "$fileName*"  | wc -l )"
    diff=$(( "$files" - "$BB_LOG_BACKUPS" ))
    diff=$diff++
    if [[ "$diff" -gt 0 ]]; then
        c=1
        for file in "$BB_LOG_DIR"/"$fileName"*
        do
            rm -f "$file"
            [[ $c -eq $diff ]] && break || $c++
        done
    fi
    # open a fresh logfile
    touch "$BB_LOG"
}
# ------------------------------------------------------------------
# import::log
# ------------------------------------------------------------------
# @description Provides basic logging services to bb-import
#
# @arg  $1          [string]    Log Message (optional)
# @arg  -c 'int'    [option]    Error Code
# @arg  -C 'string' [option]    Output Color
# @arg  -I 'string' [option]    Initialize LogFile
# @arg  -M 'string' [option]    Log Message
# @arg  -p 'int'    [option]    Log Priority / Level
# @arg  -1          [option]    No output to stdOut
# @arg  -2          [option]    No output to stdErr
# @arg  -3          [option]    No output to logFile
# @arg  -e          [option]    Error Flag
# @arg  -w          [option]    Warning Flag
# @arg  -i          [option]    Info Flag
# @arg  -s          [option]    Success Flag
#
# @exitcode     2   ERROR       Log File Failed Integrity Check
# @exitcode     3   ERROR       Invalid Argument
# @exitcode     4   ERROR       Missing Argument
# ------------------------------------------------------------------
import::log()
{
    local msg fileName exitCode color user priority timestamp options
    local tag msgLog msgOut msgErr
    local isError=false toStdOut=false toStdErr=false toFile=true

	[[ "$TEST" ]] && return 0

	import::log::checkLog

    if [[ ! "$1" =~ $isOPT ]]; then
        msg="$1"
        shift
    fi

    options="$(getopt -l "code:,Color:,Init:,Msg:,priority:,tag:,error,warn,info,success" -o "c:C:I:M:p:t:123ewis" -a -- "$@")"

    eval set --"$options"

    while true
    do
        case "$1" in
            -c|--code)
                [[ ! "$2" =~ $isINT ]] && errorReturn "Invalid Argument!" 3
                exitCode="$2"
                shift 2
                ;;
            -C|--Color)
                color="$2"
                shift 2
                ;;
            -I|--Init)
                fileName="$2"
                shift 2
                ;;
            -M|--Msg)
                msg="$2"
                shift 2
                ;;
            -p|--priority)
                case "$2" in
                    10)     priority="TRACE";;
                    100)    priority="DEBUG";;
                    200)    priority="INFO";;
                    300)    priority="ROUTINE";;
                    400)    priority="NOTICE";;
                    500)    priority="WARNING";;
                    600)    priority="ERROR"; isError=1;;
                    700)    priority="ALERT";;
                    800)    priority="CRITICAL"; isError=1;;
                    900)    priority="FATAL"; isError=1;;
                    *)
                        echoError "Invalid Argument!"
                        return 3
                        ;;
                esac
                shift 2
                ;;
            -t|--tag)
                tag="$2"
                shift 2
                ;;
            1)
                toStdOut=true
                shift
                ;;
            2)
                toStdErr=true
                shift
                ;;
            3)
                toFile=false
                shift
                ;;
            -e|--error)
                isError=true
                shift
                ;;
            -w|--warn)
                isWarning=true
                shift
                ;;
            -i|--info)
                isInfo=true
                shift
                ;;
            -s|--success)
                isSuccess=true
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                errorReturn "Invalid Argument '$1'!" 3
                ;;
        esac
    done

    #
    # COMPILE LOG MESSAGE
    #

    [[ -n "$exitCode" ]] && [[ ! "$isError" ]] && exitCode=0
    [[ -n "$exitCode" ]] && [[ "$isError" ]] && exitCode=1

    [[ "$SUDO_USER" ]] && user="$SUDO_USER" || user="$(whoami)"

    timestamp="$(date '+%y-%m-%d:%I%M%S.%3N')"

    # shellcheck disable=SC2001
    msg=$(echo "$msg" | sed 's/\\e\[.+m//g')

    [[ "$isError" && -z "$priority" ]] && priority="ERROR"
    [[ -z "$priority" ]] && priority="ROUTINE"

    #[[ "$toFile" ]] && msgLog="$timestamp [$priority] [$exitCode] ($!) ($user) :: ${tag}${msg}"
    [[ "$toFile" ]] && msgLog="$timestamp [$priority] ($user) :: ${tag}${msg}"

    if [[ ! "$isError" ]] && [[ ! "$isWarning" ]] && [[ "$toStdOut" ]]; then
        [[ "$priority" == "ROUTINE" ]] && msgOut="${tag}${msg}" || msgOut="${priority} :: ${tag}${msg}"
    elif [[ "$isError" ]] || [[ "$isWarning" ]] && [[ "$toStdErr" ]]; then
        msgErr="${priority}($!) :: ${tag}${msg}"
    fi

    #
    # WRITE TO LOG FILE
    #
    if [[ "$toFile" ]]; then
        # shellcheck disable=SC2094
        if [[ -w "$BB_LOG" ]]; then
            #echo "$msgLog" | tee -a "$BB_LOG" > /dev/null
            echo "$msgLog" >> "$BB_LOG"
        else
            #echo "$msgLog" | sudo tee -a "$BB_LOG" > /dev/null || { echoError "Log Write Failed!"; return 1; }
            sudo bash -c 'echo "$msgLog" >> "$BB_LOG"'
        fi
    fi

#    #
#    # WRITE TO STDOUT / STDERR
#    #
#    if [[ "$toStdOut" ]]; then
#        if [[ "$isInfo" ]]; then
#            echoInfo "$msgOut"
#        elif [[ "$isSuccess" ]]; then
#            echoSuccess "$msgOut"
#        elif [[ -n "$color" ]]; then
#            echo "${color}${msgOut}${RESET}"
#        else
#            echo "$msgOut"
#        fi
#    elif [[ "$toStdErr" ]]; then
#        if [[ "$isWarning" ]]; then
#            echoWarning "$msgErr"
#        else
#            echoError "$msgErr"
#        fi
#    fi
}
# ------------------------------------------------------------------
# import::debug
# ------------------------------------------------------------------
# @description Alias for import::log
#
# @arg  $1  [string]    Log Message
# ------------------------------------------------------------------
import::debug() { import::log "$1" -p 100; }
# ------------------------------------------------------------------
# import::info
# ------------------------------------------------------------------
# @description Alias for import::log
#
# @arg  $1  [string]    Log Message
# ------------------------------------------------------------------
import::info() { import::log "$1" -p 200; }
# ------------------------------------------------------------------
# import::warning
# ------------------------------------------------------------------
# @description Alias for import::log
#
# @arg  $1  [string]    Log Message
# ------------------------------------------------------------------
import::warning() { import::log "$1" -p 500; }
# ------------------------------------------------------------------
# import::error
# ------------------------------------------------------------------
# @description Alias for import::log
#
# @arg  $1  [string]    Log Message
# @arg  $2  [integer]   Exit Code (optional)
# ------------------------------------------------------------------
import::error() { import::log "$1" -p 600; return "${2:-1}"; }
# ------------------------------------------------------------------
# import::fatal
# ------------------------------------------------------------------
# @description Alias for import::log
#
# @arg  $1  [string]    Log Message
# @arg  $2  [integer]   Exit Code (optional)
# ------------------------------------------------------------------
# shellcheck disable=SC2120
import::fatal() { import::log "$1" -p 900; exit "${2:-1}"; }
#
# LOG ALIASES
#
importLog() { import::log "$@"; }
importDebug() { import::debug "$@"; }
importInfo() { import::info "$@"; }
importWarning() { import::warning "$@"; }
importError() { import::error "$@"; }
importFatal() { import::fatal "$@"; }
# ------------------------------------------------------------------
#
# IMPORT FUNCTIONS
#
# ------------------------------------------------------------------
# import::baseDirs
# ------------------------------------------------------------------
# @description Create critical cache directories
#
# @noargs
#
# @stdout List of directories being created
# ------------------------------------------------------------------
import::baseDirs()
{
	echo "Creating Directories:"
	echo "    ${BB_BASE_DIR}"
	echo "    ${BB_CACHE_DIR}"
	echo "    ${BB_LOG_DIR}"
	echo "    ${BB_CACHE_DIR}/data"
	echo "    ${BB_CACHE_DIR}/links"
	echo "    ${BB_CACHE_DIR}/locations"

	mkdir -p "${BB_CACHE_DIR}" "${BB_CACHE_DIR}/data" "${BB_CACHE_DIR}/links" "${BB_CACHE_DIR}/locations" "${BB_LOG_DIR}"
}
# ------------------------------------------------------------------
# import::cachePath
# ------------------------------------------------------------------
# @description Uses the requested package name / url to create a
# unique path upon which to cache the resource
#
# @arg		$1		[string]		The package name / url
#
# @stdout A unique path upon which the resource will be cached
# ------------------------------------------------------------------
import::cachePath()
{
	urlPath="$(echo "$1" | sed 's/\:\///')"
	printf '%s' "${BB_CACHE_DIR}/links/$urlPath"
}
# ------------------------------------------------------------------
# import::initCache
# ------------------------------------------------------------------
# @description Initializes the cache - creates all required directories
# and if a copy of BB-Import was previously archived, it will be
# reconstituted by this command
#
# @stdout Status Output
# @stderr Error Output (if triggered)
# ------------------------------------------------------------------
import::initCache()
{
	if [[ -f "${BB_BASE_DIR}/archive/bb-import.loc" ]]; then
		importDebug "Reconstituting BB-IMPORT CACHE"
		echo "Reconstituting BB-IMPORT CACHE"
		local hash="$(cat "${BB_BASE_DIR}/archive/bb-import.hash")"
		mv "${BB_BASE_DIR}/archive/bb-import.loc" "${BB_CACHE_DIR}/locations/bb-import"
		mv "${BB_BASE_DIR}/archive/bb-import.dat" "${BB_CACHE_DIR}/data/$hash"
		ln -fs "${BB_CACHE_DIR}/data/$hash" "${BB_CACHE_DIR}/links/bb-import"
		rm -rf "${BB_BASE_DIR}/archive" || errorReturn "FAILED!" 1
		echo "DONE!"
	fi
	importDebug "Initializing Cache"
	echo "Initializing Cache"
	mkdir -p "${BB_CACHE_DIR}" "${BB_CACHE_DIR}/data" "${BB_CACHE_DIR}/links" "${BB_CACHE_DIR}/locations" "${BB_LOG_DIR}" || errorReturn "FAILED!" 1
	echo "DONE!"
}
# ------------------------------------------------------------------
# import::list
# ------------------------------------------------------------------
# @description Output a list of all cached resources to stdout showing
# the name of the resource, its origin URL, sha1sum, and date last
# modified
#
# @noargs
#
# @stdout List of cached resources
# ------------------------------------------------------------------
import::list()
{
	local file="${BB_BASE_DIR}/cache-catalogue.csv"
	local locDir="${BB_CACHE_DIR}/locations/"
	local links="${BB_CACHE_DIR}/links/"
	local c=0

	[[ ! -f "${BB_CACHE_DIR}/locations" ]] && errorReturn "Empty Cache!";

	[[ -f "$file" ]] && rm -f "$file"

	echo "${WHITE}NO${RESET},${WHITE}NAME${RESET},${WHITE}ORIGIN${RESET},${WHITE}SHA1SUM${RESET},${WHITE}LAST MODIFIED${RESET}" >> "$file"

	while IFS= read -r line
	do
		c=$((c+1))
		local datFile="$(readlink "$links/${line:${#locDir}}")"
		local modified="$(stat -c '%y' "$line")"
		echo "$c,${line:${#locDir}},$(cat "$line"),${datFile##*/},${modified:0:${#modified}-16}" >> "$file"
	done <<< "$(find "${BB_CACHE_DIR}/locations" -type f -printf "%p\n" | sort)"

	echo
	echoGold "BB-IMPORT FILE CACHE"
	echo
	column -s, -t -o " | " "$file"
	echo
	echoWhite "$c TOTAL FILES IN CACHE"
	echo
}
# ------------------------------------------------------------------
# import::purgeCache
# ------------------------------------------------------------------
# @description Purge (delete) everything from cache.  BB-Import's
# cache records will be archived so that it can be reconstituted
# without having to go through the entire install process
#
# @noargs
#
# @stdout Status Output
# @stderr Error Output (if triggered)
# ------------------------------------------------------------------
import::purgeCache()
{
	if [[ -f "${BB_CACHE_DIR}/locations/bb-import" ]]; then
		importDebug "Archiving BB-IMPORT CACHE"
		local archiveDir="${BB_BASE_DIR}/archive"
		local importLoc="${BB_CACHE_DIR}/locations/bb-import"
		local importDat="$(readlink "${BB_CACHE_DIR}/links/bb-import")"
		local importHsh="${importDat#*/}"

		mkdir -p "$archiveDir"

		mv "$importLoc" "$archiveDir/bb-import.loc"
		mv "$importDat" "$archiveDir/bb-import.dat"
		echo "$importHsh" > "$archiveDir/bb-import.hash"
	fi

	importDebug "Purging Cache"
	echo "Purging Cache"
	rm -rf "${BB_CACHE_DIR}" || errorReturn "FAILED!" 1
	echo "DONE!"
}
# ------------------------------------------------------------------
# import::retry
# ------------------------------------------------------------------
# @description Retry downloads in case of failure
#
# @arg	$1		[binary]	A curl command to be retried on failure
#
# @exitcode Per command result
# ------------------------------------------------------------------
import::retry()
{
    local exitCode=""
    local retryCount=0
    local numberRetries="${retries:-5}"

    while [ "$retryCount" -lt "$numberRetries" ]
    do
        [[ "$retryCount" -gt 0 ]] && importDebug "Retry #$retryCount"
        exitCode=0
        "$@" || exitCode=$?
        [[ "$exitCode" -eq 0 ]] && break
        # TODO :: add exponential back-off
        sleep 1
        retryCount=$(( "$retryCount" + 1 ))
    done

    return "$exitCode"
}
# ------------------------------------------------------------------
# import::template
# ------------------------------------------------------------------
# @description Replace placeholders in template strings with known
# variables.
#
# @arg	$1		[mixed]		A template string containing placeholders
#
# @exitcode		0		Success
# @exitcode		1		Failure
# @exitcode		2		ERROR - Missing Argument
# ------------------------------------------------------------------
import::template()
{
	local template="${1:-}"
	local file="${2:-}"
	local repo="${3:-}"
	local tag="${4:-}"
	local org="${5:-}"

	[[ -n "$1" ]] && shift

	template="${template/<%org%>/${org}}"
	template="${template/<%repo%>/${repo}}"
	template="${template/<%tag%>/${tag}}"
	template="${template/<%file%>/${file}}"

	printf '%s' "$template"
}
# ------------------------------------------------------------------
# import::usage
# ------------------------------------------------------------------
# @description Show usage information about the module
#
# @noargs
#
# @stdout Usage information about the module
# ------------------------------------------------------------------
import::usage()
{
	echo
	echoGold "===================================================================="
	echoWhite "Usage:  bb-import <resource> ... "
	echoGold "===================================================================="
	echo
	echo "Documentation: https://github.com/bash-bits/bb-import/wiki"
	echo "Bash-Bits Core Modules: https://github.com/bash-bits"
	echo
	echoGold "Example use in Script Headers:"
	echo
	echo "    ${WHITE}#!/usr/bin/env bb-import${RESET} # The 'SHEBANG' method of inclusion"
	echo
	echo "    ${WHITE}source bb-import${RESET}         # The 'Sourced' method of inclusion"
	echo
	echoGold "Example use in Scripts:"
	echo
	echo "    ${WHITE}bb-import bb-ansi${RESET}       # import the latest commit of the bb-ansi module"
	echo "    ${WHITE}bb-import bb-ansi@1.3.1${RESET} # import the tagged version 1.3.1 of the bb-ansi module"
	echo "    ${WHITE}bb-import org-name/repo${RESET} # import the org-name/repo project from GitHub"
	echo "    ${WHITE}bb-import https://example.com/project${RESET}  # Import from ANY server in the world"
	echo
	echo "    ${WHITE}NOTE: You can include as many resource identifiers after a bb-import statement as you like!${RESET}"
	echo
	echoGold "Example use on the Command-Line:"
	echo
	echo "    ${WHITE}bb-import -h${RESET}             # Display (this) usage information"
	echo "    ${WHITE}bb-import -v${RESET}             # Show version information"
	echo
	echoGold "Flags:"
	echo
	echo "    ${WHITE}-f, --force${RESET}              # Force the resource to be downloaded even if cached"
	echo "    ${WHITE}-h, --help${RESET}               # Show usage (this) information"
	echo "    ${WHITE}-i, --init-cache${RESET}         # Initialise Cache (Create Directories)"
	echo "    ${WHITE}-l, --list${RESET}               # List cached resources"
	echo "    ${WHITE}-p, --purge-cache${RESET}        # Purge Cache (Delete All)"
	echo "    ${WHITE}-r, --remove <package>${RESET}   # Delete Package from Cache  "
	echo "    ${WHITE}-v, --version${RESET}            # Show version information"
#	echo "    ${WHITE}${RESET}"
	echo
	echoGold "===================================================================="
	echo
}
# ------------------------------------------------------------------
# import::version
# ------------------------------------------------------------------
# @description Reports the version and build date of this release
#
# @noargs
#
# @stdout Version, Copyright, & Build Information
# ------------------------------------------------------------------
import::version()
{
	local verbosity="${1:-}"

	if [[ -z "$verbosity" ]]; then
		echo "${PKG_VERSION}"
	else
		echo
		echo "Bash-Bits Modular Bash Library"
		echoWhite "BB-Import Module ${PKG_VERSION}"
		echo "Copyright © 2022-2023 Darren (Ragdata) Poulton"
		echo "Build: ${PKG_BUILD}"
		echo "Build Date: ${PKG_BUILD_DATE}"
		echo
	fi
}
# ------------------------------------------------------------------
# bb-importFile
# ------------------------------------------------------------------
# @description Wrapper to execute the bb::import function, except
# that the file retrieved will be echoed to stdout rather than
# sourced
#
# @arg		$@		[mixed]		Arguments for bb::import
# ------------------------------------------------------------------
bb::importFile()
{
	print=1 && bb::import "$@"
}
# ------------------------------------------------------------------
# bb::remove
# ------------------------------------------------------------------
# @description Remove a resource from the cache.
#
# @arg		$1		[string]		The name of the package to remove
#
# @stdout Status Output
# @stderr Error Output (if triggered)
# ------------------------------------------------------------------
bb::remove()
{
	local url="${1}"
	local urlPath cachePath locFile

	[[ -z "$url" ]] && errorReturn "Missing Argument!" 2

	importDebug "Removing Package '$url' from Cache"

	urlPath="$(echo "$url" | sed 's/\:\///')"
	cachePath="$(import::cachePath "$url")"

	if [[ -e "$cachePath" ]]; then
		importDebug "Package '$url' Found"
		locFile="${BB_CACHE_DIR}/locations/$urlPath"
		rm -f "$locFile" || return 1
		rm -f "$(readlink "$cachePath")" || return 1
		rm -f "$cachePath" || return 1
		importDebug "Package '$url' Removed from Cache!"
	else
		importDebug "Package '$url' Not Found in Cache!"
	fi
}
# ------------------------------------------------------------------
# bb::import
# ------------------------------------------------------------------
# @description Perhaps the most important part of Bash-Bits.
# BB-Import allows you to include ANY Bash-Bits compatible package
# in your own scripts with a simple `import` command
#
# @arg  $1          [string]    File / Package to Import (required)
# ------------------------------------------------------------------
bb::import()
{
	local url cache
	local -a args

	trap 'bb::errorHandler "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR

	[[ "$#" -eq 0 ]] && errorReturn "Missing Argument!" 2

	[[ ! -d "${BB_BASE_DIR}" ]] && { import::baseDirs || errorReturn "Failed to Create Base Directories!" 3; }

	args=("$@")

	for url in "${args[@]}"
	do
		if [[ "$url" =~ $isOPT ]]; then
			case "$url" in
				-f|--force)
					IMPORT_RELOAD=1
					;;
				*)
					errorReturn "Invalid Argument!" 4
					;;
			esac
			continue
		fi

		if [[ "$url" =~ ^[a-zA-Z\-]*$ ]]; then
			# IMPLICIT IMPORT
			importDebug "Processing IMPLICIT IMPORT"
			repo="${url%@*}"
			file="${repo}.sh"
			# check for version tag
			[[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && tag="${url#*@}" || tag="master"
			# RESOLVE LOCATION
			location="$(import::template "${IMPORT_TEMPLATE_IMPLICIT}" "$file" "$repo" "$tag")"
		elif [[ "$url" =~ ^bb-functions\/[a-zA-Z\-]*$ ]]; then
			# IMPLICIT BB-FUNCTIONS
			importDebug "Processing IMPLICIT BB-FUNCTIONS IMPORT"
			repo="${url%@*}"
			file="${repo/bb-functions/bb-functions.d}.sh"
			repo="bb-functions"
			# check for version tag
			[[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && tag="${url#*@}" || tag="master"
			# RESOLVE LOCATION
			location="$(import::template "${IMPORT_TEMPLATE_IMPLICIT}" "$file" "$repo" "$tag")"
		elif [[ "$url" =~ ^bb-regex\/[a-zA-Z\-]*$ ]]; then
			# IMPLICIT BB-REGEX
			importDebug "Processing IMPLICIT BB-REGEX IMPORT"
			repo="${url%@*}"
			file="${repo/bb-regex/bb-regex.d}.sh"
			repo="bb-regex"
			# check for version tag
			[[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && tag="${url#*@}" || tag="master"
			# RESOLVE LOCATION
			location="$(import::template "${IMPORT_TEMPLATE_IMPLICIT}" "$file" "$repo" "$tag")"
		elif [[ "$url" =~ ^[a-zA-Z\-]*\/[a-zA-Z\-]*$ ]]; then
			# NAMESPACED IMPORT
			importDebug "Processing NAMESPACED IMPORT"
			org="${url%/*}"
			repo="${url#*/}"
			file="${repo}.sh"
			# check for version tag
			[[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && { tag="${repo#*@}"; repo="${repo%@*}"; } || tag="master"
			# RESOLVE LOCATION
			location="$(import::template "${IMPORT_TEMPLATE_NAMESPACED}" "$file" "$repo" "$tag" "$org")"
		elif [[ "$url" =~ ^.*\:\/\/.*$ ]]; then
			# EXPLICIT IMPORT
			importDebug "Processing EXPLICIT IMPORT"
			location="$url"
		elif echo "$url" | grep -q "./"; then
			# LOCAL IMPORT
			importDebug "Processing LOCAL IMPORT"
            case "$url" in
                ./*) location="$(dirname "bb::scriptPath")/$url";;
                ../*) location="$(dirname "bb::scriptPath")/$url";;
            esac
		else
			# ERROR
			errorReturn "Unsupported Import Target!" 5
		fi

		importDebug "URL: '$url'"

		urlPath="$(echo "$url" | sed 's/\:\///')"
		cachePath="$(import::cachePath "$url")"

		if [[ ! -e "$cachePath" ]] || [[ "${IMPORT_RELOAD}" -eq 1 ]]; then

			# download the requested file to a temp directory so that the sha1sum
			# can be computed and the final filename determined
			local tmpFile="$cachePath.tmp"
			local tmpDir="${tmpFile%/*}"
			local locFile="${BB_CACHE_DIR}/locations/$urlPath"
			local locDir="${locFile%/*}"

			[[ ! -d "$tmpDir" ]] && mkdir -p "$tmpDir"
			[[ ! -d "$locDir" ]] && mkdir -p "$locDir"

			# ==========================================================
			# DOWNLOAD THE FILE
			# ==========================================================
			importLog "Downloading '$location'"
			# download location
			import::retry curl -sfLS --netrc-optional --connect-timeout 5 --output "$tmpFile" "$location" > /dev/null 2>&1 || { local r=$?; importWarning "Failed to download '$location'" >&2; return "$r"; }
			# log location resolution
			importDebug "Resolved Location: '$url' -> '$location'"
			# record location in locFile
			echo "$location" > "$locFile"
			# ==========================================================

			# ==========================================================
			# CALCULATE FILE HASH
			# ==========================================================
			local hash
			# calculate hash of downloaded file
			hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return 1
			# log hash
			importDebug "Calculated Hash for '$url' -> '$hash'"
			# if the hashFile doesn't exist, move it into place,
			# otherwise delete the tmpFile
			local hashFile="${BB_CACHE_DIR}/data/$hash"
			# ==========================================================
			[[ -f "$hashFile" ]] && { rm -f "$tmpFile"; return 0; } || mv "$tmpFile" "$hashFile"
			# ==========================================================

			# ==========================================================
			# CREATE SYMLINK
			# ==========================================================
			importDebug "Symlink for '$cachePath' -> '$hashFile'"
			ln -fs "$hashFile" "$cachePath" || return 1
			# ==========================================================
		else
			# ======================================================
			importDebug "File Already Cached '$url'"
			# ======================================================
		fi

		set --

		if [[ -z "${print-}" ]]; then
			# at this point, the file has been saved to cache, so source it
			importDebug "Sourcing: '$cachePath'"
			source "$cachePath" || errorReturn "File '$cachePath' Not Found!" 6
		else
			importDebug "Printing: '$cachePath'"
			printf '%s' "$(cat "$cachePath")"
		fi
	done

	trap - 0 ERR
}
# ==================================================================
# MAIN
# ==================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	trap 'bb::errorHandler "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR

	options=$(getopt -l "force,help,init-cache,list,purge-cache,remove:,version::" -o "fhilpr:v::" -a -- "$@")

	eval set --"$options"

	while true
	do
		case "$1" in
			-f|--force)
				IMPORT_RELOAD=1
				shift
				;;
			-h|--help)
				import::usage
				shift
				exitReturn 0
				;;
			-i|--init-cache)
				import::initCache
				shift
				exitReturn 0
				;;
			-l|--list)
				import::list
				shift
				exitReturn 0
				;;
			-p|--purge-cache)
				import::purgeCache
				shift
				exitReturn 0
				;;
			-r|--remove)
				package="${2}"
				bb::remove "$package"
				shift 2
				exitReturn 0
				;;
			-v|--version)
				if [[ -n "${2}" ]]; then
					import::version "${2}"
					shift 2
				else
					import::version
					shift
				fi
				exitReturn 0
				;;
			--)
				shift
				break
				;;
			*)
				echoError "Invalid Argument!"
				exitReturn 2
				;;
		esac
	done

	trap - 0 ERR

	bb::import "$@"

fi

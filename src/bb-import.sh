#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2015,SC2034,SC2155
# ==================================================================
# bb-import
# ==================================================================
# Bash Bits Importer
#
# File:         bb-import
# Author:       Ragdata
# Date:         15/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# @name BB-Import
# @file bb-import
# @brief Bash Bits Importer - HEAVILY inspired by Nathan Railich's `import`
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
# BUILD VARIABLES
#
declare -gx IMPORT_VERSION="v-1.0.0"
declare -gx IMPORT_BUILD="x"
declare -gx IMPORT_BUILD_DATE="2023-04-15T16:00:00+10:00"
#
# DEFAULT PATHS
#
[[ -z "${IMPORT_BASE_DIR}" ]] && declare -gx IMPORT_BASE_DIR="$HOME/.bb"
[[ -z "${IMPORT_CACHE_DIR}" ]] && declare -gx IMPORT_CACHE_DIR="${IMPORT_BASE_DIR}/cache"
[[ -z "${IMPORT_LOG_DIR}" ]] && declare -gx IMPORT_LOG_DIR="${IMPORT_BASE_DIR}/log"
[[ -z "${IMPORT_LOG}" ]] && declare -gx IMPORT_LOG="${IMPORT_LOG_DIR}/import"
#
# DEFAULT VARIABLES
#
[[ -z "${IMPORT_SERVER_DEFAULT}" ]] && declare -gx IMPORT_SERVER_DEFAULT="raw.githubusercontent.com"
[[ -z "${IMPORT_TEMPLATE_IMPLICIT}" ]] && declare -gx IMPORT_TEMPLATE_IMPLICIT="https://${IMPORT_SERVER_DEFAULT}/bash-bits/<%repo%>/<%tag%>/src/<%file%>"
[[ -z "${IMPORT_TEMPLATE_NAMESPACED}" ]] && declare -gx IMPORT_TEMPLATE_NAMESPACED="https://${IMPORT_SERVER_DEFAULT}/<%org%>/<%repo%>/<%tag%>/src/<%file%>"
[[ -z "${IMPORT_LOG_SIZE}" ]] && declare -gx IMPORT_LOG_SIZE=1048576
[[ -z "${IMPORT_LOG_BACKUPS}" ]] && declare -gx IMPORT_LOG_BACKUPS=5
[[ -z "${IMPORT_LOG_ARCHIVE}" ]] && declare -gx IMPORT_LOG_ARCHIVE=1
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
errorReturn() { echoError "$1"; return "${2:-1}"; }
# ------------------------------------------------------------------
#
# CONFIGURATION FUNCTIONS
#
# ------------------------------------------------------------------
# import::parseConfig
# ------------------------------------------------------------------
# @description Parse the specified config file to make them available
# in the environment and to Bash-Bits as a whole.
#
# @arg $1	[string]	Name of the configuration file
#
# @exitcode		0		Success
# @exitcode		1		Failure
# @exitcode		2		ERROR - Config File Not Found
# ------------------------------------------------------------------
import::parseConfig()
{
	local cfgFile="${1:-}"
	local myName prefix module section key val line cache
	local writeEnv=0

	[[ "$TEST" ]] && return 0

	if [[ -z "$cfgFile" ]]; then
		myName="${BASH_SOURCE[0]}"
		myExt="${myName#*.}"
		myName="${myName%.*}"
		cfgFile="$myName.ini"
		envFile="$myName.env"
	fi

	cachePath="$(import::cacheDir::import)"
	cfgDir="$cachePath/cfg"
	cfgPath="$cfgDir/$cfgFile"
	envPath="$cfgDir/$envFile"

	[[ ! -f "$cfgPath" ]] && errorReturn "Config File Not Found!" 2

	[[ ! -f "$envPath" ]] && writeEnv=1 && touch "$envPath"

	while IFS= read -r line
	do

		if [[ "${line:0:1}" == "[" && "${line:0-1}" == "]" ]]; then
			section="${line:1:${#line}-2}"
			[[ "${section^^}" == "MODULE" ]] && section="${myName:3}" && section="${section^^}" && module="$section"
		else
			key="${line%=*}"
			key="${key^^}"
			val="${line#*=}"
			key="${section}_${key}"
			[[ "${val}" == *"$"* ]] && eval "val=\$$val"
			[[ "${val}" == *"{"*"}"* ]] && val="$(import::template "${val}")"
			declare -gx "${key}"="${val}"
#			echo "${key}=${!key}"
			[[ "$writeEnv" -eq 1 ]] && echo "${key}=${!key}" >> "$envPath"
		fi
	done < "$cfgPath"
}
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
    [[ ! -f "${IMPORT_LOG}" ]] && { import::log::init import || errorReturn "Import Log Failed Integrity Check ('$?')" 2; }
    # check logfile size
    size=$(wc -c "${IMPORT_LOG}" | awk '{print $1}')
    # rotate logfile if necessary
    [[ $size -ge $IMPORT_LOG_SIZE ]] && { import::log::rotate || errorReturn "Import Log Failed Integrity Check ('$?')" 2; }
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

    [[ ! -d "$IMPORT_LOG_DIR" ]] && { mkdir -p "$IMPORT_LOG_DIR" || return 1; }
    [[ ! -f "$IMPORT_LOG_DIR/$fileName" ]] && { touch "$IMPORT_LOG_DIR/$fileName" || return 1; }

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
    local filePath="${IMPORT_LOG}"
    local fileName="${filePath##*/}"
    local timestamp="$(date +%s)"
    local archive="${IMPORT_LOG_ARCHIVE}"
    local files diff c
    # archive file if configured to do so
    [[ "$archive" ]] && tar -czf "$filePath" "$filePath.tar.gz" && filePath="$filePath.tar.gz"
    # timestamp the current logfile
    mv "$filePath" "$filePath.$timestamp"
    # cull excess backups
    files="$(find "$IMPORT_LOG_DIR" -name "$fileName*"  | wc -l )"
    diff=$(( "$files" - "$IMPORT_LOG_BACKUPS" ))
    diff=$diff++
    if [[ "$diff" -gt 0 ]]; then
        c=1
        for file in "$IMPORT_LOG_DIR"/"$fileName"*
        do
            rm -f "$file"
            [[ $c -eq $diff ]] && break || $c++
        done
    fi
    # open a fresh logfile
    touch "$IMPORT_LOG"
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
    local tag="" msgLog="" msgOut="" msgErr=""
    local isError=false toStdOut=true toStdErr=true toFile=true

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
                toStdOut=false
                shift
                ;;
            2)
                toStdErr=false
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
    else
        msgErr="${priority}($!) :: ${tag}${msg}"
    fi

    #
    # WRITE TO LOG FILE
    #
    if [[ "$toFile" ]]; then
        # shellcheck disable=SC2094
        if [[ -w "$IMPORT_LOG" ]]; then
            echo "$msgLog" | tee -a "$IMPORT_LOG" 1> /dev/null
        else
            echo "$msgLog" | sudo tee -a "$IMPORT_LOG" 1> /dev/null || { echoError "Log Write Failed!"; return 1; }
        fi
    fi

    #
    # WRITE TO STDOUT / STDERR
    #
    if [[ "$toStdOut" ]]; then
        if [[ "$isInfo" ]]; then
            echoInfo "$msgOut"
        elif [[ "$isSuccess" ]]; then
            echoSuccess "$msgOut"
        elif [[ -n "$color" ]]; then
            echo "${color}${msgOut}${RESET}"
        else
            echo "$msgOut"
        fi
    elif [[ "$toStdErr" ]]; then
        if [[ "$isWarning" ]]; then
            echoWarning "$msgErr"
        else
            echoError "$msgErr"
        fi
    fi
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
# ------------------------------------------------------------------
import::baseDirs()
{
	echo "Creating Directories:"
	echo "    ${IMPORT_BASE_DIR}"
	echo "    ${IMPORT_CACHE_DIR}"
	echo "    ${IMPORT_LOG_DIR}"
	echo "    ${IMPORT_CACHE_DIR}/data"
	echo "    ${IMPORT_CACHE_DIR}/links"
	echo "    ${IMPORT_CACHE_DIR}/locations"

	mkdir -p "${IMPORT_CACHE_DIR}" "${IMPORT_CACHE_DIR}/data" "${IMPORT_CACHE_DIR}/links" "${IMPORT_CACHE_DIR}/locations" "${IMPORT_LOG_DIR}"
}
# ------------------------------------------------------------------
# import::cachePath
# ------------------------------------------------------------------
# ------------------------------------------------------------------
import::cachePath()
{
	urlPath="$(echo "$1" | sed 's/\:\///')"
	printf '%s' "${IMPORT_CACHE_DIR}/links/$urlPath"
}
# ------------------------------------------------------------------
# import::retry
# ------------------------------------------------------------------
# @description Retry downloads in case of failure
# ------------------------------------------------------------------
import::retry()
{
    local exitCode=""
    local retryCount=0
    local numberRetries="${retries:-5}"

    while [ "$retryCount" -lt "$numberRetries" ]
    do
        [[ "$retryCount" -gt 0 ]] && echo "Retry #$retryCount"
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
	echoWhite "Usage:  bb::import <resource> ... "
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
	echo "    ${WHITE}bb::import bb-ansi${RESET}       # import the latest commit of the bb-ansi module"
	echo "    ${WHITE}bb::import bb-ansi@1.3.1${RESET} # import the tagged version 1.3.1 of the bb-ansi module"
	echo "    ${WHITE}bb::import org-name/repo${RESET} # import the org-name/repo project from GitHub"
	echo "    ${WHITE}bb::import https://example.com/project${RESET}  # Import from ANY server in the world"
	echo
	echo "    ${WHITE}NOTE: You can include as many resource identifiers after a bb::import statement as you like!${RESET}"
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
	echo "    ${WHITE}-l, --list${RESET}               # List cached resources"
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
	local ver buildDate

	echo
	echo "Bash-Bits Modular Bash Library"
	echoWhite "BB-Import Module v-${IMPORT_VERSION}"
	echo "Copyright © 2022-2023 Darren (Ragdata) Poulton"
	echo "Build Date: ${IMPORT_BUILD_DATE}"
	echo
}
# ------------------------------------------------------------------
# bb::importFile
# ------------------------------------------------------------------
# ------------------------------------------------------------------
bb::importFile()
{
	print=1 && bb::import "$@"
}
# ------------------------------------------------------------------
# bb::import
# ------------------------------------------------------------------
# @description Perhaps the most important part of Bash Bits.
# BB-Import allows you to include ANY Bash Bits compatible package
# in your own scripts with a simple `import` command
#
# @arg  $1          [string]    File / Package to Import (required)
# ------------------------------------------------------------------
bb::import()
{
	local url cache
	local -a args

	[[ "$#" -eq 0 ]] && errorReturn "Missing Argument!" 2

	[[ ! -d "${IMPORT_BASE_DIR}" ]] && { import::baseDirs || errorReturn "Failed to Create Base Directories!" 3; }

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
		elif [[ "$url" =~ ^bb-functions\/[a-zA-Z\-]*$ ]]; then
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
		elif [[ "$url" =~ ^[\./.*|\.\./.*|\/.*]$ ]]; then
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

		urlPath="$(echo "$1" | sed 's/\:\///')"
		cachePath="$(import::cachePath "$url")"

		if [[ ! -e "$cachePath" ]] || [[ "${IMPORT_RELOAD}" -eq 1 ]]; then

			# download the requested file to a temp directory so that the sha1sum
			# can be computed and the final filename determined
			local tmpFile="$cachePath.tmp"
			local locFile="${IMPORT_CACHE_DIR}/locations/$urlPath"

			# ==========================================================
			# DOWNLOAD THE FILE
			# ==========================================================
			importLog "Downloading '$location'"
			# download location
			import::retry curl -sfLS --netrc-optional --connect-timeout 5 --output "$tmpFile" "$location" || { local r=$?; importWarning "Failed to download '$location'" >&2; return "$r"; }
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
			local hashFile="${IMPORT_CACHE_DIR}/data/$hash"
			# ==========================================================
			[[ -f "$hashFile" ]] && { rm -f "$tmpFile"; return 0; } || { mv "$tmpFile" "$hashFile"; return 0; }
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
			printf '%s' "$(cat "$cachePath")"
		fi
	done
}
# ==================================================================
# MAIN
# ==================================================================

options=$(getopt -l "force,help,list,version" -o "fhlv" -a -- "$@")

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
			return 0
			;;
		-l|--list)
			import::list
			shift
			return 0
			;;
		-v|--version)
			import::version
			shift
			return 0
			;;
		--)
			shift
			break
			;;
		*)
			errorReturn "Invalid Argument!" 2
			;;
	esac
done

bb::import "$@"

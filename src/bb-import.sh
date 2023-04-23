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
# ==================================================================
# VARIABLES
# ==================================================================
#
# CONFIG VARIABLES
#
# SYMBOL SECTION
[[ -z "$BB_IMPORT_SYMBOL_ERROR" ]] && BB_IMPORT_SYMBOL_ERROR="🚫"
[[ -z "$BB_IMPORT_SYMBOL_WARNING" ]] && declare BB_IMPORT_SYMBOL_WARNING="⚠️"
[[ -z "$BB_IMPORT_SYMBOL_INFO" ]] && declare BB_IMPORT_SYMBOL_INFO="ℹ️"
[[ -z "$BB_IMPORT_SYMBOL_SUCCESS" ]] && declare BB_IMPORT_SYMBOL_SUCCESS="✅"
# IMPORT SECTION
[[ -z "$BB_IMPORT_OPTIONS_CACHE" ]] && declare BB_IMPORT_OPTIONS_CACHE="$HOME/.bb"
[[ -z "$BB_IMPORT_OPTIONS_SERVER" ]] && declare BB_IMPORT_OPTIONS_SERVER="https://github.com/bash-bits"
[[ -z "$BB_IMPORT_OPTIONS_LOG_DIR" ]] && declare BB_IMPORT_OPTIONS_LOG_DIR="$BB_IMPORT_OPTIONS_CACHE/log"
[[ -z "$BB_IMPORT_OPTIONS_LOG" ]] && declare BB_IMPORT_OPTIONS_LOG="$BB_IMPORT_OPTIONS_LOG_DIR/debug"
[[ -z "$BB_IMPORT_OPTIONS_TRACE" ]] && declare BB_IMPORT_OPTIONS_TRACE_DIR="$BB_IMPORT_OPTIONS_CACHE/trace"
[[ -z "$BB_IMPORT_OPTIONS_LOG_SIZE" ]] && declare BB_IMPORT_OPTIONS_LOG_SIZE=1048576
[[ -z "$BB_IMPORT_OPTIONS_LOG_BACKUPS" ]] && declare BB_IMPORT_OPTIONS_LOG_BACKUPS=5
[[ -z "$BB_IMPORT_OPTIONS_LOG_ARCHIVE" ]] && declare BB_IMPORT_OPTIONS_LOG_ARCHIVE=1
[[ -z "$BB_IMPORT_OPTIONS_CURL_OPTS" ]] && declare BB_IMPORT_OPTIONS_CURL_OPTS
[[ -z "$BB_IMPORT_OPTIONS_RELOAD" ]] && declare BB_IMPORT_OPTIONS_RELOAD=0
[[ -z "$BB_IMPORT_OPTIONS_DEBUG" ]] && declare BB_IMPORT_OPTIONS_DEBUG=0
#
# LOCAL CONFIG VARIABLES
#
SYMBOL_ERROR="$BB_IMPORT_SYMBOL_ERROR"
SYMBOL_WARNING="$BB_IMPORT_SYMBOL_WARNING"
SYMBOL_INFO="$BB_IMPORT_SYMBOL_INFO"
SYMBOL_SUCCESS="$BB_IMPORT_SYMBOL_SUCCESS"
# IMPORT SECTION
IMPORT_CACHE="$BB_IMPORT_OPTIONS_CACHE"
IMPORT_SERVER="$BB_IMPORT_OPTIONS_SERVER"
IMPORT_LOG_DIR="$BB_IMPORT_OPTIONS_LOG_DIR"
IMPORT_LOG="$BB_IMPORT_OPTIONS_LOG"
IMPORT_TRACE="$BB_IMPORT_OPTIONS_TRACE"
IMPORT_LOG_SIZE="$BB_IMPORT_OPTIONS_LOG_SIZE"
IMPORT_LOG_BACKUPS="$BB_IMPORT_OPTIONS_LOG_BACKUPS"
IMPORT_LOG_ARCHIVE="$BB_IMPORT_OPTIONS_LOG_ARCHIVE"
IMPORT_CURL_OPTS="$BB_IMPORT_OPTIONS_CURL_OPTS"
IMPORT_RELOAD="$BB_IMPORT_OPTIONS_RELOAD"
IMPORT_DEBUG="$BB_IMPORT_OPTIONS_DEBUG"
#
# ANSI VARIABLES
#
[[ -z "$ANSI_ESC" ]] && declare ANSI_ESC=$'\033'
[[ -z "$ANSI_CSI" ]] && declare ANSI_CSI="${ANSI_ESC}["
[[ -z "$ANSI_OSC" ]] && declare ANSI_OSC="${ANSI_ESC}]"
[[ -z "$ANSI_ST" ]] && declare ANSI_ST="${ANSI_ESC}\\"
#
# COLOR VARIABLES
#
[[ -z "$RED" ]] && declare RED="$(printf '%s31m' "$ANSI_CSI";)"
[[ -z "$BLUE" ]] && declare BLUE="$(printf '%s94m' "$ANSI_CSI";)"
[[ -z "$GREEN" ]] && declare GREEN="$(printf '%s32m' "$ANSI_CSI";)"
[[ -z "$GOLD" ]] && declare GOLD="$(printf '%s33m' "$ANSI_CSI";)"
[[ -z "$RESET" ]] && declare RESET="$(printf '%s0m' "$ANSI_CSI";)"
#
# REGEX VARIABLES
#
[[ -z "$isINT" ]] && declare isINT='^[-+]?\d+$'
[[ -z "$isOPT" ]] && declare isOPT='^(-([A-Za-z]+)[\s]?([A-Za-z0-9_\.]*))$|^(--(([A-Za-z0-9_\.]+)=?([A-Za-z0-9_\.]*)))$'
#
# SCRIPT VARIABLES
#
declare importEntryPoint=0
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
# echoAlias
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
install::echoAlias()
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
echoRed() { install::echoAlias "$1" -c "${RED}" "${@:2}"; }
echoBlue() { install::echoAlias "$1" -c "${BLUE}" "${@:2}"; }
echoGreen() { install::echoAlias "$1" -c "${GREEN}" "${@:2}"; }
echoGold() { install::echoAlias "$1" -c "${GOLD}" "${@:2}"; }
#
# MESSAGE ALIASES
#
echoError() { install::echoAlias "$SYMBOL_ERROR $1" -e -c "${RED}" "${@:2}"; }
echoWarning() { install::echoAlias "$SYMBOL_WARNING $1" -e -c "${GOLD}" "${@:2}"; }
echoInfo() { install::echoAlias "$SYMBOL_INFO $1" -c "${BLUE}" "${@:2}"; }
echoSuccess() { install::echoAlias "$SYMBOL_SUCCESS $1" -c "${GREEN}" "${@:2}"; }
errorReturn() { echoError "$1"; return "${2:-1}"; }
# ------------------------------------------------------------------
# import::cacheDir
# ------------------------------------------------------------------
# @description Determine the path to bb-import
#
# @noargs
#
# @stdout The path to bb-import
# ------------------------------------------------------------------
import::cacheDir()
{
    local home="${HOME:-"$(printf '%s' ~)"}"
    local default="$home/.bb"
    [ "$(uname -s)" = "Darwin" ] && default="$home/Library/Caches"
    printf '%s' "${XDG_CACHE_HOME:-${LOCALAPPDATA:-$default}}/$1"
}
# ------------------------------------------------------------------
# import::cacheDir::import
# ------------------------------------------------------------------
# @description Determine the path to bb-import
#
# @noargs
#
# @stdout The path to bb-import
# ------------------------------------------------------------------
import::cacheDir::import() { printf '%s' "${IMPORT_CACHE:-$(import::cacheDir bb-import.sh)}"; }
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
    [[ ! -f "${IMPORT_LOG}" ]] && { import::log::init debug || return 1; }
    # check logfile size
    size=$(wc -c "${IMPORT_LOG}" | awk '{print $1}')
    # rotate logfile if necessary
    [[ $size -ge $IMPORT_LOG_SIZE ]] && { import::log::rotate || return 1; }
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
    local isError=0 toStdOut=1 toStdErr=1 toFile=1

    [[ ! "$(import::log::checkLog)" ]] && { echoError "Import Log Failed Integrity Check"; return 2; }

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
                toStdOut=0
                shift
                ;;
            2)
                toStdErr=0
                shift
                ;;
            3)
                toFile=0
                shift
                ;;
            -e|--error)
                isError=1
                shift
                ;;
            -w|--warn)
                isWarning=1
                shift
                ;;
            -i|--info)
                isInfo=1
                shift
                ;;
            -s|--success)
                isSuccess=1
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

    [[ "$toFile" ]] && msgLog="$timestamp [$priority] [$exitCode] ($!) ($user) :: ${tag}${msg}"

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
            echo "$msgLog" | tee -a "$IMPORT_LOG"
        else
            echo "$msgLog" | sudo tee -a "$IMPORT_LOG" || { echoError "Log Write Failed!"; return 1; }
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
import::fatal() { import::log "$1" -p 900; exit "${2:-1}"; }
#
# LOG ALIASES
#
alias importLog='import::log'
alias importDebug='import::debug'
alias importInfo='import::info'
alias importWarning='import::warning'
alias importError='import::error'
alias importFatal='import::fatal'
#
# IMPORT HASH UTILITY
#
# Only `shasum` is present on MacOS by default,
# and only `sha1sum` is present on Alpine by default
_importSHASum="$(command -v sha1sum)" || _importSHASum="$(command -v shasum)" || {
    r=$?
    importLog "No \`shasum\` or \`sha1sum\` command present!"
    exit "$r"
}
importDebug "Using '$_importSHASum' for hashing"
# ------------------------------------------------------------------
# import::parseLocation
# ------------------------------------------------------------------
# @description Resolve the location of the imported file
#
# @arg  $1      [string]    URL of imported file
# @arg  $2      [string]    Headers from HTTP session retrieving file
#
# @stdout The resolved location
# ------------------------------------------------------------------
import::parseLocation()
{
    local location="$1"
    local headers="$2"
    local locationHeader=""

    # print `x-import-warning` headers
    grep -i '^x-import-warning:' < "$headers" | while IFS="" read -r line
    do
        importWarning "import: warning - $(echo "$line" | awk -F": " '{print $2}' | tr -d \\r)"
    done

    # find the final `Location` or `Content-Location` header
    locationHeader="$(grep -i '^Location\|^content-location:' < "$headers" | tail -n1)"
    if [ -n "$locationHeader" ]; then
        location="$(echo "$locationHeader" | awk -F": " '{print $2}' | tr -d \\r)"
    fi
    # result to stdOut
    printf '%s' "$location"
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
# import::file
# ------------------------------------------------------------------
# @description
# ------------------------------------------------------------------
import::file() { print=1 bb::import "$@"; }
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
    local url cache urlPath cachePath org repo tag repoLen
    local -a args

    [[ "$#" -lt 1 ]] && { echoError "Missing Argument!"; return 2; }

    args=("$@")

    cache="$(import::cacheDir::import)"

    for i in ${#args[@]}
    do
        url="${args[$i]}"

        if ! echo "$url" | grep "://" > /dev/null && ! echo "$url" | awk -F/ '{print $1}' | grep '\.' > /dev/null; then
            importDebug "Detected Implicit Import"
            # IMPLICIT IMPORT (eg: bb::import bb-ansi)
            repo="${url%@*}"
            # check for version tag
            [[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && tag="${url#*@}" || tag="master"
            # rewrite url
            location="${IMPORT_SERVER_IMPLICIT:-https://raw.githubusercontent.com/bash-bits/${repo}/${tag}/src/${repo}.sh}"
        elif ! echo "$url" | grep "://" > /dev/null && echo "$url" | awk -F/ '{print $1}' | grep '\.' > /dev/null; then
            importDebug "Detected Namespaced Import"
            # NAMESPACED IMPORT (eg: bb::import my-org/my-repo)
            org="${url%/*}"
            repo="${url#*/}"
            # check for version tag
            [[ "$(echo "$url" | awk -F@ '{print $1}' > /dev/null)" ]] && tag="${repo#*@}"; repo="${repo%@*}"; || tag="master"
            # rewrite url
            location="${IMPORT_SERVER_NAMESPACED:-https://raw.githubusercontent.com/${org}/${repo}/${tag}/src/${repo}.sh}"
        elif echo "$url" | grep "://" > /dev/null; then
            importDebug "Detected Explicit Import"
            # EXPLICIT IMPORT (EG: bb::import https://example.com/my-project)
            location="$url"
        elif echo "$url" | grep "./" > /dev/null && ! echo "$url" | awk -F@ '{print $1}' > /dev/null; then
            importDebug "Detected Relative Import"
            # RELATIVE IMPORT (EG: bb::import ../../file.sh)
            case "$url" in
                ./*) location="$(dirname "bb::scriptPath")/$url";;
                ../*) location="$(dirname "bb::scriptPath")/$url";;
            esac
        else
            # ERROR - Unsupported Import Target
            importError "Unsupported Import Target!"
            return 2
        fi

        # record the URL to the trace db if the env var is set
        [[ -n "$IMPORT_TRACE" ]] && echo "$url" >> "$IMPORT_TRACE"

        urlPath="$(echo "$url" | sed 's/\:\///')"
        cachePath="$cache/links/$urlPath"

        if [ ! -e "$cachePath" ] || [ "${IMPORT_RELOAD-}" = "1" ]; then
            # ensure the directory containing the symlink for this import exists
            local dir linkDir

            dir="$(realpath "$urlPath")"
            dir="${dir##*/}"

            linkDir="$cache/links/$dir"

            importDebug "Creating directories:"
            importDebug "$linkDir"
            importDebug "$cache/data"
            importDebug "$cache/locations/$dir"
            echo

            mkdir -p "$linkDir" "$cache/data" "$cache/locations/$dir" >&2 || return

            # resolve the cache and link with `pwd` now that the directories exist
            cache="$( ( cd "$cache" && pwd ) )" || return
            linkDir="$( ( cd "$linkDir" && pwd ) )" || return
            cachePath="$cache/links/$urlPath"

            # download the requested file to a temporary directory so that the shasum
            # can be computed to determine the proper final filename
            local tempFile="$cachePath.tmp"
            local locFile="$cache/locations/$urlPath"

            # ======================================================
            # DOWNLOAD THE FILE
            # ======================================================
            importLog "Downloading '$location'"

            import::retry curl -sfLS --netrc-optional --output "$tempFile" "$location" || {
                local r=$?
                importWarning "Failed to download: $location"
                rm -f "$tempFile" || true
                return "$r"
            }
            # ======================================================

            importDebug "Resolved location '$url' -> '$location'"
            echo "$location" > "$locFile"

            # calculate the sha1 hash of the contents of the downloaded file
            local hash
            hash="$("$_importSHASum" < "$tempFile" | { read -r first rest; echo "$first"; })" || return
            importDebug "Calculated hash for '$url' -> '$hash'"

            local hashFile="$cache/data/$hash"

            # if the hashed file doesn't exist, move it into place,
            # otherwise delete the temp file - it's no longer needed
            if [ -f "$hashFile" ]; then
                rm -f "$tempFile" || return
            else
                mv "$tempFile" "$hashFile" || return
            fi

            # create a relative symlink for this import pointing to the hashed file
            local relative cacheStart

            [[ "${linkDir:0-1}" == "." ]] && linkDir="${linkDir:0:${#linkDir}-2}"

            cacheStart="$(( "${#cache}" + 1 ))" || return
            relative="$(echo "$linkDir" | awk '{print substr($0, '"$cacheStart"')}' | sed 's/\/[^/]*/..\//g')data/$hash" || return
            [ -n "${IMPORT_DEBUG-}" ] && importDebug "import :: Creating symlink"
            ln -fs${IMPORT_DEBUG:+v} "$relative" "$cachePath" >&2 || return

            importDebug "Successfully downloaded '$url' -> '$hashFile'"
        else
            importDebug "File already cached '$url'"
        fi

    done
}
# ==================================================================
# MAIN
# ==================================================================
# for `#1/usr/bin/env bb-import`
if [ -n "${ZSH_EVAL_CONTEXT-}" ]; then
    if [ "${ZSH_EVAL_CONTEXT-}" == "toplevel" ]; then
        importEntryPoint="1"
    fi
elif [ "$(echo "$0" | cut -c1)" != "-" ] && [ "$(basename "$0" .sh)" == "bb-import" ]; then
    importEntryPoint=1
    echo "ENTRYPOINT: $(basename "$0" .sh)"
fi

if [ -n "${importEntryPoint}" ]; then
    # parse argv
    while [ $# -gt 0 ]
    do
        case "$1" in
            -s=*|--shell=*)
                importShell="${1#*=}" && shift
                ;;
            -s|--shell)
                importShell="$2" && shift 2
                ;;
            -c)
                importCommand="$2" && shift 2
                ;;
            -*)
                echoError "bb-import :: Unknown Argument '$1'" >&2 && exit 2
                ;;
            *)
                break
                ;;
        esac
    done

    if [ -n "${importShell-}" ]; then
        # if a specific shell was requested, then relaunch using it
        exec "$importShell" "$0" "$@"
    elif [ -n "${importCommand-}" ]; then
        eval "$importCommand"
    else
        importEntryPoint="$1"
        shift
        source "$importEntryPoint"
    fi
fi
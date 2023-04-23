#!/usr/bin/env bash
# shellcheck disable=SC2015,SC2155
# ==================================================================
# install.sh
# ==================================================================
# Bash Bits Importer Install File
#
# File:         install.sh
# Author:       Ragdata
# Date:         15/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# PREFLIGHT
# ==================================================================
# set debug mode = false
declare -gx DEBUG=false
# if script is called with 'debug' as an argument, then set debug mode
if [[ "${1,,}" == "debug" ]]; then shift; DEBUG=true; set -- "${@}"; set -axeET; else set -aeET; fi
# ==================================================================
# VARIABLES
# ==================================================================
#
# ENVIRONMENT VARIABLES
#
declare IMPORT_DEBUG=1
#
# ANSI VARIABLES
#
declare ANSI_ESC=$'\033'
declare ANSI_CSI="${ANSI_ESC}["
#
# COLOR VARIABLES
#
declare RED="$(printf '%s31m' "$ANSI_CSI")"
declare BLUE="$(printf '%s94m' "$ANSI_CSI")"
declare GREEN="$(printf '%s32m' "$ANSI_CSI")"
declare GOLD="$(printf '%s33m' "$ANSI_CSI")"
declare RESET="$(printf '%s0m' "$ANSI_CSI")"
#
# LOCAL CONFIG VARIABLES
#
SYMBOL_ERROR="[-]"
SYMBOL_WARNING="[!]"
SYMBOL_INFO="[=]"
SYMBOL_SUCCESS="[+]"
# ==================================================================
# FUNCTIONS
# ==================================================================
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
# @exitcode     2   ERROR - Requires Argument
# @exitcode     3   ERROR - Invalid Argument
# ------------------------------------------------------------------
install::echoAlias()
{
    local msg="${1:-}"
    local COLOR=""
    local OUTPUT=""
    local PREFIX=""
    local SUFFIX=""
    local _0=""
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

#    return 0
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
# scriptPath
# ------------------------------------------------------------------
# @description Determine the calling script's current path
#
# @noargs
#
# @stdout The calling script's current path
# ------------------------------------------------------------------
scriptPath() { printf '%s' "$(realpath "${BASH_SOURCE[0]}")"; }
# ------------------------------------------------------------------
# install::cacheDir
# ------------------------------------------------------------------
# @description Determine the path to bb-import
#
# @noargs
#
# @stdout The path to bb-import
# ------------------------------------------------------------------
install::cacheDir()
{
    local home="${HOME:-"$(printf '%s' ~)"}"
    local default="$home/.bb"
    [ "$(uname -s)" = "Darwin" ] && default="$home/Library/Caches"
    printf '%s' "${XDG_CACHE_HOME:-${LOCALAPPDATA:-$default}}/$1"
}
# ------------------------------------------------------------------
# install::cacheDir::import
# ------------------------------------------------------------------
# @description Determine the path to bb-import
#
# @noargs
#
# @stdout The path to bb-import
# ------------------------------------------------------------------
install::cacheDir::import() { printf '%s' "${IMPORT_CACHE:-$(install::cacheDir bb-import.sh)}"; }
# ------------------------------------------------------------------
# install::install
# ------------------------------------------------------------------
install::install()
{
    clear
    echo
	echoGold "=================================================================="
	echoGold "INSTALLING BB-IMPORT MODULE"
	echoGold "=================================================================="
    echo

    local installPath cacheDir cache
    local url urlPath cachePath locFile dir linkDir hash hashFile
    local location="https://raw.githubusercontent.com/bash-bits/bb-import/master/src/bb-import.sh"
    local installPath="/usr/local/bin/bb-import"

    # bb-import not installed - fresh install
    url="bb-import"
    cacheDir="$(install::cacheDir)"
    cache="$(install::cacheDir::import)"
    urlPath="$(echo "$url" | sed 's/\:\///')"
    cachePath="$cache/links/$urlPath"
    dir="$(dirname "$urlPath")"
    linkDir="$cache/links/$dir"

    echo "Creating directories:"
    echo "    $linkDir"
    echo "    $cache/data"
    echo "    $cache/locations/$dir"
    # create cache paths
    mkdir -p "$linkDir" "$cache/data" "$cache/locations/$dir" >&2 || return

    tmpFile="$cachePath.tmp"
    locFile="$cache/locations/$urlPath"

    echo "Downloading $location -> $tmpFile"
    # download to temp directory so sha1sum can be computed
    install::retry curl -sfLS --netrc-optional --connect-timeout 5 --output "$tmpFile" "$location" || {
        local r=$?
        echo "Failed to download: $location" >&2
        rm -f "$tmpFile"
        return "$r"
    }
    sudo cp "$tmpFile" "$installPath" || { r=$?; echo "Failed to install bb-import in $installPath"; return "$r"; }
    sudo chmod +x "$installPath"
    echo "Resolved location '$url' -> '$location'"
    echo "$location" > "$locFile"

    #calculate the sha1 hash of the contents of the download file
    hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return
    echo "Calculated hash '$url' -> '$hash'"
    hashFile="$cache/data/$hash"
    # If the hashed file doesn't exist, then move it into place
    # otherwise delete the temp file - it's no longer needed.
    [[ -f "$hashFile" ]] && { rm -f "$tmpFile" || return; } || { mv "$tmpFile" "$hashFile" || return; }

    # create a relative symlink for this import pointing to the hashed file
    local relative cacheStart
    [[ "${linkDir:0-1}" == "." ]] && linkDir="${linkDir:0:${#linkDir}-2}"
    # shellcheck disable=SC2034
    cacheStart="$(( "${#cache}" + 1 ))" || return
    relative="$(echo "$linkDir" | awk '{print substr($0, '"$cacheStart"')}' | sed 's/\/[^/]*/..\//g')data/$hash" || return
    printf "import: Creating symlink " >&2
    ln -fs${IMPORT_DEBUG:+v} "$relative" "$cachePath" >&2 || return

    [ -n "${IMPORT_TRACE-}" ] && echo "$location" >> "$IMPORT_TRACE"

    echo "Successfully downloaded '$url' -> '$hashFile'"
    echo "SYMLINK: '$relative' -> '$cachePath'"

    echo "Creating path file ..."
    # prepend cacheDir to $PATH
    echo "PATH=\"$cacheDir:\$PATH\"" > "$cacheDir/bb-path.sh"
    source "$cacheDir/bb-path.sh"
    # install for bash ... everyone else is on their own
    if [[ "$SHELL" =~ .*bash.* ]]; then
        echo -n "Moving path file to /etc/profile.d directory ... "
        if sudo cp "$cacheDir/bb-path.sh" /etc/profile.d/bb-path.sh; then echo "DONE"; writePath=1; else echo "FAIL"; writePath=0; fi
    fi

    # TODO :: Read / Write config variables

    echo
    echoGold "INSTALLATION COMPLETE!"
	echoGold "=================================================================="
	echo

    case "$1" in
        1) install::shebang "$cache" "$cachePath" "$relative" "$writePath";;
        2) install::source "$cache" "$cachePath" "$relative" "$writePath";;
    esac
}
# ------------------------------------------------------------------
# install::uninstall
# ------------------------------------------------------------------
install::uninstall()
{
    echo
    echoSuccess "Uninstalling ... " -n
    rm -Rf "$HOME/.bb"
    sudo rm -f /usr/local/bin/bb-import
    sudo rm -f /etc/profile.d/bb-path.sh
    echoSuccess "DONE!"
    echo
}
# ------------------------------------------------------------------
# install::quit
# ------------------------------------------------------------------
install::quit()
{
    echo
    echoGold "Program terminated at user request"
    echo

    exit 0
}
# ------------------------------------------------------------------
# install::retry
# ------------------------------------------------------------------
install::retry()
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
# install::returnQuit
# ------------------------------------------------------------------
install::returnQuit()
{
    echo
    echoSuccess "Do you want to (R)eturn to the Menu, or (Q)uit? (R/${GOLD}Q${RESET}) " -n
    while [[ ! "$RESP" =~ [rRqQ] ]]
    do
        read -r -n 1 RESP
        [[ -z "$RESP" ]] && RESP="Q"
    done
    echo

    case "$RESP" in
        r|R)
            unset INST
            unset RESP
            install::menu
            ;;
        q|Q)
            install::quit
            ;;
    esac
}
# ------------------------------------------------------------------
# install::shebang
# ------------------------------------------------------------------
install::shebang()
{
    local cache="$1"
    local cacheDir="$(dirname "$cache")"
    local cachePath="$2"
    local relative="$3"

	echoGold "=================================================================="
	echoGold "USAGE :: SHEBANG INSTALL"
	echoGold "=================================================================="
    echo
    echoRed "NOTE: YOU ARE GOING TO WANT TO WRITE SOME OF THIS DOWN SOMEWHERE!"
    echo
    echo "Include the following shebang at the top of every file you want to"
    echo "use BB-Import in:"
    echo
    echoGold "#!/usr/bin/env bb-import"
    echo
    echo "And import files like so:"
    echo
    echo "bb::import bb-ansi                      # IMPLICIT IMPORT of Bash-Bits Module"
    echo "bb::import bb-ansi@1.1.0                # IMPLICIT IMPORT of specific version"
    echo "bb::import github-org/repo              # NAMESPACED IMPORT of a GitHub Repository"
    echo "bb::import https://example.com/project  # EXPLICIT IMPORT"
    echo "bb::import ../../myfile.sh              # RELATIVE IMPORT"
    echo
    echo "And that's really all there is to it."
    echo
    echo "Important Locations:"
    echo "  - Cache Directory: '$cacheDir'"
    echo "  - Cache Path: '$cachePath'"
    echo "  - Symlink: '$relative'"
    echo
	echoGold "=================================================================="
}
# ------------------------------------------------------------------
# install::source
# ------------------------------------------------------------------
install::source()
{
    local cache="$1"
    local cacheDir="$(dirname "$cache")"
    local cachePath="$2"
    local relative="$3"

	echoGold "=================================================================="
	echoGold "USAGE :: SOURCE INSTALL"
	echoGold "=================================================================="
    echo
    echoRed "NOTE: YOU ARE GOING TO WANT TO WRITE SOME OF THIS DOWN SOMEWHERE!"
    echo
    echo "Include the following code at the top of every file you want to"
    echo "use BB-Import in:"
    echo
    echoGold "source ~/.bb/bb-import"
    echo
    echo "And import files like so:"
    echo
    echo "bb::import bb-ansi                      # IMPLICIT IMPORT of Bash-Bits Module"
    echo "bb::import bb-ansi@1.1.0                # IMPLICIT IMPORT of specific version"
    echo "bb::import github-org/repo              # NAMESPACED IMPORT of a GitHub Repository"
    echo "bb::import https://example.com/project  # EXPLICIT IMPORT"
    echo "bb::import ../../myfile.sh              # RELATIVE IMPORT"
    echo
    echo "And that's really all there is to it."
    echo
    echo "Important Locations:"
    echo "  - Cache Directory: '$cacheDir'"
    echo "  - Cache Path: '$cachePath'"
    echo "  - Symlink: '$relative'"
    echo
	echoGold "=================================================================="
}
# ------------------------------------------------------------------
# install::menu
# ------------------------------------------------------------------
install::menu()
{
    clear
    echo
	echoGold "=================================================================="
	echoGold "BASH-BITS CORE INSTALLER MENU"
	echoGold "=================================================================="
	echo
	echo "Install Type:"
	echo "  1) Shebang"
	echo "  2) Source"
	echo "Other Options:"
	echo "  3) Uninstall"
	echo "  Q) Quit"
	echo
	echoSuccess "Type your selection: (${GOLD}1${RESET}/2/3/Q) " -n
	while [[ ! "$INST" =~ [123Qq] ]]
	do
	    read -r -n 1 INST
	    [[ -z "$INST" ]] && INST="1"
	done
	echo

	case "$INST" in
	    1|2)
	        install::install "$INST"
	        ;;
	    3)
	        install::uninstall
	        ;;
	    q|Q)
	        install::quit
	        ;;
	esac

	install::returnQuit
}
# ==================================================================
# MAIN
# ==================================================================
install::menu

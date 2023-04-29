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
declare -gx INSTALL_DEBUG=0
# if script is called with 'debug' as an argument, then set debug mode
if [[ "${1,,}" == "debug" ]]; then shift; INSTALL_DEBUG=1; set -- "${@}"; set -axeET; else set -aeET; fi
# ==================================================================
# VARIABLES
# ==================================================================
#
# BUILD VARIABLES
#
declare -gx INSTALL_VERSION="v-1.0.0"
declare -gx INSTALL_BUILD="x"
declare -gx INSTALL_BUILD_DATE="2023-04-15T16:00:00+10:00"
#
# DEFAULT PATHS
#
[[ -z "${IMPORT_BASE_DIR}" ]] && declare -gx IMPORT_BASE_DIR="$HOME/.bb"
[[ -z "${IMPORT_CACHE_DIR}" ]] && declare -gx IMPORT_CACHE_DIR="${IMPORT_BASE_DIR}/cache"
[[ -z "${IMPORT_LOG_DIR}" ]] && declare -gx IMPORT_LOG_DIR="${IMPORT_BASE_DIR}/log"
[[ -z "${IMPORT_LOG}" ]] && declare -gx IMPORT_LOG="${IMPORT_LOG_DIR}/import"
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
[[ -z "${SYMBOL_ERROR}" ]] && declare -gx SYMBOL_ERROR="🚫"
[[ -z "${SYMBOL_WARNING}" ]] && declare -gx SYMBOL_WARNING="⚠️"
[[ -z "${SYMBOL_INFO}" ]] && declare -gx SYMBOL_INFO="ℹ️"
[[ -z "${SYMBOL_SUCCESS}" ]] && declare -gx SYMBOL_SUCCESS="✅"
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

	local url="bb-import"
	local location="https://raw.githubusercontent.com/bash-bits/bb-import/master/src/bb-import.sh"
	[[ "$1" -eq 1 ]] && installPath="/usr/local/bin/bb-import" || installPath="${IMPORT_BASE_DIR}/bb-import"
	local cachePath="${IMPORT_CACHE_DIR}/links/bb-import"
	local tmpFile="$cachePath.tmp"
	local locFile="${IMPORT_CACHE_DIR}/locations/bb-import"

	if [[ ! -d "${IMPORT_CACHE_DIR}" ]]; then
		echo "Creating Directories:"
		echo "    ${IMPORT_CACHE_DIR}"
		echo "    ${IMPORT_LOG_DIR}"

		mkdir -p "${IMPORT_CACHE_DIR}" "${IMPORT_LOG_DIR}" || errorReturn "Unable to Create Base Directories!" 2
	fi

	if [[ -f "$cachePath" ]]; then
		echo "Deleting old version ..."
		rm -f "$(readlink "$cachePath")"
		rm -f "$cachePath"
		rm -f "$locFile"
		if [[ -f /usr/local/bin/bb-import ]]; then
			sudo mv /usr/local/bin/bb-import /usr/local/bin/bb-import~ || errorReturn "Unable to Remove Previous Version!" 3
		elif [[ -f "${IMPORT_BASE_DIR}/bb-import" ]]; then
			mv "${IMPORT_BASE_DIR}/bb-import" "${IMPORT_BASE_DIR}/bb-import~" || errorReturn "Unable to Remove Previous Version!" 3
		fi
	fi

	# download bb-import
	echo "Downloading '$location' -> '$tmpFile'"
	install::retry curl -sfLS --netrc-optional --connect-timeout 5 --output "$tmpFile" "$location" || { local r=$?; importWarning "Failed to download '$location'" >&2; return "$r"; }
	# record location in locFile
	echo "Recording Location in '$locFile'"
	echo "$location" > "$locFile"
	# install bb-import
	echo "Installing BB-Import to '$installPath'"
	if [[ "$1" -eq 1 ]]; then
		sudo cp "$tmpFile" "$installPath" || { r=$?; echo "Failed to install BB-Import in '$installPath'"; return "$r"; }
		sudo chmod +x "$installPath"
	else
		cp "$tmpFile" "$installPath" || { r=$?; echo "Failed to install BB-Import in '$installPath'"; return "$r"; }
	fi

	# calculate file hash
	echo "Calculating File Hash"
	hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return 1
	echo "Calculated hash '$url' -> '$hash'"
	hashFile="${IMPORT_CACHE_DIR}/data/$hash"
	mv "$tmpFile" "$hashFile" || return 1

	# create symlink
	echo "Creating Symlink for '$cachePath' -> '$hashFile'"
	ln -fs "$hashFile" "$cachePath" || return 1

    echo
    echoGold "INSTALLATION COMPLETE!"
	echoGold "=================================================================="
	echo

    case "$1" in
        1) install::global "${IMPORT_CACHE_DIR}" "$cachePath" "$hashFile";;
        2) install::local "${IMPORT_CACHE_DIR}" "$cachePath" "$hashFile";;
    esac
}
# ------------------------------------------------------------------
# install::uninstall
# ------------------------------------------------------------------
install::uninstall()
{
    echo
    echoSuccess "Uninstalling ... " -n
    rm -Rf "${IMPORT_BASE_DIR}"
    sudo rm -f /usr/local/bin/bb-import
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
# install::global
# ------------------------------------------------------------------
install::global()
{
    local cache="$1"
    local cacheDir="$(dirname "$cache")"
    local cachePath="$2"
    local relative="$3"

	echoGold "=================================================================="
	echoGold "USAGE :: GLOBAL INSTALL"
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
# install::local
# ------------------------------------------------------------------
install::local()
{
    local cache="$1"
    local cacheDir="$(dirname "$cache")"
    local cachePath="$2"
    local relative="$3"

	echoGold "=================================================================="
	echoGold "USAGE :: LOCAL INSTALL"
	echoGold "=================================================================="
    echo
    echoRed "NOTE: YOU ARE GOING TO WANT TO WRITE SOME OF THIS DOWN SOMEWHERE!"
    echo
    echo "Include the following code at the top of every file you want to"
    echo "use BB-Import in:"
    echo
    echoGold "source ${IMPORT_BASE_DIR}/bb-import"
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
	echo "  1) Global (/usr/local/bin/bb-import)"
	echo "  2) Local (${IMPORT_BASE_DIR}/bb-import)"
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

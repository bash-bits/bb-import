#!/usr/bin/env bash
# shellcheck disable=SC2015
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
# ------------------------------------------------------------------
if ! command -v echoAlias; then
echoAlias()
{
	local msg="${1:-}"
	local COLOR OUTPUT
	local PREFIX=""
	local SUFFIX=""
	local STREAM="1"

	local OUTARGS=()

	[[ -z "$msg" ]] && { echo "${RED}ERROR :: echoAlias :: Requires Argument!${RESET}"; return 2; }

	shift

    while getopts ":c:p:s:eEn" char
    do
        case "$char" in
            c)                              # color
                COLOR="${OPTARG}";;
            p)                              # prefix
                PREFIX="${OPTARG}";;
            s)                              # suffix
                SUFFIX="${OPTARG}";;
            e)                              # error
                STREAM=2;;
            E)                              # escape
                OUTARGS+=("-e");;
            n)                              # noline
                OUTARGS+=("-n");;
            :)
                echo "${GOLD}WARNING :: echoAlias :: Unexpected Argument!${RESET}" >&2
                ;;
            *)
                echo "${RED}ERROR :: echoAlias :: Invalid Argument!${RESET}" >&2
                return 3
                ;;
        esac
    done

	OUTPUT="${COLOR}${PREFIX}$msg${SUFFIX}${RESET}"

	[[ "$STREAM" -eq 2 ]] && echo "${OUTARGS[@]}" "$OUTPUT" >&2 || echo "${OUTARGS[@]}" "$OUTPUT"

	return 0
}
fi
#
# COLOUR ALIASES
#
if ! command -v echoRed; then echoGold() { echoAlias "$1" -c="${RED}" "${@:2}"; } fi
if ! command -v echoBlue; then echoGold() { echoAlias "$1" -c="${BLUE}" "${@:2}"; } fi
if ! command -v echoGreen; then echoGold() { echoAlias "$1" -c="${GREEN}" "${@:2}"; } fi
if ! command -v echoGold; then echoGold() { echoAlias "$1" -c="${GOLD}" "${@:2}"; } fi
#
# MESSAGE ALIASES
#
if ! command -v echoError; then echoError() { echoAlias "$SYMBOL_ERROR $1" -c="${RED}" --err "${@:2}"; } fi
if ! command -v echoWarning; then echoWarning() { echoAlias "$SYMBOL_WARNING $1" -c="${GOLD}" --err "${@:2}"; } fi
if ! command -v echoInfo; then echoInfo() { echoAlias "$SYMBOL_INFO $1" -c="${BLUE}" "${@:2}"; } fi
if ! command -v echoSuccess; then echoSuccess() { echoAlias "$SYMBOL_SUCCESS $1" -c="${GREEN}" "${@:2}"; } fi
if ! command -v errorReturn; then errorReturn() { echoAlias "$SYMBOL_ERROR $1" -c="${RED}" --err; return "${2:-1}"; } fi
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
install::cacheDir::import() { printf '%s' "${IMPORT_CACHE:-$(import::cacheDir bb-import)}"; }
# ------------------------------------------------------------------
# install::install
# ------------------------------------------------------------------
install::install()
{
    clear
	echoGold "  =================================================================="
	echoGold "  INSTALLING BB-CORE MODULE"
	echoGold "  =================================================================="
    echo

    local scriptDir repoPath installPath cacheDir cache
    local url urlPath cachePath locFile dir linkDir hash hashFile
    local location="https://raw.githubusercontent.com/bash-bits/bb-import/master/src/bb-import"

#    [[ "$SUDO_USER" ]] && user="root" || user="$(whoami)"

    scriptDir="$(dirname "$(scriptPath)")"

    installPath="$(install::cacheDir::import)"
    cacheDir="${installPath%/*}"
    cache="$installPath"

    url="bb-import"
    urlPath="$(echo "$url" | sed 's/\:\///')"
    cachePath="$cache/links/$urlPath"
    locFile="$cache/locations/$urlPath"
    tmpFile="$cachePath.tmp"

    dir="$(dirname "$urlPath")"
    linkDir="$cache/links/$dir"

    echo "  Creating directories:"
    echo "      $linkDir"
    echo "      $cache/data"
    echo "      $cache/locations/$dir"
    echo

    mkdir -p "$linkDir" "$cache/data" "$cache/locations/$dir" >&2 || errorReturn "Could Not Create Directory '$cacheDir'" 2

    # resolve the cache and link with `pwd` now that the directories exist
    cache="$( ( cd "$cache" && pwd ) )" || return
    linkDir="$( ( cd "$linkDir" && pwd ) )" || return
    cachePath="$cache/links/$urlPath"

    # install bb-import
    if [[ -f "$scriptDir/src/bb-import" ]]; then
        echo "  Installing from local repository ... "
        # install from local repository
        repoPath="$scriptDir/src/bb-import"
        mv "$repoPath" "$installPath" || errorReturn "Installation Failed!" 2
    else
        echo "  Downloading from '$location' ..."
        # download & install
        curl -sfLS "$location" > "$installPath" || errorReturn "Download Failed! Try again later" 2
        echo "  SUCCESS!"
    fi
    chmod +x "$installPath"

    echo "$location" > "$locFile"

    echo "  Calculating file hash ..."

    # calculate the hash of the downloaded file
    hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return
    echo "  FILE HASH: '$hash'"
    hashFile="$cache/data/$hash"
    echo "  HASH FILE: '$hashFile'"
    echo

    # if the hashed file doesn't exist, move it into place,
    # otherwise delete the temp file - it's no longer needed
    if [ -f "$hashFile" ]; then
        rm -f "$tmpFile" || return
    else
        mv "$tmpFile" "$hashFile" || return
    fi

    echo "  Creating symlink pointing to hashed file ..."

    # create a relative symlink for this import pointing to the hashed file
    local relative cacheStart
    # shellcheck disable=SC2003
    cacheStart="$(expr "${#cache}" + 1)" || return
    relative="$(echo "$linkDir" | awk '{print substr($0, '"$cacheStart"')}' | sed 's/\/[^/]*/..\//g')data/$hash" || return
    [ -n "${IMPORT_DEBUG-}" ] && importDebug "import :: Creating symlink"
    ln -fs${IMPORT_DEBUG:+v} "$relative" "$cachePath" >&2 || return

    echo "  SYMLINK: '$relative' -> '$cachePath'"
    echo

    echo "  Creating path file ... "
    echo

    # prepend cacheDir to $PATH
    echo "PATH=\"$cacheDir:\$PATH\"" > "$cacheDir/bb-path.sh"

    # install for bash ... everyone else is on their own
    if [[ "$SHELL" =~ .*bash.* ]]; then
        echo -n "  Moving path file to /etc/profile.d directory ... "
        if sudo cp "$cacheDir/bb-path.sh" /etc/profile.d/bb-path.sh; then echo "DONE"; writePath=1; else echo "FAIL"; writePath=0; fi
    fi

    # TODO :: Read / Write config variables

    echoGold "  INSTALLATION COMPLETE!"
	echoGold "  =================================================================="
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
    echo "  Uninstalling ... " -n
    rm -Rf "$HOME/.bb"
    echoSuccess "DONE!"
    echo
}
# ------------------------------------------------------------------
# install::quit
# ------------------------------------------------------------------
install::quit()
{
    echo
    echoGold "  Program terminated at user request"
    echo
}
# ------------------------------------------------------------------
# install::returnQuit
# ------------------------------------------------------------------
install::returnQuit()
{
    echo
    echo "  Do you want to (R)eturn to the Menu, or (Q)uit? (R/${GOLD}Q${RESET}) " -n
    while [[ ! "$RESP" =~ [rRqQ] ]]
    do
        read -r -n 1 RESP
        [[ -z "$RESP" ]] && RESP="Q"
    done

    case "$RESP" in
        r|R)
            unset INST
            unset RESP
            install::main
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

	echoGold "  =================================================================="
	echoGold "  USAGE :: SHEBANG INSTALL"
	echoGold "  =================================================================="
    echo
    echoRed "  NOTE: YOU ARE GOING TO WANT TO WRITE SOME OF THIS DOWN SOMEWHERE!"
    echo
    echo "  Include the following shebang at the top of every file you want to"
    echo "  use BB-Import in:"
    echo
    echo "  #!/usr/bin/env bb-import"
    echo
    echo "  And import files like so:"
    echo
    echo "  bb::import bb-ansi                      # IMPLICIT IMPORT of Bash-Bits Module"
    echo "  bb::import bb-ansi@1.1.0                # IMPLICIT IMPORT of specific version"
    echo "  bb::import github-org/repo              # FOREIGN IMPORT of a GitHub Repository"
    echo "  bb::import https://example.com/project  # EXPLICIT IMPORT"
    echo "  bb::import ../../myfile.sh              # RELATIVE IMPORT"
    echo
    echo "  And that's really all there is to it."
    echo
    echo "  Important Locations:"
    echo "      - Cache Directory: '$cacheDir'"
    echo "      - Cache Path: '$cachePath'"
    echo "      - Symlink: '$relative'"
    echo
	echoGold "  =================================================================="
}
# ------------------------------------------------------------------
# install::source
# ------------------------------------------------------------------
install::source()
{
    local cache="$1"
    local cachePath="$2"
    local relative="$3"

	echoGold "  =================================================================="
	echoGold "  USAGE :: SOURCE INSTALL"
	echoGold "  =================================================================="
    echo
    echoRed "  NOTE: YOU ARE GOING TO WANT TO WRITE SOME OF THIS DOWN SOMEWHERE!"
    echo
}
# ------------------------------------------------------------------
# install::menu
# ------------------------------------------------------------------
install::menu()
{
    clear
    echo
	echoGold "  =================================================================="
	echoGold "  BASH-BITS CORE INSTALLER MENU"
	echoGold "  =================================================================="
	echo
	echo "  Install Type:"
	echo "      1) Shebang"
	echo "      2) Source"
	echo "  Other Options:"
	echo "      3) Uninstall"
	echo "      Q) Quit"
	echo
	echoSuccess -n "  Type your selection: (${GOLD}1${RESET}/2/3/Q) "
	echo
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

# ==================================================================
# OUTLINE
# ==================================================================
# There are 4 options for installation:
#
# BOOTSTRAP THE FUNCTION
#
#       Installation can be anywhere on the "$PATH"
#       For example, to install to `/usr/local/bin`:
#
#       curl -sfLS https://github.com/bash-bits/bb-core/blob/master/src/bb-import > /usr/local/bin/bb-import
#       chmod +x /usr/local/bin/bb-import
#
#       Once you have bb-import installed, you can utilize it either with a shebang or by sourcing it:
#
#   SHEBANG
#
#       The most straightforward way to specify bb-import as the entrypoint of a script using the shebang:
#
#       #!/usr/bin/env bb-import
#       type bb::import
#
#       NOTE: this method will use the default Bash interpreter for your system
#
#   SOURCE
#
#       Another way to bootstrap bb-import is to simply include it in your scripts using `source`
#       For example:
#
#       #!/usr/bin/env bash
#       source "$(command -v bb-import)"
#       type bb::import
#
# AUTOMAGIC DOWNLOAD
#
#       An alternative approach is to automagically download bb-import into your script without requiring installation
#
#   EVAL
#
#       It is possible to `curl` + `eval` the whole file into your script
#
#       #!/usr/bin/env bash
#       eval "$(curl -sfLS https://github.com/bash-bits/bb-core/blob/master/src/bb-import)"
#       type bb::import
#
#       NOTE: This method does not work offline, and you'll incur an HTTP request each time you execute your script
#
# CLONE THE REPO
#
#       Finally, you can always clone the repo and save it wherever you like, thereby allowing you to access it
#       on your terms.
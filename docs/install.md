# [📦 Installation](README.md)

`bb-import` is a single, self-contained shell script.  You have 4 options for installation:

1. [Automagic Online Installer](#automagic-online-installer)
2. [Manually Bootstrapping BB-Import](#manually-bootstrapping-bb-import)
3. [Clone Repository](#clone-repository)
4. [Package Download](#package-download)

<br />

## [Automagic Online Installer](#-installation)

The easiest way to install `bb-import` is to use the **Automagic Online Installer**.

All you need to do is execute the following line of code in your terminal:

```shell
bash <(curl -sfLS https://raw.githubusercontent.com/bash-bits/bb-import/master/install.sh)
```

This script will automagically install BB-Import on your local machine in `SHEBANG` mode, into a directory under your HOME directory, and will ensure that all the relevant directories are created.  It will also ensure `bb-import` itself has all the infrastructure necessary to take advantage of the automatic-update functionality coming in the next version.

If you want to change any parameters, you can do so, of course - but you're going to have to clone a copy of the repo to do it (see below).

<br />

## [Manually Bootstrapping BB-Import](#-installation)

The process documented here is basically the manual version of using the [Automagic Online Installer](#automagic-online-installer).

Technically, you can install this script _anywhere_ on your `$PATH` - but to take advantage of the caching mechanisms, you'll need to do the following:

(You can either copy and paste each line to your terminal, or copy one whole block of code at a time and paste it into your terminal)

### Step 1 - Preparing Directories

First we're going to borrow a few snippets of code from the importer to make life easier:

```shell
location="https://raw.githubusercontent.com/bash-bits/bb-import/master/src/bb-import.sh"
installPath="/usr/local/bin/bb-import"
url="bb-import"
cacheDir="$HOME/.bb"
cache="$cacheDir/bb-import.sh"
urlPath="$(echo "$url" | sed 's/\:\///')"
cachePath="$cache/links/$urlPath"
dir="$(dirname "$urlPath")"
linkDir="$cache/links/$dir"
echo "Creating directories:"
echo "    $linkDir"
echo "    $cache/data"
echo "    $cache/locations/$dir"
mkdir -p "$linkDir" "$cache/data" "$cache/locations/$dir" >&2 || return
```

### Step 2 - Download bb-import.sh

```shell
tmpFile="$cachePath.tmp"
tmpHeader="$cachePath.header"
locFile="$cache/locations/$urlPath"
echo "Downloading $location -> $tmpFile"
curl -sfLS --netrc-optional --output "$tmpFile" "$location" || { r=$?; echo "Failed to download: $location" >&2; rm -f "$tmpFile"; return "$r"; }
sudo cp "$tmpFile" "$installPath" || { r=$?; echo "Failed to install bb-import in $installPath"; return "$r"; }
sudo chmod +x "$installPath"
echo "Resolved location '$url' -> '$location'"
echo "$location" > "$locFile"
```

### Step 3 - Get File Hash

```shell
hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return
echo "Calculated hash '$url' -> '$hash'"
hashFile="$cache/data/$hash"
[[ -f "$hashFile" ]] && { rm -f "$tmpFile" || return; } || { mv "$tmpFile" "$hashFile" || return; }
[[ "${linkDir:0-1}" == "." ]] && linkDir="${linkDir:0:${#linkDir}-2}"
cacheStart="$(( "${#cache}" + 1 ))" || return
relative="$(echo "$linkDir" | awk '{print substr($0, '"$cacheStart"')}' | sed 's/\/[^/]*/..\//g')data/$hash" || return
printf "import: Creating symlink " >&2
ln -fs${IMPORT_DEBUG:+v} "$relative" "$cachePath" >&2 || return
[ -n "${IMPORT_TRACE-}" ] && echo "$location" >> "$IMPORT_TRACE"
echo "Successfully downloaded '$url' -> '$hashFile'"
echo "SYMLINK: '$relative' -> '$cachePath'"
echo "Creating path file ..."
echo "PATH=\"$cacheDir:\$PATH\"" > "$cacheDir/bb-path.sh"
if [[ "$SHELL" =~ .*bash.* ]]; then
    echo -n "Moving path file to /etc/profile.d directory ... "
    if sudo cp "$cacheDir/bb-path.sh" /etc/profile.d/bb-path.sh; then echo "DONE"; writePath=1; else echo "FAIL"; writePath=0; fi
fi
```

<br />

## [Clone Repository](#toc)

If you think you might need to change a few options or modify some code before you install bb-import, then this is the option for you.

Simply clone the repo, make your modifications, enter the root directory, and run the installer:

```shell
git clone git@github.com:bash-bits/bb-import
... <tinker> ...
cd bb-import
bash install.sh
```

<br />

## [Package Download](#toc)

And if you're one of those people who are absolutely _determined_ to do things the hard way, you can download the latest release package from GitHub so that you can install it manually to your own specifications.

Step 1 - [**DOWNLOAD THE LATEST PACKAGE HERE**](https://github.com/bash-bits/bb-import/releases/latest)
Step 2 - Inflate the archive
Step 3 - Enter the root directory of the repository
Step 4 - `bash install.sh`


[`^ Top`](#-installation)

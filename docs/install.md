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
importURL="https://raw.githubusercontent.com/bash-bits/bb-import/master/src/bb-import.sh?format=raw"
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
echo "Downloading $importURL"
curl -sfLS --netrc-optional --dump-header "$tmpHeader" "${IMPORT_CURL_OPTS-}" "$importURL" > "$tmpFile" || { r=$?; echo "Failed to download: $importURL" >&2; rm -f "$tmpFile" "$tmpHeader"; return "$r"; }
sudo mv "$tmpFile" "$installPath"
sudo chmod +x "$installPath"
grep -i '^location\|^content-location:' < "$headers" | while IFS='' read -r line
do
    echo "${RED}import: warning - $(echo "$line" | awk -F": " '{print $2}' | tr -d \\r)${RESET}"
done
locationHeader="$(grep -i '^location|^content-location:' < "$headers" | tail -n1)"
[[ -n "$locationHeader" ]] && location="$(echo "$locationHeader" | awk -F": " '{print $2}' | tr -d \\r)"
echo "Resolved location '$url' -> '$location'"
echo "$location" > "$locFile"
rm -f "$tmpHeader"
```

### Step 3 - Get File Hash

```shell
hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })" || return
echo "Calculated hash '$url' -> '$hash'"
hashFile="$cache/data/$hash"
[[ -f "$hashFile" ]] && { rm -f "$tmpFile" || return; } || { mv "$tmpFile" "$hashFile" || return; }
cacheStart="$(( "${#cache}" + 1 ))" || return
relative="$(echo "$linkDir" | awk '{print substr($0, "$cacheStart")}' | sed 's\/[^/]*/..\//g')data/$hash" || return
printf "import: Creating symlink " >&2
ln -fs${IMPORT_DEBUG:+v} "$relative" "$cachePath" >&2 || return
[ -n "${IMPORT_TRACE-}" ] && echo "$importURL" >> "$IMPORT_TRACE"
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

<br />

## [Package Download](#toc)

And if you're one of those people who are absolutely _determined_ to do things the hard way, you can download the latest release package from GitHub so that you can install it manually to your own specifications.

[**GET THE LATEST PACKAGE HERE**](https://github.com/bash-bits/bb-import/releases/latest)

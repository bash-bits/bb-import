![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# [📦 Installation](README.md)

`bb-import` is a single, self-contained shell script.  You have a few options for installation:

## [Automagic Online Installer](#-installation)

The easiest way to install `bb-import` is to use the **Automagic Online Installer**.

All you need to do is execute the following line of code in your terminal:

```shell
bash <(curl -sfLS https://raw.githubusercontent.com/bash-bits/bb-import/master/install.sh)
```

This script will automagically install BB-Import on your local machine in `SHEBANG` mode, into a directory under your HOME directory, and will ensure that all the relevant directories are created.  It will also ensure `bb-import` itself has all the infrastructure necessary to take advantage of the automatic-update functionality coming in the next version.

If you want to change any parameters, you can do so, of course - but you're going to have to clone a copy of the repo to do it (see below).

## [Manually Bootstrapping `bb-import`](#-installation)

The process documented here is basically the manual version of using the [Automagic Online Installer](#automagic-online-installer).

Technically, you can install this script _anywhere_ on your `$PATH` - but to take advantage of the caching mechanisms, you'll need to do the following:

### Step 1 - Preparing Directories

First we're going to borrow a few snippets of code from the importer to make life easier:

```shell
cacheDir()
{
    local home="${HOME:-"$(printf '%s' ~)"}"
    local default="$home/.bb"
    [ "$(uname -s)" = "Darwin" ] && default="$home/Library/Caches"
    printf '%s' "${XDG_CACHE_HOME:-${LOCALAPPDATA:-$default}}/$1"
}

# set critical variables
cache="$(cacheDir bb-import.sh)"
url="https://raw.githubusercontent.com/bash-bits/bb-import/"
# normalize url
```

## Clone the repo

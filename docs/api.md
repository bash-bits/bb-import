![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# [📑 API](README.md)

## 🔸 `bb::import '$url'`

The core `bb-import` function, downloads the script defined by the `$url` argument and caches it to the local file system.  Finally, it sources the downloaded script, making it instantly available to you.

```shell
#!/usr/bin/env bb-import

bb::import bb-functions/string


echo "$string" | string::toUpper
# STRING
```

<br />

## 🔸 `bb::importFile '$url'`

Uses the same download and caching infrastructure as `bb::import`, but prints the local file path instead of sourcing the file.  This gives you the ability to work with arbitrary files such as scripts from other languages, simple data files, binary files, etc.

```shell
#!/usr/bin/env bb-import

php "$(bb::importFile https://raw.githubusercontent.com/organisation/repo-name/branch/path/file.php)"
```

<br />


## 🔸 `import::cacheDir '$name'`

Returns the operating system specific path to the cache directory for the given `$name`.  All `bb-import` functions honour the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) by utilising the `$XDG_CACHE_HOME` environment variable (if defined).  Otherwise, it falls back to using:

- `$HOME/Library/Caches` - MacOS
- `$LOCALAPPDATA` - Windows
- `$HOME/.cache` - Everywhere else

```shell
#!/usr/bin/end bb-import

import::cacheDir example
# /Users/ragdata/Library/Caches/example

XDG_CACHE_HOME=/cache import::cacheDir example
# /cache/example
```

<br />


## 🔸 `import::cacheDir::import`

Returns the operating system specific path to the cache directory that files imported using `bb-import` are written to.  The function returns the contents of the `IMPORT_CACHE` environment variable locally (if it's been defined - `BB_PATH_IMPORT_CACHE` globally if you're using `bb-registry` to parse ini files in your project).  Otherwise, it returns the result of `import::cacheDir bb-import.sh`

```shell
#!/usr/bin/env bb-import

import::cacheDir::import
# /Users/ragdata/Library/Caches/bb-import.sh

IMPORT_CACHE=/tmp import::cacheDir::import
# /tmp
```

[`^ Top`](#-api)

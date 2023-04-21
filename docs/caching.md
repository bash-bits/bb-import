# [📂 Caching](README.md)

Caching is a core concept in `import`.  Scripts are downloaded _exactly once_, and then are cached on your local filesystem _forever_ (unless, of course, the `IMPORT_RELOAD=1` environment variable is set).

```shell
#!/usr/bin/env bb-import

# Import script files to the `/tmp` directory
IMPORT_CACHE=/tmp

# Log information related to `bb-import` to stderr
IMPORT_DEBUG=1

# Force a fresh download of the script files (like shift+F5 in a browser)
IMPORT_RELOAD=1

bb::import bb-ansi
```

If you run this example, then you can see the file structure and order of operations because of the debug logging:

```shell
bb::import: importing 'bb-functions/assert'
bb::import: normalized URL 'https://github.com/bash-bits/bb-functions/master/src/lib/assert.sh'
bb::import: HTTP GET https://github.com/bash-bits/bb-functions/master/src/lib/assert.sh
bb::import: resolved location 'bb-functions/assert' -> 'https://github.com/bash-bits/bb-functions/master/src/lib/assert.sh'
bb::import: calculated hash 'bb-functions/assert' -> '0a1c5188c768b3b150f1a8a104bb71a3fa160aad'
bb::import: creating symlink ‘/tmp/links/https/import.sh/bb-functions/assert’ -> ‘../../../data/0a1c5188c768b3b150f1a8a104bb71a3fa160aad’
bb::import: successfully downloaded 'bb-functions/assert' -> '/tmp/data/0a1c5188c768b3b150f1a8a104bb71a3fa160aad'
bb::import: sourcing '/tmp/links/https/bb-import.sh/bb-functions/assert'
```

Now, let's take a look at what the actual directory structure looks like:

```shell
$ tree /tmp
/tmp
├── data
│   └── bf671d3752778f91ad0884ff81b3e963af9e4a4f
├── links
│   └── https
│       └── import.sh
│           └── assert -> ../../../data/bf671d3752778f91ad0884ff81b3e963af9e4a4f
└── locations
    └── https
        └── import.sh
            └── assert
```

`bb-import` generates three subdirectories under the `IMPORT_CACHE` directory:

  - `data` - The raw shell scripts, named after the sha1sum of the file contents
  - `links` - Symbolic links that are named according to the import URL
  - `locations` - Files named according to the import URL that point to the _REAL_ URL

## ⚙️ [Cache Location](#-caching)

If the `IMPORT_CACHE` environment variable is not set, the cache location defaults to the directory `bb-import.sh` in the OS-specific user cache directory.  For this user cache directory `import` considers (in order):

  - `$XDG_CACHE_HOME` (usually set on Linux)
  - `$LOCALAPPDATA` (usually set on Windows)
  - `$HOME/Library/Caches` (on MacOS)
  - `$HOME/.cache` (everywhere else)


[`^ Top`](#-caching)

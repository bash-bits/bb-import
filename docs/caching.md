# [📂 Caching](README.md)

Caching is a core concept in `import`.  Scripts are downloaded _exactly once_, and then are cached on your local filesystem _forever_ (unless, of course, the `IMPORT_RELOAD=1` environment variable is set).

```shell
#!/usr/bin/env bb-import

# Import script files to the `/tmp` directory
BB_BASE_DIR=/tmp

# Force a fresh download of the script files (like shift+F5 in a browser)
IMPORT_RELOAD=1

bb-import bb-ansi
```

Now, let's take a look at what the actual directory structure looks like:

```shell
$ tree /tmp
/tmp
└── cache
	├── data
	│   └── bf671d3752778f91ad0884ff81b3e963af9e4a4f
	├── links
	│   └── bb-import -> /tmp/cache/data/bf671d3752778f91ad0884ff81b3e963af9e4a4f
	└── locations
		└── bb-import
```

`bb-import` generates three subdirectories under the `BB_CACHE_DIR` directory:

  - `data` - The raw shell scripts, named after the sha1sum of the file contents
  - `links` - Symbolic links that are named according to the import URL
  - `locations` - Files named according to the import URL that point to the _REAL_ URL

## ⚙️ [Cache Location](#-caching)

If the `BB_BASE_DIR` or `BB_CACHE_DIR` environment variables are not set, the cache location defaults to the directory `$HOME/.bb/cache`.

[`^ Top`](#-caching)

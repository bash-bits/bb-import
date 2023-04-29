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

[`^ Top`](#-api)

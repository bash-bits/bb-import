![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# [⬇️ Explicit Imports](README.md)

Explicit Imports are those which are hosted on ANY server. 

## [Example](#example)

Let's take a look at importing this project https://github.com/ragdata/release-manaager (a sneak preview of one of my next projects)

(I know we're still importing from GitHub - just imagine it's another server ... like `example.com`)

```shell
#!/usr/bin/env bb-import

bb::import https://raw.githubusercontent.com/ragdata/release-manager/master/src/lib/rm/functions

password="$(getPassword)"
```

You can also choose to import a specific git branch, tag, or version by manipulating the relevant element of the url:

```shell
#!/usr/bin/env bb-import

bb::import https://raw.githubusercontent.com/ragdata/release-manager/develop/src/lib/rm/functions

password="$(getPassword)"
```

[`^ Top`](#-explicit-imports)

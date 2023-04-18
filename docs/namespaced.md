![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# [⬇️ Namespaced Imports](README.md)

Any `bb-import` (with 2 special exceptions) where the beginning portion (before the slash) of the URL _does not_ contain a `.` is considered to be a **Namespaced Import**

The two exceptions are where the beginning portion is either bb-functions or bb-regex.  These are _technically_ **Implicit Imports**, although they look and feel like namespaced imports.  You'll get used to it easy enough ...

A Namespaced Import means that the `IMPORT_SERVER` (which defaults to https://github.com/bash-bits) is prepended to the import URL.  For example, these two invocations are identical:

  - `bb::import bb-ansi`
  - `bb::import https://github.com/bash-bits/bb-ansi`

## [Example](#-namespaced-imports)

Let's take a look at importing this [tootalnate/hello](https://github.com/tootalnate/hello) "Hello World" import from GitHub:

```shell
#!/usr/bin/env bb-import

bb::import "tootalnate/hello"

hello
# Hello, from @TooTallNate!
```

## [The Bash-Bits Repositories](#-namespaced-imports)

The default `IMPORT_SERVER` is `https://github.com/bash-bits`, which serves GitHub repositories that are _'bb::import-compatible'_, according to the following conventions:

  - The main import syntax is `bb::import <org>/<repo>`
  - The entrypoint of the import is the file with the name of the repo and a `.sh` suffix in either the root OR src directories (root first, then src)
  - If there is no `/` in the import path, then the default organisation (`bash-bits`) is applied
  - Specific tags may be referenced by appending an `@<version>` to the end where `<version>` is either a git branch name, tag name, or version number.

## [Top-Level Imports](#top-level-imports)

The [`Bash-Bits`](https://github.com/bash-bits) GitHub Organisation houses the top-level namespace in ports.  A top-level import happens when there is no `/` in the import path

For example, the `bb-ansi` module includes functions that write ANSI color and style codes into your scripts:

```shell
#!/usr/bin/env bb-import

bb::import bb-ansi

echoGold "HERE"
# HERE (coloured GOLD)
```

Here are some useful top-level imports:



See the `Bash-Bits` repository on GitHub for the complete list of repositories.

## [Community Imports](#community-imports)

Here are some GitHub repositories that are known to be compatible with `bb-import`:

(Send a pull request) if you would like to list YOUR project here!
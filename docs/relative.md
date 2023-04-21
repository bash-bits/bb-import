# [⬇️ Relative Imports](README.md)

Any `bb-import` that begins with `./` or `../` is considered to be a `Relative Import`.

`Relative Imports` reference a file located _relative_ to the file that is importing it.  This provides a mechanism for modularization (breaking up the logic into multiple files) and code forking (for example, importing different implementations of a function based on teh shell interpreter).

## [Implementation Details](#implementation-details)

`Relative Imports` are made possible primarily because of the `Location` and/or `Content-Location` HTTP headers provided by the server that provides the imported URL.

When a script is imported, the HTTP headers are parsed, and the final `Location` / `Content-Location` header is considered the "location" of the script.  This final URL gets cached to the filesystem in the `locations` directory.

### [Example](#example)

Perhaps an example will help to illustrate.  If you inspect the response headers for the `tootallnate/hello` import, then you can see that the `content-location` header is present:

```shell
#!/bin/sh

curl -sI https://import.sh/tootallnate/hello | grep -i location
# content-location: https://raw.githubusercontent.com/tootallnate/hello/master/hello.sh
```

`bb-import` keeps track of these URL locations, so that from _within_ the `hello.sh` script, any relative import (let's say `bb::import ./foo.sh`), will be normalized to relative of the current URL location.

[`^ Top`](#-relative-imports)

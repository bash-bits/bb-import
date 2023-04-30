<h1><a name="toc" href="README.md">🔹 Command-Line / Shebang API</a></h1>

To use `BB-Import` in this mode, you need to install it somewhere on your `$PATH` (default is `/usr/local/bin/bb-import`)

## [Command-Line Usage](#toc)

When installed this way, you can use `BB-Import` like any other linux command:

```shell
bb-import <package>
```

Example:

```shell
bb-import bb-ansi
bb-import bb-functions/array
bb-import https://example.com/path/to/file.sh
bb-import ../path/to/local/file.sh
```

This will download and cache the package indicated - if it's not already cached.  To FORCE a package to be downloaded:

```shell
bb-import -f <package>
```

## [Additional Functions](#toc)

Using the same syntax as above, `BB-Import` also provides the following functions:

FLAGS:

| SHORT      | LONG             | DESCRIPTION                                                       |
|------------|------------------|-------------------------------------------------------------------|
| `-f`       | `--force`        | Force the resource to be downloaded again, even if already cached |
| `-h`       | `--help`         | Show usage information                                            |
| `-i`       | `--init-cache`   | Initialize Cache Directories (Create Directories)                 |
| `-l`       | `--list`         | List Cached Resources                                             |
| `-p`       | `--purge-cache`  | Purge Cache (Delete All)                                          |
| `-r <arg>` | `--remove <arg>` | Delete Package from Cache                                         |
| `-v`       | `--version`      | Show Version / Build Information                                  |

This functionality is also available when `BB-Import` is `sourced` rather than installed - [albeit with different syntax](api-sourced.md).
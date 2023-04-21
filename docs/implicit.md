# [⬇️ Implicit Imports](README.md)

`Implicit Imports` are all those where you are importing an official `Bash-Bits` module from the [**Bash-Bits repositories**](https://github.com/bash-bits) at GitHub

There is a fantastic range of modules designed to help you get the most out of Bash, and help you get through the process of designing and building your Bash scripts much faster.

## [Bash-Bits Official Core Modules](https://github.com/bash-bits)

| Repository Name                                                           | Namespace                           | bb-import code                       | Description                                                                                                                                                                 |
|---------------------------------------------------------------------------|-------------------------------------|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <nobr>[Bash-Bits Monorepo](https://github.com/bash-bits/bash-bits)</nobr> | bash-bits/bash-bits                 | bb::import bash-bits                 | The `Bash-Bits Monorepo` the the ONE place you can get ALL official Bash-Bits modules at once.                                                                              |
| [bb-import](https://github.com/bash-bits/bb-import)                       | bash-bits/bb-import                 | bb::import bb-import                 | `bb-import` is the module you've got right in front of you - the best part of Bash-Bits by far!                                                                             |
| [bb-ansi](https://github.com/bash-bits/bb-ansi)                           | bash-bits/bb-ansi                   | bb::import bb-ansi                   | `bb-ansi` is the module you need to help you format text and build colorful command-line scripts.                                                                           |
| [bb-dotfiles](https://github.com/bash-bits/bb-dotfiles)                   | bash-bits/bb-dotfiles               | bb::import bb-dotfiles               | `bb-dotfiles` provides a selection of the best tools available to help you make your `$HOME` life grand!                                                                    |
| [bb-functions](https://github.com/bash-bits/bb-functions) +               | <nobr>bash-bits/bb-functions</nobr> | <nobr>bb::import bb-functions</nobr> | `bb-functions` is the workhorse of the core modules.  This module contains a number of files, each of which can be imported using `bb-import` (see below)                   |
| [bb-logger](https://github.com/bash-bits/bb-logger)                       | bash-bits/bb-logger                 | bb::import bb-logger                 | `bb-logger` is a fully-featured logger library which will help you gain essential insight into the inner workings of your scripts.                                          |
| [bb-regex](https://github.com/bash-bits/bb-regex) +                       | bash-bits/bb-regex                  | bb::import bb-regex                  | `bb-regex` is a library of common regular expressions that I think you'll find very handy.  This module contains a number of files, which can be imported using `bb-import` |
| [bb-template](https://github.com/bash-bits/bb-template)                   | bash-bits/bb-template               | bb::import bb-template               | `bb-template` is a library which helps you design file templates and populate them with ease.  Great for things such as webserver configs and skeleton directories.         |

+ Both `bb-functions` and `bb-regex` work slightly differently from the others and are hiding a surprise

### [BB-Functions Module](https://github.com/bash-bits/bb-functions)

| Collection Name        | Namespace             | bb-import code                   |
|------------------------|-----------------------|----------------------------------|
| Array Functions        | bb-functions/array    | bb::import bb-functions/array    |
| Assignment Functions   | bb-functions/assign   | bb::import bb-functions/assign   |
| Benchmarking Functions | bb-functions/bench    | bb::import bb-functions/bench    |
| Date Functions         | bb-functions/date     | bb::import bb-functions/date     |
| Environment Functions  | bb-functions/env      | bb::import bb-functions/env      |
| Fail2Ban Functions     | bb-functions/fail2ban | bb::import bb-functions/fail2ban |
| Filesystem Functions   | bb-functions/file     | bb::import bb-functions/file     |
| Git Functions          | bb-functions/git      | bb::import bb-functions/git      |
| Include Functions      | bb-functions/include  | bb::import bb-functions/include  |
| 'IS' Functions         | bb-functions/is       | bb::import bb-functions/is       |
| Network Functions      | bb-functions/network  | bb::import bb-functions/network  |
| 'ON' Functions         | bb-functions/on       | bb::import bb-functions/on       |
| Path Functions         | bb-functions/path     | bb::import bb-functions/path     |
| Profiling Functions    | bb-functions/profile  | bb::import bb-functions/profile  |
| ReadKey Functions      | bb-functions/readkey  | bb::import bb-functions/readkey  |
| Registry Functions     | bb-functions/registry | bb::import bb-functions/registry |
| StdOut Functions       | bb-functions/stdout   | bb::import bb-functions/stdout   |
| Strict Functions       | bb-functions/strict   | bb::import bb-functions/strict   |
| String Functions       | bb-functions/string   | bb::import bb-functions/string   |
| Time Functions         | bb-functions/time     | bb::import bb-functions/time     |
| Utility Functions      | bb-functions/utility  | bb::import bb-functions/utility  |


[`^ Top`](#-implicit-imports)


### [BB-Regex Module](https://github.com/bash-bits/bb-regex)

| Collection Name   | Namespace         | bb-import code               |
|-------------------|-------------------|------------------------------|
| Credit Card Regex | bb-regex/cc       | bb::import bb-regex/cc       |
| Date Regex        | bb-regex/date     | bb::import bb-regex/date     |
| Docker Regex      | bb-regex/docker   | bb::import bb-regex/docker   |
| General Regex     | bb-regex/general  | bb::import bb-regex/general  |
| Network Regex     | bb-regex/network  | bb::import bb-regex/network  |
| Numeric Regex     | bb-regex/numeric  | bb::import bb-regex/numeric  |
| Options Regex     | bb-regex/options  | bb::import bb-regex/options  |
| Response Regex    | bb-regex/response | bb::import bb-regex/response |


[`^ Top`](#-implicit-imports)

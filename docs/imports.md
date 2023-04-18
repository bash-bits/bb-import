![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# [⬇️ Imports](README.md)

`bb-import` offers 4 different types of import:

| Name                                 | Example                              | Description                                                                 |
|--------------------------------------|--------------------------------------|-----------------------------------------------------------------------------|
| [Implicit Import](implicit.md) +     | `bb::import bb-ansi`                 | An Implicit Import is used to import official Bash-Bits modules from GitHub |
| [Namespaced Import](namespaced.md) + | `bb::import my-organisation/my-repo` | A Namespaced Import can be used to import files from ANY GitHub repo        |
| [Explicit Import](explicit.md)       | `https://example.com/my-project`     | An Explicit Import can be used to import files from ANY live server         |
| [Relative Import](relative.md)       | `../../file.sh`                      | Relative Imports are used to import files from your local filesystem        |

+ Any of these import types can also be used to import a particular git branch, tag or version of a file by adding an `@` symbol along with the name, tag or version.  EG: `bb::import bb-ansi@1.3.0`

## [⭐ Repo / Project Format](#-imports)

Here's the catch you all knew was coming - but it's not a very big one ...

In order to use `bb-import` with your project, it needs to be formatted correctly.  In the VERY least, it needs to look something like this:

```shell
your-org/your-repo
└── src
    └── your-repo.sh
```

If you take a look at any of the official [Bash-Bits](https://github.com/bash-bits) modules, you'll be able to see how flexible this format really can be.

NOTE: The `Explicit Import` and the `Relative Import` do NOT need to conform to this format - you can use these import types to import ANY file you like!

[`^ Top`](#-imports)

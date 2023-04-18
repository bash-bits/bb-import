![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-200x100-X.png)

# 🔑 [Authentication](README.md)

Because `bb-import` uses `curl`, you can use the standard [`.netrc` file format](https://ec.haxx.se/usingcurl-netrc.html) to define your username and passwords to the server you are importing from.

For example, to make script files in private GitHub repos accessible, create a `~/.netrc` file that contains something like:

```shell
machine     raw.githubusercontent.com
login       231a4a02aeb1fbcf164f7c444ae5a211c1451d95
password    x-oauth-basic
```

The `login` token is a [GitHub "Personal Access Token"](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).  Follow the instructions in that link to create a token for yourself.

After that, a `bb::import` call to a private repository will work as expected:

```shell
bb::import "my-organization/private-repo@0.3.5"
```

Your GitHub credentials are **NEVER** given to any server owned or operated by Ragdata or the `Bash-Bits` team.

They are used **ONLY LOCALLY** by `curl` once the server redirects to the GitHub private repo url.


[`^ Top`](#-authentication)

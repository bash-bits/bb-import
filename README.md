<h1 align="center">

<img src="https://user-images.githubusercontent.com/6827931/226166354-a7cfea07-00c0-4167-bf0a-adf323d9d125.png" alt="Bash Bits Modular Bash Library" />
<br />
<img src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/bash_logo-128x128.png" alt="Bourne Again Shell" />

[BB-Import v-1.0.0](https://github.com/bash-bits/bb-import/releases/tag/v-1.0.0)

</h1>

<h3 align="center"><em>
The Bash Bits Import Module<br />
The most important and magical part of Bash Bits!
</em></h3>


<h3 align="center">
<a href="https://github.com/bash-bits/bb-import/issues" target="_blank">Issues</a>
🔹
<a href="https://bash-bits.github.io/bb-import" target="_blank">Documentation</a>
🔹
<a href="https://github.com/bash-bits/bb-import/releases" target="_blank">Releases</a>
</h3>

<details>
<summary><h2><a name="toc">📖 Table of Contents</a></h2></summary>

- [Project Overview](#-project-overview)
- [What's Included?](#-whats-included)
- [Installation](#-installation)
  - [AUTOMAGIC-INSTALL](#automagic-install)
  - [CLONE THE REPO](#clone-the-repo)
  - [PACKAGE DOWNLOAD](#package-download)
- [Author/Maintainer](#-author--maintainer)
- [Security](#-security)
- [Available Support](#-available-support)
- [Contributors](#-contributors)
- [Supporting the Project](#-supporting-the-project)
- [Copyright & Attributions](#-copyright--attributions)
- [License](#-license)
- [Resources](#-resources)

</details>

## ⭐ [Project Overview](#toc)

**The Bash Bits Import Module - The most important and magical part of `Bash-Bits`!**

BB-Import is THE library you are going to end up using in EVERY file of EVERY Bash script you write from now on.

It's obviously a utility which imports external code / libraries into your scripts ... it's HOW BB-Import does it which is special.  Not just for installing `Bash-Bits` modules, you can use `BB-Import` to retrieve ANY compatible module from GitHub or any other server, or locally-stored files like so:

```shell
#!/usr/bin/env bb-import                    # SHEBANG INSTALL - Modify your system $PATH

source ~/.bb/bb-import                      # SOURCE INSTALL - Simple and effective

bb::import bb-ansi                          # IMPLICIT IMPORT - Official Bash-Bits Modules
bb::import myaccount/myrepo                 # NAMESPACED IMPORT - Formatted GitHub Project
bb::import https://myserver.com/project     # EXPLICIT IMPORT - Custom Download Location
bb::import ../../myfile.sh                  # RELATIVE IMPORT - Local Environment
```

You can also specify specific versions of modules for import:

```shell
bb::import bb-ansi@1.1.3
bb::import myaccount/myrepo@mybranch
bb::import https://myserver.com/project@1.2.3
```

But that's not even the best bit ...

Once BB-Import has downloaded that project / repo / script to your local machine, it is cached FOREVER - which means rather than downloading it from the internet every time you want to use the same piece of code, BB-Import will download it once, and from then on will refer to the files in its cache before venturing online.

AND THE NEXT VERSION WILL EVEN KEEP TRACK OF THE LATEST VERSIONS OF ALL IMPORTS ... which means you're ALWAYS going to have the absolute latest versions of all of your dependencies FOREVERMORE (or, until you decide for some reason that you don't want to use BB-Import anymore)

> I have to admit that this wasn't my idea.  I've modeled BB-Import after the _INCREDIBLE_ [`importpw/import`](https://github.com/importpw/import) project by Nathan Rajlich, and decided to make a modified version of it a CORE feature of my Bash-Bits project the very moment I laid eyes on it.
> 
> **As always ... I've only been able to do what I do, because I've stood upon the shoulders of giants to do it.**

[`^ Top`](#toc)

## ❓ [What's Included?](#toc)

- ✅ bb-import
- ✅ bb-import.ini

[`^ Top`](#toc)

## 📂 [Installation](#toc)

#### [AUTOMAGIC-INSTALL](#toc)

The easiest way to install Bash Bits is using the "**SUPER-AWESOME AUTOMAGIC INSTALL**".  

All you need to do is run the following snippet from your terminal:

```shell
bash <(curl -sfLS https://raw.githubusercontent.com/bash-bits/bb-import/master/install.sh)
```

This script will automagically install BB-Import on your local machine in `SHEBANG` mode, into a directory under your HOME directory.  If you want to change any parameters, you can do so, of course - but you're going to have to clone a copy of the repo to do it (see below).

#### [CLONE THE REPO](#toc)

If you want to get fussy and set all your own options for everything, then you're going to want to clone a copy of the repo to your local machine and install it manually.

First step, is to clone the repo:

```shell
git clone git@github.com:bash-bits/bb-import your/path
cd your/path
bash install.sh
```

Of course, you're probably only going to want to execute that last line after you've had a good sticky-beak at the options available in the accompanying [bb-import.ini](src/bb-import.ini) configuration file.  I'm sure you won't be disappointed - there's PLENTY of options in BB-Import that you can customize to your own liking.

#### [PACKAGE DOWNLOAD](#toc)

And if you're one of those people who are absolutely _determined_ to do things the hard way, you can download the latest release package from GitHub so that you can install it manually to your own specifications.

[**GET THE LATEST PACKAGE HERE**](https://github.com/bash-bits/bb-import/releases/latest)

[`^ Top`](#toc)

## 🚧 [Author / Maintainer](#toc)

<h3 align="center">

<a href="https://github.com/ragdata" target="_blank"><img src="https://user-images.githubusercontent.com/6827931/226143394-2003d556-9dc9-46a6-b4be-565b60546609.png" alt="Ragdata's RedEyed Software"></a>

<a href="https://github.com/ragdata" target="_blank">Created with ☕ by Ragdata</a>

</h3>

[`^ Top`](#toc)

## 🔐 [Security](#toc)

While the `Bash Bits` project follows good security practices, 100% security can never be guaranteed in any software package.  The `Bash Bits Import Module` is provided AS IS, and without warranty.  You can find more details in the [LICENSE](LICENSE) file included with this repository.

If you discover any issue regarding the security of this project, please disclose that information responsibly by sending a [security advisory][advisory].  **PLEASE DO NOT CREATE AN ISSUE OR DISCUSSION TOPIC.**  You can read more about this project's security policies [HERE][security]

[`^ Top`](#toc)

## 💪 [Available Support](#toc)

<div align="center">

<h3>

<a href="https://github.com/bash-bits/.github/blob/master/.github/SUPPORT.md" target="_blank">Read the Community Support Document</a>

<a href="https://github.com/bash-bits/bb-import/issues" target="_blank">Issues Register</a>
🔸
<a href="https://bash-bits.github.io/bb-import" target="_blank">Documentation</a>

<a href="https://discord.gg/54PkrM7TKq" target="_blank">Join the Discord Server</a>

🔹

Connect with my Social Channels

</h3>

<a href="https://twitter.com/RedEyedSoftware" target="_blank"><img src="https://img.shields.io/badge/Twitter-55ACEE?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter"></a>
<a href="https://reddit.com/r/RedeyedSoftware" target="_blank"><img src="https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white" alt="Reddit"></a>
<a href="https://facebook.com/redeyedsoftware" target="_blank"><img src="https://img.shields.io/badge/Facebook-3B5998?style=for-the-badge&logo=facebook&logoColor=white" alt="Facebook"></a>
<a href="https://discord.gg/54PkrM7TKq" target="_blank"><img src="https://img.shields.io/badge/Discord-7289da?style=for-the-badge&logo=discord&logoColor=white" alt="Substack"></a>

<a href="https://github.com/sponsors/Ragdata" target="_blank"><img src="https://img.shields.io/badge/Sponsor_Ragdata-30363D?style=for-the-badge&logo=github-sponsors&logoColor=EA4AAA" alt="GitHub Sponsors"></a>
<a href="https://ko-fi.com/ragdata" target="_blank"><img src="https://img.shields.io/badge/Support_Ragdata-F16061?style=for-the-badge&logo=ko-fi&logoColor=white" alt="GitHub Sponsors"></a>


</div>

[`^ Top`](#toc)

## 💎 [Contributors](#toc)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/github/all-contributors/bash-bits/bb-import?color=ee8449&style=for-the-badge)](CONTRIBUTORS.md)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

If you'd like to make a contribution, then please see the [**Bash Bits Contributor's Guide**][contributing]

It's not just contributions of code that I'm looking for.  If you have any ideas or suggestions about how this project may be improved, don't hesitate to [open an issue][issues] and let me know!  Contributions of ALL kinds will be recognised here if they are made part of this project - thanks to the [All-Contributors][all-contributors] bot.

[**VIEW PROJECT CONTRIBUTORS**](CONTRIBUTORS.md)

[`^ Top`](#toc)

## 👍 [Supporting the Project](#toc)

The creation and maintenance of Open Source Software is definitely a labour of love - this is never going to be a path to riches.  The truth is, it takes not only a lot of time, it creates a substantial amount of personal expense (even when you're working on a shoestring) to keep these projects freely available for all.

If you'd like more info about how you can help out, head to my [Sponsor's Page][sponsors]

[`^ Top`](#toc)

## ©️ [Copyright & Attributions](#toc)

This project incorporates ideas and / or code crafted by the following talented individuals:


* [**importpw/import**](https://github.com/importpw/import)<br />
  Copyright © 2018-2020 the Import authors<br />
  MIT Licensed



> "We see much further, and reach much higher,<br>only because we stand upon the shoulders of giants"

[`^ Top`](#toc)

## ⚖️ [License](#toc)

MIT License

Copyright © 2022-2023 Darren (Ragdata) Poulton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[`^ Top`](#toc)

## 📖 [Resources](#toc)

### Attributed Projects
- [**importpw/import**](https://github.com/importpw/import) by Nathan Rajlich

[`^ Top`](#toc)

<p align="center">
<img src="https://user-images.githubusercontent.com/6827931/226142057-e0866834-aeee-41f2-8437-5db3d57fe794.png" alt="Star - Useful">
</p>

<h3 align="center">

⭐ Star This Repo

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/bash-bits/bb-import?style=social">

<br /><br />

<a name="support-this-project" href="#toc">!! SUPPORT THIS PROJECT !!</a>

<a href="https://github.com/sponsors/ragdata" target="_blank"><img src="https://img.shields.io/badge/support_this_project-gray?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white?style=for-the-badge" alt="Support This Project"></a>

</h3>

<br />
If this project is worth something to you, and you're in a position to be able to help out financially, it would <strong>really</strong> take the pressure off here and allow me to keep working and keep it all freely available!

It doesn't have to be a lot, but you will magnify your contribution if you're able to give a little every month.  If you're not in a position to do that, but think you could make a small, one-time donation to the kitty - you'd be AMAZED how I can make a little go a LONG way!

EVERY financial supporter gets their name associated with the project.

Find out more on my [**Sponsor's Page**][sponsors]

[`^ Top`](#toc)


[advisory]: https://github.com/bash-bits/bb-import/security/advisories/new
[all-contributors]: https://allcontributors.org
[contributing]: https://github.com/bash-bits/.github/blob/master/.github/CONTRIBUTING.md
[issues]: https://github.com/bash-bits/bb-import/issues
[security]: https://github.com/bash-bits/bb-import/security/policy
[sponsors]: https://github.com/sponsors/Ragdata

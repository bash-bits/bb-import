<h1 align="center">

<img src="https://user-images.githubusercontent.com/6827931/226166354-a7cfea07-00c0-4167-bf0a-adf323d9d125.png" alt="Bash Bits Modular Bash Library" />
<br />
<img src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/bash_logo-128x128.png" alt="Bourne Again Shell" />
<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.svg" />
<source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.svg" />
<img alt="Bash-Bits" height="128" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.svg" />
</picture>

[BB-Import v-1.0.0](https://github.com/bash-bits/bb-import/releases/tag/v-1.0.0)

</h1>

<h3 align="center"><em>
The Bash Bits Import Module<br />
The Most Important and Magical Part of Bash Bits!
</em></h3>


<h3 align="center">
<a href="https://github.com/bash-bits/bb-import/issues" target="_blank">Issues</a>
🔸
<a href="https://github.com/bash-bits/bb-import/wiki" target="_blank">Documentation Wiki</a>
🔸
<a href="https://github.com/bash-bits/bb-import/releases" target="_blank">Releases</a>
</h3>

<div align="center">

![MIT](https://img.shields.io/badge/License-MIT-gold?style=for-the-badge)

</div>

<h4 align="center">

If you like this repo, please give it a ⭐ (it really does help)

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/bash-bits/bb-import?style=social">

</h4>

<details>
<summary><h2><a name="toc">📖 Table of Contents</a></h2></summary>

- [Project Overview](#-project-overview)
  - [Significant Differences from `import`](#significant-differences-between-bb-import--import-by-nathan-rajlich)
  - [Branch Reliability](#branch-reliability)
- [What's Included?](#-whats-included)
- [Installation](#-installation)
  - [INSTALLATION DOCUMENTATION](docs/install.md)
- [Author/Maintainer](#-author--maintainer)
- [Security](#-security)
- [Available Support](#-available-support)
- [Contributors](#-contributors)
- [Supporting the Project](#-supporting-the-project)
- [Copyright & Attributions](#-copyright--attributions)
- [License](#-license)
- [Resources](#-resources)

**REPOSITORY DOCUMENTATION**

- [Table of Contents](docs/README.md)
  - [API](docs/api.md)
  - [Authentication](docs/authentication.md)
  - [Caching](docs/caching.md)
  - [Config](docs/config.md)
  - [Imports](docs/imports.md)
    - [Implicit Imports](docs/implicit.md)
    - [Namespaced Imports](docs/namespaced.md)
    - [Explicit Imports](docs/explicit.md)
    - [Relative Imports](docs/relative.md)
  - [Installation](docs/install.md)

</details>

## ⭐ [Project Overview](#toc)

**The Bash Bits Import Module - The most important and magical part of `Bash-Bits`!**

_**`BB-Import` is THE library you are going to end up using in EVERY Bash script you write from now on!**_

It's obviously a utility which imports external code / libraries into your scripts ... it's HOW BB-Import does it which is special.  Not just for installing `Bash-Bits` modules, you can use `BB-Import` in any of 4 different ways to import ANY script from ANY server on the planet directly into YOUR code!

And that's not even the best bit!  Once `BB-Import` has downloaded that project / repo / script to your local machine, it is cached FOREVER - which means rather than downloading it from the internet every time you want to use your software, BB-Import will download it all once, and from then on will use its locally-cached version unless it's told to go and get a new version.

AND THE NEXT VERSION  WILL EVEN KEEP TRACK OF THE LATEST VERSIONS OF ALL OF YOUR IMPORTS AND RECOMMEND UPDATES!!  That means you're GUARANTEED to always have the very latest available versions of all of your dependencies, FOREVERMORE (or until you decide to stop using Bash-Bits for some reason ... but why would you do that???)

```shell
USAGE EXAMPLES:

#!/usr/bin/env bb-import                   # SHEBANG INSTALL - Modify your system $PATH

source ~/.bb/bb-import.sh                   # SOURCE INSTALL - Simple and effective

bb-import bb-ansi                          # IMPLICIT IMPORT - Official Bash-Bits Modules
bb-import myaccount/myrepo                 # NAMESPACED IMPORT - Formatted GitHub Project
bb-import https://myserver.com/project     # EXPLICIT IMPORT - Custom Download Location
bb-import ../../myfile.sh                  # RELATIVE IMPORT - Local Environment
```

You can even specify specific git branches, tags, or versions to import!

```shell
bb-import bb-ansi@1.1.3
bb-import myaccount/myrepo@mybranch
bb-import https://myserver.com/project@1.2.3
```

> I have to admit that this wasn't my idea.  I've modeled BB-Import after the _INCREDIBLE_ [`importpw/import`](https://github.com/importpw/import) project by Nathan Rajlich, and decided to make a modified version of it a CORE feature of my Bash-Bits project the very moment I laid eyes on it.
> 
> **As always ... I've only been able to do what I do, because I've stood upon the shoulders of giants to do it.**

### [Significant Differences Between BB-Import & `import` by Nathan Rajlich](#toc)

I'll admit, at first glance - especially upon its first release - it might be hard to spot the differences between `BB-Import` and the project that I based it on, `import` by Nathan Rajlich.  So, I'd like to take a moment to draw your attention to the main points of difference.  I'd like to add, the fact that I've done things this way is not at all intended to say that Nathan's solution is _wrong_ or inferior in **ANY** way - I just saw a way it might be done _differently_.

### 1 - No Server

BB-Import does not use a server to resolve the location of resources.

### 2 - Integrated Logger

BB-Import includes an integrated, but basic logger, to help provide insight into the import process.

### 3 - The Automagic Installer

It is possible to install BB-Import with a single command in your terminal.
 
### [Branch Reliability](#toc)

The Branch Reliability Table is a way for you to determine how close to the bleeding edge you're comfortable getting.

If you need stability, then download a branch marked with 🟢

If you're contributing code to the project, you'll want 🔴

| Branch               |    Stability    | Code Age         | Reliability |
|----------------------|:---------------:|------------------|:-----------:|
| `master`             |  latest stable  | latest release   |     🟢      |
| `develop`            | latest unstable | most recent code |     🔴      |

[`^ Top`](#toc)

## ❓ [What's Included?](#toc)

**Repository Files**

- ✅ [bb-import.sh](src/bb-import.sh)
- ✅ [install.sh](install.sh)

**Repository Documentation**

  - [Table of Contents](docs/README.md)
    - [API](docs/api.md)
    - [Authentication](docs/authentication.md)
    - [Caching](docs/caching.md)
    - [Config](docs/config.md)
    - [Imports](docs/imports.md)
      - [Implicit Imports](docs/implicit.md)
      - [Namespaced Imports](docs/namespaced.md)
      - [Explicit Imports](docs/explicit.md)
      - [Relative Imports](docs/relative.md)
    - [Installation](docs/install.md)

[`^ Top`](#toc)

## 📂 [Installation](#toc)

Run the code snippet below in your terminal to setup and install everything automagically - ready to go in 2 minutes!

```shell
bash <(curl -sfLS https://raw.githubusercontent.com/bash-bits/bb-import/master/install.sh)
```

<h3 align="center"><a href="docs/install.md" target="_blank">SEE THE REST OF THE INSTALLATION DOCUMENTATION HERE</a></h3>


[`^ Top`](#toc)

## 📛 [Badges](#toc)

[![Bash-Bits](https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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)](https://github.com/bash-bits) 

> #### If you're using Bash-Bits in your project, I'd appreciate it if you'd let people know by displaying one of these badges on your README and Websites:

<details><summary><strong>View / Hide Bash-Bits Badges</strong></summary>

[![Bash-Bits](https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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)](https://github.com/bash-bits)

> This green badge is closest to the official colour scheme of `Bash-Bits`

```markdown
[![Bash-Bits (Green Badge)](https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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)](https://github.com/bash-bits)
```

<br />

[![Bash-Bits](https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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)](https://github.com/bash-bits)

> The green / grey badge still displays the official colours, and ensures the project's name is its most readable

```markdown
[![Bash-Bits (Green / Grey Badge)](https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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)](https://github.com/bash-bits)
```

<br />

[![Bash-Bits](https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=d20000&logo=data:image/png;base64,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)](https://github.com/bash-bits)

> And the red / grey badge is for everyone who can't stand the colour green!

```markdown
[![Bash-Bits (Red / Grey Badge)](https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=d20000&logo=data:image/png;base64,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)](https://github.com/bash-bits)
```

</details>

<br />

[![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png)](https://github.com/bash-bits)

> #### Or if you prefer, you may choose to display the Bash-Bits Logo instead:

<details><summary><strong>View / Hide Bash-Bits Logos</strong></summary>

[![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png)](https://github.com/bash-bits)

> The "Full" `Bash-Bits` Logo is Yellow with a black shebang and black border ...

```markdown
[![Bash-Bits (PNG Logo)](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png)](https://github.com/bash-bits)
```

#### SVG Version:

```html
<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.svg" /></a>
```

<br />

[![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.png)](https://github.com/bash-bits)

> The `Shebang` is transparent in this version of the logo ...

```markdown
[![Bash-Bits (Cutout)](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.png)](https://github.com/bash-bits)
```

#### SVG Version:

```html
<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.svg" /></a>
```

<br />

[![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.png)](https://github.com/bash-bits)

> The "Outline" logo consists of a black shebang and border with transparent body ...

```markdown
[![Bash-Bits (Outline)](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.png)](https://github.com/bash-bits)
```

#### SVG Version:

```html
<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.svg" /></a>
```

<br />

[![Bash-Bits](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.png)](https://github.com/bash-bits)

> And the "White" logo is ... well ... WHITE!

```markdown
[![Bash-Bits (Outline)](https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.png)](https://github.com/bash-bits)
```

#### SVG Version:

```html
<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.svg" /></a>
```

</details>

[`^ Top`](#toc)

## ❤️ [Project Supporters](#toc)

<h3><a href="https://jetbrains.com" target="_blank">Many Thanks to JetBrains for Their Invaluable Support</a></h3>

<table>
<tr>
<td width="94"><a href="https://jetbrains.com" target="_blank"><img src="https://raw.githubusercontent.com/Ragdata/Ragdata/master/.github/media/brands/jetbrains.svg" alt="JetBrains" height="94" ></a></td>
<td>

**JetBrains very generously provide me with a free license for their products every month, and you can get one too if you're working on a public, open-source project!**  I've used JetBrains' IDEs for many years now, and was more than happy to pay for a license every year back when I was working in the corporate sector.  **Absolutely my first choice in IDEs!**

</td>
</tr>
</table>

<div align="center">

<h3><a href="https://github.com/sponsors/Ragdata" target="_blank">Click here to find out about available sponsorship opportunities!</a></h3>

<h4>If sponsorship isn't right for you, but you have found my work to be useful in some way,<br />would you please consider buying me a coffee to help keep me going?</h4>

<a href="https://www.buymeacoffee.com/ragdata" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

</div>

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
<a href="docs/README.md" target="_blank">Documentation</a>

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

## ©️ [Copyright & Attributions](#toc)

This project incorporates ideas and / or code crafted by the following talented individuals:


* [**importpw/import**](https://github.com/importpw/import)<br />
  Copyright © 2018-2020 the Import authors<br />
  MIT Licensed



> "We see much further, and reach much higher,<br>only because we stand upon the shoulders of giants"

[`^ Top`](#toc)

## ⚖️ [License](#toc)

![MIT](https://img.shields.io/badge/License-MIT-gold)

Copyright © 2022-2023 Darren (Ragdata) Poulton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[`^ Top`](#toc)

## 📖 [Resources](#toc)

### Attributed Projects
- [**importpw/import**](https://github.com/importpw/import) by Nathan Rajlich

[`^ Top`](#toc)

<h3 align="center">

If you like this repo, please give it a ⭐ (it really does help)

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/bash-bits/bb-import?style=social">

</h3>

[advisory]: https://github.com/bash-bits/bb-import/security/advisories/new
[all-contributors]: https://allcontributors.org
[contributing]: https://github.com/bash-bits/.github/blob/master/.github/CONTRIBUTING.md
[issues]: https://github.com/bash-bits/bb-import/issues
[security]: https://github.com/bash-bits/bb-import/security/policy
[sponsors]: https://github.com/sponsors/Ragdata

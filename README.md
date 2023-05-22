<h1 align="center">

<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash-Bits" height="128" src="https://raw.githubusercontent.com/Ragdata/media/master/project/bash-bits/logo/BB-Logo-64-Full.svg" /></a>

[BB-Import v-1.0.0](https://github.com/bash-bits/bb-import/releases/tag/v-1.0.0)

</h1>

<h3 align="center">
The Bash Bits Import Module<br /><br />
<em>The Most Important and Magical Part of Bash Bits!</em>
</h3>

<h3 align="center">
<a href="https://github.com/bash-bits/bb-import/issues" target="_blank">Issues</a>
🔸
<a href="docs/README.md" target="_blank">Documentation</a>
🔸
<a href="https://github.com/bash-bits/bb-import/releases" target="_blank">Releases</a>
</h3>

<div align="center">

![Check Status](https://img.shields.io/github/checks-status/bash-bits/bb-import/master?logo=github&style=for-the-badge)
![Open Bug Issues](https://img.shields.io/github/issues/bash-bits/bb-import/bug?logo=github&style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/bash-bits/bb-import/master?logo=github&style=for-the-badge)
![Code Size](https://img.shields.io/github/size/bash-bits/bb-import/src/bb-import.sh?logo=github&style=for-the-badge)
![MIT](https://img.shields.io/badge/License-MIT-gold?style=for-the-badge)

#### _Elapsed Project Time_

[![wakatime](https://wakatime.com/badge/user/7e04d9d4-3a44-495e-b622-69fdbafd036c/project/003c6945-ca03-4146-b723-f57d9656da98.svg?style=for-the-badge)](https://wakatime.com/badge/user/7e04d9d4-3a44-495e-b622-69fdbafd036c/project/003c6945-ca03-4146-b723-f57d9656da98)

</div>

<br />

<h4 align="center">

If you like this repo, please give it a ⭐ (it really does help)

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/bash-bits/bb-import?style=social">

</h4>

<details><summary><h2><a name="toc">📖 Table of Contents</a></h2></summary>

- [Project Overview](#-project-overview)
  - [Significant Differences from `import`](#significant-differences-between-bb-import--import-by-nathan-rajlich)
  - [Branch Reliability](#branch-reliability)
- [What's Included?](#-whats-included)
- [Installation](#-installation)
  - [INSTALLATION DOCUMENTATION](docs/install.md)
- [Available Support](#-available-support)
- [Badges](#-badges)
- [Project Supporters](#-project-supporters)
- [Author/Maintainer](#-author--maintainer)
- [Security](#-security)
- [Contributors](#-contributors)
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
  - [BB-Badges](docs/badges.md)

</details>

<br />

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

#### <u>_1 - No Server_</u>

`BB-Import` does not use a server to resolve the location of resources.

#### <u>_2 - Integrated Logger_</u>

`BB-Import` includes an integrated, but basic logger, to help provide insight into the import process.

#### <u>_3 - The Automagic Installer_</u>

It is possible to install `BB-Import` with a single command in your terminal.
 
#### [Branch Reliability](#toc)

The Branch Reliability Table is a way for you to determine how close to the bleeding edge you're comfortable getting.

If you need stability, then download a branch marked with 🟢

If you're contributing code to the project, you'll want 🔴

| Branch               |    Stability    | Code Age         | Reliability |
|----------------------|:---------------:|------------------|:-----------:|
| `master`             |  latest stable  | latest release   |     🟢      |
| `develop`            | latest unstable | most recent code |     🔴      |

[`^ Top`](#toc)

<br />

## ❓ [What's Included?](#toc)

**Repository Files**

- ✅ [bb-import.sh](src/bb-import.sh)
- ✅ [install.sh](install.sh)

<details><summary><strong>Repository Documetation</strong></summary>

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
    - [BB-Badges](docs/badges.md)

</details>

[`^ Top`](#toc)

<br />

## 📂 [Installation](#toc)

Run the code snippet below in your terminal to setup and install everything automagically - ready to go in 2 minutes!

```shell
bash <(curl -sfLS https://raw.githubusercontent.com/bash-bits/bb-import/master/install.sh)
```

<h3 align="center"><a href="docs/install.md">VIEW THE REST OF THE INSTALLATION DOCUMENTATION HERE</a></h3>

[`^ Top`](#toc)

[//]: # (## 📛 [Badges]&#40;#toc&#41;)

[//]: # ()
[//]: # (If you're using `Bash-Bits` in your project, I'd appreciate it if you'd let people know by displaying a `BB-Badge` on your README and Websites.)

[//]: # ()
[//]: # (The full compliment of badge styles is available, and you are able to colour your badges any way you like.  The `Bash-Bits` logo can also be rendered in 4 different styles:)

[//]: # ()
[//]: # (<table>)

[//]: # (<tr>)

[//]: # (<th>Full</th>)

[//]: # (<th>Cutout</th>)

[//]: # (<th>Black</th>)

[//]: # (<th>White</th>)

[//]: # (</tr>)

[//]: # (<tr>)

[//]: # (<td><img alt="Full" src="https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dfull" /></td>)

[//]: # (<td><img alt="Cutout" src="https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh" /></td>)

[//]: # (<td><img alt="Black" src="https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dblack" /></td>)

[//]: # (<td><img alt="White" src="https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dwhite" /></td>)

[//]: # (</tr>)

[//]: # (</table>)

[//]: # ()
[//]: # (<details><summary><strong>GET THE CODE HERE</strong></summary>)

[//]: # ()
[//]: # (![Full]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dfull&#41;)

[//]: # ()
[//]: # (```markdown)

[//]: # (![Full]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dfull&#41;)

[//]: # (```)

[//]: # ()
[//]: # (![Cutout]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh&#41;)

[//]: # ()
[//]: # (```markdown)

[//]: # (![Cutout]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh&#41;)

[//]: # (```)

[//]: # ()
[//]: # (![Black]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dblack&#41;)

[//]: # ()
[//]: # (```markdown)

[//]: # (![Black]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dblack&#41;)

[//]: # (```)

[//]: # ()
[//]: # (![White]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dwhite&#41;)

[//]: # ()
[//]: # (```markdown)

[//]: # (![White]&#40;https://img.shields.io/endpoint?color=555555&style=for-the-badge&url=https%3A%2F%2Fbb-badge-1tdliyg15kb1.runkit.sh%3Flogo%3Dwhite&#41;)

[//]: # (```)

[//]: # ()
[//]: # (</details>)

[//]: # ()
[//]: # (These are the official versions:)

[//]: # ([![Bash-Bits]&#40;https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41; )

[//]: # ()
[//]: # (> #### If you're using Bash-Bits in your project, I'd appreciate it if you'd let people know by displaying one of these badges on your README and Websites:)

[//]: # ()
[//]: # (<details><summary><strong>View / Hide Bash-Bits Badges</strong></summary>)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> This green badge is closest to the official colour scheme of `Bash-Bits`)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Green Badge&#41;]&#40;https://img.shields.io/badge/-Bash%20Bits-094909?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> The green / grey badge still displays the official colours, and ensures the project's name is its most readable)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Green / Grey Badge&#41;]&#40;https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=094909&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABAEAYAAAD6+a2dAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAACGQAAAhkBwacpqAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAm0SURBVHic7V1daBxVFP7OzCZpstbaxiT+tNI0KLaKttkiVdBCfVHRikIEn/qkIgiCWqlPpSCi1YpPIvSxPghFC1LwQfEHWwLBTSRIFaU/+Fdr2roxP3U3u3N8OL07u9vdzcyde2ey6X6w3PnZe+bO3DPnnHvuuWeImZkZTbBvH5HjADt3Ar29gOcB3d1S1qvpOACRv1/7P3VeHa/db0RvMTpB26FLr1CQ852d4e4n6v2GbdfCApDPA/fdB0xNAUCzHqYrGeDwYSLXBTZsAHbvlmOvvCJlb28jQm0sRZw/L0zx9tvA6dPAgQPAyAhzqaT+UcEAlR3/8cdy+vHHk2l4G3Zw5Ahw6hQwMqIYwfFPVr7x7Y5fnnjiCWBoCHjpJXWE5P0nArJZpTPaon65Y2oKyGSAgQFiHh8H+vrEyPj776Sb1kZccBygv/+yCujpSbYxbSSDnp7LQ4zK4VIbVwek31PAf//JgY6O5Brz1ltAqQR89ZWIpn/+kdIfrgiuv16GNU8/Lfu7dvnnmIEPP5Qb++GHxa9JBKxdK/VeeCF8m5nl2REBk5Ny7NdfpSwU5PzsrNwHICoWkP1CQe4tl5P9XE7+r+47lwOKRWBuDnBd4LbbpO7evVKasNGk34l5YgJYv14adPp0dMJh8O23QCbD/MADwetks0TDw2pbyvl5YeD+fuCuu5jn5hanMzlJtHatOE5++y1cuy9dknJoSNp/9my4+jrIZonee0+2X3wxOj3XBQYHncX/aBMnT4avwyxvbiWOHQve8Qr5PHDjjeGvrxBXx1eiq8scLZEAjq8CkkDYN09h3brq/WPHwtMgAm66Se/63d3yRsapNomA664zR2/FCgBw1Eb8IAJ+/z18PccBbrnF32f2dXDY6998c/h6CqUScO21+vV1sHq1OVrMAHOCKsDz9BgAqO64Ugk4cUKPThQV4DjAqlX69cOC2ez18nmAKEEV4Dh6DOB51SpAl5GiqAAASKXilwDLSgXk8/oSQDFALgfcey+zssrDIooEWFiIXwKYZACBo3SBacLNMTcnHXfxYphaEpfgOL4KCGP110MUG8B145UARGZtgPIoIAlPoI71n80CAwPCrJ2d0dvMHE0FAPEwwOgoUXe3bJscBgoSMAKZ9UQ/c7Xu15VaJ04QdXbKdhSPmmmjrBFSKTvXKdsAcRuBusaf6145/tdBoeC/+VGlSBwSwHFs6H7V7ynfCKz1u+uCGTh0SB7uG2+IuD53zj8/O6v34JlluEcEPPectFfXBsjlpHzqKf+Y4/ixjgcPyjElKRohLiPQngSwMBmUSgEffABs3sz8009maALA8DDzjz/Ktip1sHkzs2KAw4evPJ/NEr32mmzffntzWnFIAOUBNG2ol41A08PAYlF+rYzz54P9Lw4JUCrZUQECCzYAUWszAHMwdUgUnw1gcvin0NV12RVsWgLUm8dfjvC81rYByq5g01gOKiAI4pIAQIupgFaXAE7Al4J5OTBASukCP2QpKopFswyQzRK9845sb9wobT17VjrqwgUJb96zRxZAmbKUFxv+ASIB4lABtkYB5WGg6AKzw8BHHpGOe/99iZxZWIhG8+GHpdy0yfchqAcyPg4oBlHrGupBBXB4HnDHHULn33+rjawHHxS6W7cGa1dcNoA9CWA5JlAtOlHBjxs2VI/Dm2Fykiidllm36Wk55rrV/5mfFwlwzTVytWZvydgY0eCg0Dh1SveO6iOdFkafnzdLFxDGHR2V7W3bzNFdWIghJpBImGD1annwYTyAngfcfbds13a8gjBsMNHvONEnfxrBtiSwRz/GySD1FgdFsQhs2dL4PFE4iRU1AKQR4jAGW2oU0AhhuZioOQN4XniVZYMB4ogMsuEIKhuBJiaDZmakww4ckI75+ecrPYKuG27yhllUQDO1EZYB1DqCPXv8Y0TSiczA66+HowfIcxMbxCw++4yoq0vWOtiI2pJAoJQZQl9+KUbQvn3R6SkQARMT/nYtXDdcNHAmw6zCxyvDyM+cIVqxQoaUOgwA2FlVtW6diP583jxtwODSMCI7jcxkmJ991jzdWpw5I+XKlXr1TYdqKXieTd1fMRsYFSadSElg/fpo9ZmBO+800pQqFIsi/m1BHIAGbACVwOhqBTPwzDPAxATR11/Lvlrc2dkpw890Wkpla1RKG8+Tt1ENdZklWJUIeP55e+0WB6AhG6CVff8mVMDAgHTkF1/4x2t9F418FWruofZ8PJHaBlRAq0uAqCqgtWGIAcyHK8cHJQGuThgYBTCLj3+pQoWBl0qiiwsFkViZDPP0tDiolAi/+mDIEXTPPcD4uG8E/fKLlDMzMrP28stAUJ+9wvg40ZNPCp2dO6U8eBDYupX5+PHgdObmJD2a4wAffeQfz2bNLYc5elTKoEvUOjpEctY6kFat8hesEMnSNZUt1DSMRwUzA9u3y/b27XIDEg7O7OelC4eHHpJy1y4xqg4dCk/Ddf0HaRJEoj6Gh5kfe8wsbUBGFX190u5vvpFjGzeao28tKrgSf/wRrf7AgL/teXr0mIEbbojWjnrwPL28BEGxZQuzim8wPX3tw/JkkEqapIPajuvu1l9NHGUVcCM4TvDw8aULixKA2ZwEmJ4GNm1inp3Va4cNBgAkoqi1YVECEEVngL4+Kf/8M1o7bKS+ZW5tBrCeIEJ3FfDx40TKK9fTI3SiMABgLwdiKzOA9Sxhukmg0ulq3e840RkgnY5WvxFSBlzpycKiBEil9FRA7SwYc/Xq4rCwuY7fRiBIXCirAFsoFvXTwNX65//6KzydyUmi/n57NgCgP4G0FFBOE2djcWgupx8mzQwMDlYf08nIWSgA998fvl4YtLIEkIggCxJAZbMaGyMK1wFESqc++mj1mR07qnPlNMP33xPdeqvc4Jtvhrl+eGzbJu1as8YczbExot5eKdVzUOHxJhFLsuhz54QhVFIotUAE8L+CReSHjKso4KGh+vQKBSnVDN7MjJQdHUJrzZrqDKBxJL8iAr77Tu6n8v4UKrOE10L5/leulFKpLJMM1QiSLJqYR0eFATo64s8W3kZyKK8MSipRZBvJojwKSCJRZBvJozwKuHQp+Dx2G8sL8/MO8Pnn/qxW689utREEU1PAp58CFy44wN69zJ4n1uf+/Uk3rY04sH+/6veKocnJk8C778r2kSPJNKwNe2AGPvlE8imofq5yBauPCqtvyxIBr74q55pl3mhj6UL12+7dEps5MgIAIvEFdb4eXgv1+fgdO8Sn3tNT/fl43c+/B/2f6c+tL1Zf9zPxpu8rKJ3a84BkTjl6FLh40Vfx9fE/hRJHs4AKZq0AAAAASUVORK5CYII=&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=d20000&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> And the red / grey badge is for everyone who can't stand the colour green!)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Red / Grey Badge&#41;]&#40;https://img.shields.io/badge/-Bash%20Bits-555555?style=for-the-badge&labelColor=d20000&logo=data:image/png;base64,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&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (</details>)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> #### Or if you prefer, you may choose to display the Bash-Bits Logo instead:)

[//]: # ()
[//]: # (<details><summary><strong>View / Hide Bash-Bits Logos</strong></summary>)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> The "Full" `Bash-Bits` Logo is Yellow with a black shebang and black border ...)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;PNG Logo&#41;]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### SVG Version:)

[//]: # ()
[//]: # (```html)

[//]: # (<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Full.svg" /></a>)

[//]: # (```)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> The `Shebang` is transparent in this version of the logo ...)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Cutout&#41;]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### SVG Version:)

[//]: # ()
[//]: # (```html)

[//]: # (<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Cutout.svg" /></a>)

[//]: # (```)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> The "Outline" logo consists of a black shebang and border with transparent body ...)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Outline&#41;]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### SVG Version:)

[//]: # ()
[//]: # (```html)

[//]: # (<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-Outline.svg" /></a>)

[//]: # (```)

[//]: # ()
[//]: # (<br />)

[//]: # ()
[//]: # ([![Bash-Bits]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # ()
[//]: # (> And the "White" logo is ... well ... WHITE!)

[//]: # ()
[//]: # (```markdown)

[//]: # ([![Bash-Bits &#40;Outline&#41;]&#40;https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.png&#41;]&#40;https://github.com/bash-bits&#41;)

[//]: # (```)

[//]: # ()
[//]: # (#### SVG Version:)

[//]: # ()
[//]: # (```html)

[//]: # (<a href="https://github.com/bash-bits" target="_blank"><img alt="Bash Bits" height="64" src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/Logo/BB-Logo-64-White.svg" /></a>)

[//]: # (```)

[//]: # ()
[//]: # (</details>)

[//]: # ()
[//]: # ([`^ Top`]&#40;#toc&#41;)

## 💪 [Available Support](#toc)

### Project Resources

- ✅ [Issues Register](https://github.com/bash-bits/bb-import/issues)
- ✅ [Repository Documentation](docs/README.md)
- ✅ [Project Website](https://bash-bits.github.io/bb-import)

<details><summary><h3>Community Resources</h3></summary>

- [**The RedEyed Community Discord Server**](https://discord.gg/54PkrM7TKq)


- [**Community Support Document**](https://github.com/bash-bits/bb-import/blob/master/.github/SUPPORT.md)
- [**Community Standards**](https://github.com/bash-bits/bb-import/community)
- [**Community Code of Conduct**](https://github.com/bash-bits/.github/blob/master/.github/CODE_OF_CONDUCT.md)
- [**Security Policy**](https://github.com/bash-bits/bb-import/security/policy)
	- [Security Overview](https://github.com/bash-bits/bb-import/security)
	- [Security Advisories](https://github.com/bash-bits/bb-import/security/advisories)
	- [Dependabot Alerts](https://github.com/bash-bits/bb-import/security/dependabot)

</details>

[`^ Top`](#toc)

## ❤️ [Project Supporters](#toc)

<h3><a href="https://jetbrains.com" target="_blank">Many Thanks to JetBrains for Their Invaluable Support</a></h3>

<table>
<tr>
<td width="94"><a href="https://jetbrains.com" target="_blank"><img src="https://raw.githubusercontent.com/Ragdata/media/master/brand/jetbrains.svg" alt="JetBrains" height="94" ></a></td>
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

<div align="center">

[![Ragdata](https://img.shields.io/badge/-Darren_"Ragdata"_Poulton-d20000?style=for-the-badge&labelColor=555555&logo=data:image/png;base64,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)](https://github.com/Ragdata)

### [Join me & the RedEyed Community!](https://discord.gg/54PkrM7TKq)

<a href="https://twitter.com/intent/follow?screen_name=RagdataAU" target="_blank"><img alt="Twitter" src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=Twitter&logoColor=white" /></a>
<a href="https://www.reddit.com/r/RedeyedSoftware/" target="_blank"><img alt="Reddit" src="https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=Reddit&logoColor=white" /></a>
<a href="https://dev.to/ragdata" target="_blank"><img alt="Dev.to" src="https://img.shields.io/badge/dev.to-373737?style=for-the-badge&logo=dev.to&logoColor=white" /></a>
<a href="https://ragdata.substack.com/" target="_blank"><img alt="SubStack" src="https://img.shields.io/badge/Substack-FF6719?style=for-the-badge&logo=Substack&logoColor=white" /></a>
<a href="https://www.facebook.com/RedEyedSoftware/" target="_blank"><img alt="Facebook" src="https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=Facebook&logoColor=white" /></a>

[![Discord](https://img.shields.io/discord/1067204348251230298?labelColor=5865F2&label=RedEyed%20Software%20&logo=discord&logoColor=white&style=for-the-badge)](https://discord.gg/54PkrM7TKq)

</div>

[`^ Top`](#toc)

## 🔐 [Security](#toc)

While the `Bash Bits` project follows good security practices, 100% security can never be guaranteed in any software package.  The `Bash Bits Dependency Manager` is provided AS IS, and without warranty.  You can find more details in the [LICENSE](LICENSE) file included with this repository.

If you discover any issue regarding the security of this project, please disclose that information responsibly by sending a [security advisory][advisory].  **PLEASE DO NOT CREATE AN ISSUE OR DISCUSSION TOPIC.**  You can read more about this project's security policies [HERE][security]

[`^ Top`](#toc)

<br />

## 💎 [Contributors](#toc)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/github/all-contributors/bash-bits/bb-import?color=ee8449&style=for-the-badge)](CONTRIBUTORS.md)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

If you'd like to make a contribution, then please see the [**Bash Bits Contributor's Guide**][contributing]

It's not just contributions of code that I'm looking for.  If you have any ideas or suggestions about how this project may be improved, don't hesitate to [open an issue][issues] and let me know!  Contributions of ALL kinds will be recognised here if they are made part of this project - thanks to the [All-Contributors][all-contributors] bot.

[**VIEW PROJECT CONTRIBUTORS**](CONTRIBUTORS.md)

[`^ Top`](#toc)

<br />

## ©️ [Copyright & Attributions](#toc)

This project incorporates ideas and / or code crafted by the following talented individuals:


* [**importpw/import**](https://github.com/importpw/import)<br />
  Copyright © 2018-2020 the Import authors<br />
  MIT Licensed



> "We see much further, and reach much higher,<br>only because we stand upon the shoulders of giants"

[`^ Top`](#toc)

<br />

## ⚖️ [License](#toc)

![MIT](https://img.shields.io/badge/License-MIT-gold?style=for-the-badge)

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

<br />

<a href="https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fbash-bits%2Fbb-import" target="_blank"><img alt="Visitors" src="https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fbash-bits%2Fbb-import&countColor=%23d20000" /></a>
<a href="https://github.com/ragdata" target="_blank"><img alt="Ragdata" src="https://img.shields.io/badge/-Made_With_☕_By_Ragdata-D20000?style=for-the-badge" /></a>

</h3>

[advisory]: https://github.com/bash-bits/bb-import/security/advisories/new
[all-contributors]: https://allcontributors.org
[contributing]: https://github.com/bash-bits/.github/blob/master/.github/CONTRIBUTING.md
[issues]: https://github.com/bash-bits/bb-import/issues
[security]: https://github.com/bash-bits/bb-import/security/policy
[sponsors]: https://github.com/sponsors/Ragdata

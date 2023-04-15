#!/usr/bin/env bash

# ==================================================================
# install.sh
# ==================================================================
# Bash Bits Install File
#
# File:         install.sh
# Author:       Ragdata
# Date:         15/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# PREFLIGHT
# ==================================================================

# ==================================================================
# VARIABLES
# ==================================================================

# ==================================================================
# FUNCTIONS
# ==================================================================

# ==================================================================
# MAIN
# ==================================================================


# ==================================================================
# OUTLINE
# ==================================================================
# There are 4 options for installation:
#
# BOOTSTRAP THE FUNCTION
#
#       Installation can be anywhere on the "$PATH"
#       For example, to install to `/usr/local/bin`:
#
#       curl -sfLS https://github.com/bash-bits/bb-core/blob/master/src/bb-import > /usr/local/bin/bb-import
#       chmod +x /usr/local/bin/bb-import
#
#       Once you have bb-import installed, you can utilize it either with a shebang or by sourcing it:
#
#   SHEBANG
#
#       The most straightforward way to specify bb-import as the entrypoint of a script using the shebang:
#
#       #!/usr/bin/env bb-import
#       type bb::import
#
#       NOTE: this method will use the default Bash interpreter for your system
#
#   SOURCE
#
#       Another way to bootstrap bb-import is to simply include it in your scripts using `source`
#       For example:
#
#       #!/usr/bin/env bash
#       source "$(command -v bb-import)"
#       type bb::import
#
# AUTOMAGIC DOWNLOAD
#
#       An alternative approach is to automagically download bb-import into your script without requiring installation
#
#   EVAL
#
#       It is possible to `curl` + `eval` the whole file into your script
#
#       #!/usr/bin/env bash
#       eval "$(curl -sfLS https://github.com/bash-bits/bb-core/blob/master/src/bb-import)"
#       type bb::import
#
#       NOTE: This method does not work offline, and you'll incur an HTTP request each time you execute your script
#
# CLONE THE REPO
#
#       Finally, you can always clone the repo and save it wherever you like, thereby allowing you to access it
#       on your terms.
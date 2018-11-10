source /home/lxuser/software/antigen.zsh 

antigen use oh-my-zsh
antigen bundle git
antigen bundle sdkman/sdkman-cli zsh
antigen theme muse

COMPLETION_WAITING_DOTS="true"

antigen apply

# ------------------------------------------------------------------------------
# prompt color setup
autoload -Uz promptinit; promptinit
PROMPT='%F{green}%n@%F{green}%m%f %F{blue}%1~%f %# '

# ------------------------------------------------------------------------------
# python virtualenvs; set virtualenv name in emacs config!
alias activate="source ~/.virtualenvs/py36/bin/activate"

# ------------------------------------------------------------------------------
# bc alias
alias bc="bc -li"
alias dir="dir -lh --color --group-directories-first"

# ------------------------------------------------------------------------------
# reload dir colors:
eval "$(dircolors ~/.dir_colors)"

# ------------------------------------------------------------------------------
# sdkman setup
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/lxuser/.sdkman"
[[ -s "/home/lxuser/.sdkman/bin/sdkman-init.sh" ]] && source "/home/lxuser/.sdkman/bin/sdkman-init.sh"

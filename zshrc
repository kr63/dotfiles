source /home/rustam/software/antigen.zsh 

antigen use oh-my-zsh
antigen bundle git
antigen bundle sdkman/sdkman-cli zsh
antigen theme muse

COMPLETION_WAITING_DOTS="true"

export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm

antigen apply

# ------------------------------------------------------------------------------
# prompt color setup
autoload -Uz promptinit; promptinit
PROMPT='%F{green}%n@%F{green}%m%f %F{blue}%1~%f %# '

# ------------------------------------------------------------------------------
export PATH="$HOME/bin:$PATH"

# ------------------------------------------------------------------------------
# bc alias
alias bc="bc -li"
alias dir="dir -lh --color --group-directories-first"

# ------------------------------------------------------------------------------
# reload dir colors:
eval "$(dircolors ~/.dir_colors)"

# ------------------------------------------------------------------------------
# python virtualenvs; set virtualenv name in emacs config!
alias activate="source ~/.virtualenvs/default/bin/activate"

# ------------------------------------------------------------------------------
export POSTMAN_HOME="$HOME/software/Postman/"
export IDEA_HOME="$HOME/software/idea-IU/"

# ------------------------------------------------------------------------------
export _JAVA_AWT_WM_NONREPARENTING=1

# ------------------------------------------------------------------------------
# sdkman setup
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/rustam/.sdkman"
[[ -s "/home/rustam/.sdkman/bin/sdkman-init.sh" ]] && source "/home/rustam/.sdkman/bin/sdkman-init.sh"


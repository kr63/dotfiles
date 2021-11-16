# pacaur -S antigen-git
source /usr/share/zsh/share/antigen.zsh

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
export PYCHARM_HOME="$HOME/software/pycharm/"

# ------------------------------------------------------------------------------
export _JAVA_AWT_WM_NONREPARENTING=1

# ------------------------------------------------------------------------------
# Kubernetes settings
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

# ------------------------------------------------------------------------------
# sdkman setup
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
export JAVA_HOME='$SDKMAN_DIR/candidates/java/current'
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"



# Sample setup: .oh-my-zsh/templates/zshrc.zsh-template 

export ZSH="/home/lxuser/.oh-my-zsh"
ZSH_THEME="muse"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

autoload -Uz promptinit; promptinit
PROMPT='%F{green}%n@%F{green}%m%f %F{blue}%1~%f %# '

# ------------------------------------------------------------------------------
# python virtualenvs; set virtualenv name in emacs config!
alias activate="source ~/.virtualenvs/py36/bin/activate"

# ------------------------------------------------------------------------------
# apache tomcat
export CATALINA_HOME="/home/lxuser/software/tomcat"
export PATH="${CATALINA_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# bc alias
alias bc="bc -li"
alias dir="dir -lh --color --group-directories-first"

# ------------------------------------------------------------------------------
# reload dir colors:
eval "$(dircolors ~/.dir_colors)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/lxuser/.sdkman"
[[ -s "/home/lxuser/.sdkman/bin/sdkman-init.sh" ]] && source "/home/lxuser/.sdkman/bin/sdkman-init.sh"

# Sample setup: .oh-my-zsh/templates/zshrc.zsh-template 

export ZSH="/home/lxuser/.oh-my-zsh"
ZSH_THEME="muse"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

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
# jenv setup
#THIS MUST BE AT THE END OF THE FILE FOR JENV TO WORK!!!
[[ -s "/home/lxuser/.jenv/bin/jenv-init.sh" ]] && source "/home/lxuser/.jenv/bin/jenv-init.sh" && source "/home/lxuser/.jenv/commands/completion.sh"

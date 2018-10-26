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

# ------------------------------------------------------------------------------
# JAVA_HOME setup
function setup_java_home {
    if [[ "$(readlink -f /usr/bin/java | cut -d/ -f 1-3)" == "/usr/lib" ]]; then
        # jdk installed to /usr/lib/jvm
        export JAVA_HOME=$(readlink -f /usr/bin/java | cut -d/ -f 1-5);
    else
        # jdk installed to /usr/java/
        export JAVA_HOME=$(readlink -f /usr/bin/java | cut -d/ -f 1-4);
    fi
    export PATH=$PATH:$JAVA_HOME/bin;
}

function remove_java_home_from_path {
    export PATH=$(
        awk -v var1="$PATH" -v var2="$JAVA_HOME" 'BEGIN { gsub(":"var2"/bin","",var1); print var1 }';
    )
}

setup_java_home
alias set-java='
remove_java_home_from_path
sudo alternatives --config java;
setup_java_home
'

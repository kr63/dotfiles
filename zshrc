source /home/lxuser/software/antigen.zsh 

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
# python virtualenvs; set virtualenv name in emacs config!
alias activate="source ~/.virtualenvs/default/bin/activate"

# ------------------------------------------------------------------------------
# bc alias
alias bc="bc -li"
alias dir="dir -lh --color --group-directories-first"

# ------------------------------------------------------------------------------
# reload dir colors:
eval "$(dircolors ~/.dir_colors)"

# ------------------------------------------------------------------------------
# yarn setup
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# ------------------------------------------------------------------------------
# Tomcat setup
export CATALINA_HOME="$HOME/software/tomcat"
export PATH="${CATALINA_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# Jetty setup
export JETTY_HOME="$HOME/software/jetty-distribution/"
export PATH="${JETTY_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# ActiveMQ setup
export ACTIVEMQ_HOME="$HOME/software/activemq"
export PATH="${ACTIVEMQ_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# RabbitMQ setup
export RABBITMQ_HOME="$HOME/software/rabbitmq_server"
export PATH="${RABBITMQ_HOME}/sbin/:${PATH}"

# ------------------------------------------------------------------------------
# ZooKeeper setup
export ZOOKEEPER_HOME="$HOME/software/zookeeper"
export PATH="${ZOOKEEPER_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# kafka setup
export KAFKA_HOME="$HOME/software/kafka/"
export PATH="${KAFKA_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# sdkman setup
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/lxuser/.sdkman"
[[ -s "/home/lxuser/.sdkman/bin/sdkman-init.sh" ]] && source "/home/lxuser/.sdkman/bin/sdkman-init.sh"


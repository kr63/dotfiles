# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/lxuser/.sdkman"
[[ -s "/home/lxuser/.sdkman/bin/sdkman-init.sh" ]] && source "/home/lxuser/.sdkman/bin/sdkman-init.sh"

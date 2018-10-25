alias dir="dir -lh --color --group-directories-first"

# java gui apps in xmonad
#export _JAVA_AWT_WM_NONREPARENTING=1

##apulse capture device; see arecord -l: hw:1,0 --> card 1; device 0;
#export APULSE_CAPTURE_DEVICE=plughw:1,0
#alias mongod="mongod --dbpath ~/mongo/data/db"

## ------------------------------------------------------------------------------
## ansys settings
#ANSPATH="/home/lxuser/bin/ansys_inc/v162"
#alias ansys="${ANSPATH}/ansys/bin/ansys162"
#alias anshelp="${ANSPATH}/ansys/bin/anshelp162"
#alias icemcfd="${ANSPATH}/icemcfd/linux64_amd/bin/icemcfd"
## alias runwb2="${ANSPATH}/Framework/bin/Linux64/runwb2"
#alias icemcfd="XLIB_SKIP_ARGB_VISUALS=1 ${ANSPATH}/icemcfd/linux64_amd/bin/icemcfd"

## ------------------------------------------------------------------------------
## abaqus settings
#abapath="/home/lxuser/bin/abaqus/Commands/"
#alias abaqus="${abapath}/abaqus"
#alias abaqus_cae="XLIB_SKIP_ARGB_VISUALS=1 ${abapath}/abaqus cae noStartupDialog -mesa"

## ------------------------------------------------------------------------------
## other settings
#alias matlab="/home/lxuser/bin/MATLAB/R2016b/bin/matlab"
#alias openxcom="openxcom -data .config/openxcom/"

# ------------------------------------------------------------------------------
export PATH="~/bin/:${PATH}"

# ------------------------------------------------------------------------------
# python virtualenvs; set virtualenv name in emacs config!
alias activate="source ~/.virtualenvs/py36/bin/activate"

# ------------------------------------------------------------------------------
# apache tomcat
# export CATALINA_HOME="/home/lxuser/bin/apache-tomcat-7.0.82"
export CATALINA_HOME="/home/lxuser/bin/tomcat"
export PATH="${CATALINA_HOME}/bin/:${PATH}"

# ------------------------------------------------------------------------------
# gradle
export GRADLE_HOME="/home/lxuser/bin/gradle-4.7"
export PATH="${GRADLE_HOME}/bin"

# ------------------------------------------------------------------------------
# bc alias
alias bc="bc -li"


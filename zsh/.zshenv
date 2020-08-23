#!/usr/bin/env zsh

# use terminal-color
BOLDRED=$'\033[1;31m'
BOLDGREEN=$'\033[1;32m'
BOLDYELLOW=$'\033[1;33m'
BOLDBLUE=$'\033[1;34m'
BOLDPURPLE=$'\033[1;35m'
BOLDCYAN=$'\033[1;36m'

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'

NORMAL=$'\033[0m'

# support colors in less
export LESS_TERMCAP_mb=${BOLDRED}   	# start blink
export LESS_TERMCAP_md=${BOLDBLUE}  	# start bold
export LESS_TERMCAP_me=${NORMAL}    	# turn off bold, blink and underline
export LESS_TERMCAP_so=${YELLOW}    	# start standout
export LESS_TERMCAP_se=${NORMAL}    	# stop standout
export LESS_TERMCAP_us=${GREEN}  		# start underline
export LESS_TERMCAP_ue=${NORMAL}    	# stop underline

unset BOLDRED BOLDGREEN BOLDYELLOW BOLDBLUE BOLDPURPLE BOLDCYAN RED GREEN YELLOW BLUE PURPLE CYAN NORMAL


# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH


which pyenv > /dev/null 2>&1 && eval "$(pyenv init -)"


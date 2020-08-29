#
# ~/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


#############################################################################################################
#### Tramp emacs mandatory step
#############################################################################################################
case "$TERM" in
    "dumb")
        export PS1="> "
        return
        ;;
    xterm*|rxvt*|eterm*|screen*)
        tty -s && export PS1="$ "
        ;;
esac


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Save each command to the history file as it's executed.  #517342
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
# PROMPT_COMMAND='history -a'

############################################################################################################
#### Titles
#############################################################################################################
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
esac


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
NORMAL=$'\033[00m'

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=false
if type -P dircolors >/dev/null ; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    LS_COLORS=
    if [[ -f ~/.dir_colors ]] ; then
        eval "$(dircolors -b ~/.dir_colors)"
    elif [[ -f /etc/DIR_COLORS ]] ; then
        eval "$(dircolors -b /etc/DIR_COLORS)"
    else
        eval "$(dircolors -b)"
    fi
    # Note: We always evaluate the LS_COLORS setting even when it's the
    # default.  If it isn't set, then `ls` will only colorize by default
    # based on file attributes and ignore extensions (even the compiled
    # in defaults of dircolors). #583814
    if [[ -n ${LS_COLORS:+set} ]] ; then
        use_color=true
    else
        # Delete it if it's empty as it's useless in that case.
        unset LS_COLORS
    fi
else
    # Some systems (e.g. BSD & embedded) don't typically come with
    # dircolors so we need to hardcode some terminals in here.
    case ${TERM} in
        [aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) use_color=true;;
    esac
fi

if ${use_color} ; then
    if [[ ${EUID} == 0 ]] ; then
        PS1="\[${BOLDRED}\]\h \[${BOLDBLUE}\]\w \[${BOLDRED}\]# \[${NORMAL}\]"
    else
        PS1="\[${BOLDGREEN}\]\u@\h \[${BOLDBLUE}\]\w \[${BOLDGREEN}\]$ \[${NORMAL}\]"
    fi
else
    if [[ ${EUID} == 0 ]] ; then
        # show root@ when we don't have colors
        PS1='\h \w # '
    else
        PS1='\u@\h \w $ '
    fi
fi

# support colors in less
export LESS_TERMCAP_mb=${BOLDRED}       # start blink
export LESS_TERMCAP_md=${BOLDBLUE}      # start bold
export LESS_TERMCAP_me=${NORMAL}        # turn off bold, blink and underline
export LESS_TERMCAP_so=${YELLOW}        # start standout
export LESS_TERMCAP_se=${NORMAL}        # stop standout
export LESS_TERMCAP_us=${GREEN}         # start underline
export LESS_TERMCAP_ue=${NORMAL}        # stop underline

unset BOLDRED BOLDGREEN BOLDYELLOW BOLDBLUE BOLDPURPLE BOLDCYAN RED GREEN YELLOW BLUE PURPLE CYAN NORMAL

for sh in /etc/bash/bashrc.d/* ; do
    [[ -r ${sh} ]] && source "${sh}"
done

# Try to keep environment pollution down, EPA loves us.
unset use_color sh

if [[ -f ~/.xprofile ]]; then
    . ~/.xprofile
fi



export EDITOR=${EDITOR:-"vim"}


#
# useful functions

MY_OSTYPE=$(uname -s)
function islinux () {
    [[ $MY_OSTYPE == "Linux" ]]
}

function isdarwin () {
    [[ $GRML_OSTYPE == "Darwin" ]]
}

function isfreebsd () {
    [[ $GRML_OSTYPE == "FreeBSD" ]]
}

function isopenbsd () {
    [[ $GRML_OSTYPE == "OpenBSD" ]]
}

function issolaris () {
    [[ $GRML_OSTYPE == "SunOS" ]]
}

#f1# are we running within an utf environment?
function isutfenv () {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}

#f5# cd to directory and list files
function cl () {
    cd $1 && ls -a
}

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    local dir
    if (( $# == 1 )) && [[ -f ${1} ]]; then
        dir=`dirname ${1}`
        [[ ! -e ${dir} ]] && return 1
        printf "Correcting ${1} to ${dir}\n"
        builtin cd ${dir}
    else
        builtin cd "$@"
    fi
}

#f5# Create Directory and \kbd{cd} to it
function mkcd () {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}

#f5# Create temporary directory and \kbd{cd} to it
function cdt () {
    builtin cd "$(mktemp -d)"
    builtin pwd
}


#f5# Backup \kbd{file_or_folder {\rm to} file_or_folder\_timestamp}
function bk_usage () {
    cat <<EOF0
bk [-hcmv] FILE [FILE ...]
bk -r [-av] [FILE [FILE ...]]
Backup a file or folder in place and append the timestamp
Remove backups of a file or folder, or all backups in the current directory

Usage:
-h    Display this help text
-c    Keep the file/folder as is, create a copy backup using cp(1) (default)
-m    Move the file/folder, using mv(1)
-r    Remove backups of the specified file or directory, using rm(1). If none
      is provided, remove all backups in the current directory.
-a    Remove all (even hidden) backups.
-v    Verbose

The -c, -r and -m options are mutually exclusive. If specified at the same time,
the last one is used.

The return code is the sum of all cp/mv/rm return codes."
EOF0
}

function bk () {
    local current_date=$(date -u "+%Y%m%dT%H%M%SZ")
    local clean keep move verbose result all to_bk
    local opt OPTIND
    keep=1
    verbose="-v"
    while getopts ":hacmrv" opt; do
        case $opt in
            a)
                (( all++ ))
                ;;
            c)
                unset move clean && (( ++keep ))
                ;;
            m)
                unset keep clean && (( ++move ))
                ;;
            r)
                unset move keep && (( ++clean ))
                ;;
            v)
                verbose="-v"
                ;;
            h)
                bk_usage && return 0;
                ;;
        esac
    done
    shift "$((OPTIND-1))"
    if (( keep > 0 )); then
        if islinux || isfreebsd; then
            for to_bk in "$@"; do
                cp $verbose -a "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        else
            for to_bk in "$@"; do
                cp $verbose -pR "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        fi
    elif (( move > 0 )); then
        while (( $# > 0 )); do
            mv $verbose "${1%/}" "${1%/}_$current_date"
            (( result += $? ))
            shift
        done
    elif (( clean > 0 )); then
        if (( $# > 0 )); then
            for to_bk in "$@"; do
                ls | egrep "${to_bk%/}_[0-9]{8}T([0-1][0-9]|2[0-3])([0-5][0-9]){2}Z" | xargs rm $verbose -rf
                (( result += $? ))
            done
        else
            if (( all > 0 )); then
                ls | egrep ".*_[0-9]{8}T([0-1][0-9]|2[0-3])([0-5][0-9]){2}Z" | xargs rm $verbose -rf
            else
                ls | egrep ".*_[0-9]{8}T([0-1][0-9]|2[0-3])([0-5][0-9]){2}Z" | xargs rm $verbose -rf
            fi
            (( result += $? ))
        fi
    fi
    return $result
}

# dump terinal color
terminal-color() {
	for clbg in {0..9} {40..47} {100..107} 49 ; do
		#Foreground
		for clfg in {30..37} {90..97} 39 ; do
			#Formatting
			for attr in 0 1 2 4 5 6 7 ; do
				#Print the result
				echo -en "\033[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \033[0m"
			done
			echo #Newline
		done
	done
}

MY_PATH=
# add-path path [after]
add-path () {
    [[ $# -lt 1 ]] && echo "add-path <path> [after]" && return
    if ! echo ${PATH} | grep -E -q "(^|:)$1($|:)"; then
        if [ "$2" = "after" ]; then
            PATH=${PATH}:$1
        else
            PATH=$1:${PATH}
        fi
    fi
    if [[ -z ${MY_PATH} ]]; then
        MY_PATH=$1
    else
        MY_PATH=${MY_PATH}:$1
    fi
}

src () {
    exec "${SHELL#-}"
}

umask 022

if [[ -f ~/.custom-local.sh ]]; then
    source  ~/.custom-local.sh
fi

if [[ -f ~/.alias.sh ]]; then
    source ~/.alias.sh
fi

# /etc/bash/bashrc
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



BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
NORMAL='\[\033[00m\]'
TIME=$(date +%H:%M)

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
		PS1="${BRED}\h ${BBLUE}\W ${BRED}\# ${NORMAL}"
	else
		PS1="${BGREEN}\u@\h ${BBLUE}\w ${BGREEN}\$ ${NORMAL}"
	fi
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \# '
	else
		PS1='\u@\h \w \$ '
	fi
fi



for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done

# Try to keep environment pollution down, EPA loves us.
unset use_color sh

if [[ -f ~/.xprofile ]]; then
. ~/.xprofile
fi



# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


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


# Alias
alias bashrc='vi ~/.bashrc'

# color on GNU ls(1)
if ls --color=auto / > /dev/null 2>&1; then
    ls_options+=( --color=auto )
# color on FreeBSD and OSX ls(1)
elif ls -G / > /dev/null 2>&1; then
    ls_options+=( -G )
fi

# Natural sorting order on GNU ls(1)
# OSX and IllumOS have a -v option that is not natural sorting
if ls --version |& grep -q 'GNU' > /dev/null 2>&1 && ls -v / > /dev/null 2>&1; then
    ls_options+=( -v )
fi

# color on GNU and FreeBSD grep(1)
if grep --color=auto -q "a" <<< "a" > /dev/null 2>&1; then
    grep_options+=( --color=auto )
fi

# do we have GNU ls with color-support?
if [[ "$TERM" != dumb ]]; then
    #a1# List files with colors (\kbd{ls \ldots})
    alias ls="command ls ${ls_options:+${ls_options[*]}}"
    #a1# List all files, with colors (\kbd{ls -la \ldots})
    alias la="command ls -a ${ls_options:+${ls_options[*]}}"
    #a1# List files with long colored list, without dotfiles (\kbd{ls -l \ldots})
    alias ll="command ls -l ${ls_options:+${ls_options[*]}}"
    #a1# List files with long colored list, human readable sizes (\kbd{ls -hAl \ldots})
    alias lh="command ls -hAl ${ls_options:+${ls_options[*]}}"
    alias grep="command grep ${grep_options:+${grep_options[*]}}"
    alias egrep="command egrep ${grep_options:+${grep_options[*]}}"
    #a1# List files with long colored list, append qualifier to filenames (\kbd{ls -l \ldots})\\&\quad(\kbd{/} for directories, \kbd{@} for symlinks ...)
    alias l="command ls -l ${ls_options:+${ls_options[*]}}"
else
    alias la='command ls -a'
    alias ll='command ls -l'
    alias lh='command ls -hAl'
    alias l='command ls -l'
fi

# listing stuff
#a2# Execute \kbd{ls -lSrah}
alias dir="ls -lSrah"
#a2# Only show dot-directories
alias l.d='ls -d .*/'
#a2# Only show dot-files
alias l.f='ls -d .*'
#a2# Show dot files or directories
alias l.='ls -d .*'
#a2# Only files with setgid/setuid/sticky flag
alias lss='ls -l *(s,S,t)'
#a2# Only show symlinks
alias lsl='ls -l *(@)'
#a2# Display only executables
alias lsx='ls -l *(*)'
#a2# Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/)'
#a2# Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10])"
#a2# Only show directories
alias lsd='ls -d *(/)'
#a2# Only show empty directories
alias lse='ls -d *(/^F)'
#a2# Display the ten newest files
alias lsnew="ls -rtlh *(D.om[1,10])"
#a2# Display the ten oldest files
alias lsold="ls -rtlh *(D.Om[1,10])"
#a2# Display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10])"
#a2# Display the ten newest directories and ten newest .directories
alias lsnewdir="ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
#a2# Display the ten oldest directories and ten oldest .directories
alias lsolddir="ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"

# use /var/log/syslog iff present, fallback to journalctl otherwise
if [ -e /var/log/syslog ] ; then
  #a1# Take a look at the syslog: \kbd{\$PAGER /var/log/syslog || journalctl}
  alias llog="$PAGER /var/log/syslog"     # take a look at the syslog
  #a1# Take a look at the syslog: \kbd{tail -f /var/log/syslog || journalctl}
  alias tlog="tail -f /var/log/syslog"    # follow the syslog
elif [[ -f /usr/bin/journalctl ]]; then
  alias llog="journalctl"
  alias tlog="journalctl -f"
fi


alias ..='cd ../'
alias ...='cd ../../'
alias da='du -sch'

alias tailf='tail -f'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'

alias ff='find . -type f -name'
alias fd='find . -type d -name'

alias h='history'
alias p='ps -f'
alias sortn='sort -n'
alias sortnr='sort -n -r'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias psmem='ps -e -orss=,args= | sort -b -k1,1n'
alias pscpu='ps -e -o pcpu,cpu,nice,state,cputime,args | sort -k1 -nr'


GIT_HOME=~/git
KERNEL_HOME=/usr/src/linux
alias tog='cd ${GIT_HOME}'
alias tok='cd ${KERNEL_HOME}'

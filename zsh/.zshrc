#!/usr/bin/env zsh

if [[ "$TERM" = "dumb" ]]; then
    unsetopt zle
    # PS1='$ '
    # return
fi

if [[ "$TERM" = "eterm-color" ]]; then
    chpwd() { print -P "\033AnSiTc %d" }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
if [[ "$TERM" = linux || "$TERM" = dumb || "$TERM" = screen ]]; then
    ZSH_THEME="my-clear"
else
    ZSH_THEME="my"
fi
# ZSH_THEME="agnoster"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(z colored-man-pages colorize common-aliases cp dircycle emacs extract history-substring-search python rsync timer web-search)
#plugins=(z colorize common-aliases cp dircycle emacs extract history-substring-search python rsync timer web-search zsh_reload)
plugins=(z web-search zsh-navigation-tools zsh_reload history-substring-search zsh-syntax-highlighting zsh-autosuggestions)


# bindkey -M emacs '^[p' history-substring-search-up # M-n
# bindkey -M emacs '^[n' history-substring-search-up # M-n
bindkey -M emacs '^P' history-substring-search-up    # C-p
bindkey -M emacs '^N' history-substring-search-down  # C-n


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR=${EDITOR:-"vim"}

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# useful functions
MY_OSTYPE=$(uname -s)
function islinux () {
    [[ $MY_OSTYPE == "Linux" ]]
}

function isdarwin () {
    [[ $MY_OSTYPE == "Darwin" ]]
}

function isfreebsd () {
    [[ $MY_OSTYPE == "FreeBSD" ]]
}

function isopenbsd () {
    [[ $MY_OSTYPE == "OpenBSD" ]]
}

function issolaris () {
    [[ $MY_OSTYPE == "SunOS" ]]
}

# are we running within an utf environment?
function isutfenv () {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}


# this function checks if a command exists and return either true
# or false. Tihs avoids using 'which' and whence, which will avoid
# porblems with aliases for which on certain weird system.
# Usage: check_command [-c|-g] word
#   -c  only check for external commands
#   -g  does the usual tests and also checks for global aliases
function check_command ()  {
    emulate -L zsh
    local -i comonly gatoo
    comonly=0
    gatoo=0

    if [[ $1 == '-c' ]]; then
        comonly=1
        shift 1
    elif [[ $1 == '-g' ]]; then
        gatoo=1
        shift
    fi

    if (( ${#argv} != 1 )); then
        printf 'Usage: check_command [-c|-g] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )); then
        (( ${+commands[$1]} )) && return 0
        return 1
    fi

    if     (( ${+commands[$1]}    )) \
        || (( ${+functions[$1]}   )) \
        || (( ${+aliases[$1]}     )) \
        || (( ${+reswords[(r)$1]} )) ; then
            return 0
    fi

    if (( gatoo > 0 )) && (( ${+galiases[$1]} )) ; then
        return 0
    fi

    return 1
}

# Backup \kbd{file_or_folder {\rm to} file_or_folder\_timestamp}
function bk () {
    emulate -L zsh
    local current_date=$(date -u "+%Y%m%dT%H%M%SZ")
    local clean keep move verbose result all to_bk
    setopt extended_glob
    keep=1
    verbose="-v"
    while getopts ":hacmrv" opt; do
        case $opt in
            a) (( all++ ));;
            c) unset move clean && (( ++keep ));;
            m) unset keep clean && (( ++move ));;
            r) unset move keep && (( ++clean ));;
            v) verbose="-v";;
            h) <<__EOF0__
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

The return code is the sum of all cp/mv/rm return codes.
__EOF0__
return 0;;
\?) bk -h >&2; return 1;;
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
            rm $verbose -rf "${to_bk%/}"_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
            (( result += $? ))
        done
    else
        if (( all > 0 )); then
            rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z(D)
        else
            rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
        fi
        (( result += $? ))
    fi
fi
return $result
}

# cd to directory and list files
function cl () {
    emulate -L zsh
    cd $1 && ls -a
}

# Smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# Create Directory and \kbd{cd} to it
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

# Create temporary directory and \kbd{cd} to it
function cdt () {
    builtin cd "$(mktemp -d)"
    builtin pwd
}

# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
function accessed () {
    emulate -L zsh
    print -l -- *(a-${1:-1})
}

# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
function changed () {
    emulate -L zsh
    print -l -- *(c-${1:-1})
}

# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
function modified () {
    emulate -L zsh
    print -l -- *(m-${1:-1})
}


# Grep for running process, like: 'any vim'
function any () {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        ps xauwww | grep -i "${grep_options[@]}" "[${1[1]}]${1[2,-1]}"
    fi
}

# Usage: simple-extract <file>
# Using option -d deletes the original archive file.
# Smart archive extractor
function simple-extract () {
emulate -L zsh
setopt extended_glob noclobber
local ARCHIVE DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
local RC=0
zparseopts -D -E "d=DELETE_ORIGINAL"
for ARCHIVE in "${@}"; do
    case $ARCHIVE in
        *(tar.bz2|tbz2|tbz))
            DECOMP_CMD="tar -xvjf -"
            USES_STDIN=true
            USES_STDOUT=false
            ;;
        *(tar.gz|tgz))
            DECOMP_CMD="tar -xvzf -"
            USES_STDIN=true
            USES_STDOUT=false
            ;;
        *(tar.xz|txz|tar.lzma))
            DECOMP_CMD="tar -xvJf -"
            USES_STDIN=true
            USES_STDOUT=false
            ;;
        *tar)
            DECOMP_CMD="tar -xvf -"
            USES_STDIN=true
            USES_STDOUT=false
            ;;
        *rar)
            DECOMP_CMD="unrar x"
            USES_STDIN=false
            USES_STDOUT=false
            ;;
        *lzh)
            DECOMP_CMD="lha x"
            USES_STDIN=false
            USES_STDOUT=false
            ;;
        *7z)
            DECOMP_CMD="7z x"
            USES_STDIN=false
            USES_STDOUT=false
            ;;
        *(zip|jar))
            DECOMP_CMD="unzip"
            USES_STDIN=false
            USES_STDOUT=false
            ;;
        *deb)
            DECOMP_CMD="ar -x"
            USES_STDIN=false
            USES_STDOUT=false
            ;;
        *bz2)
            DECOMP_CMD="bzip2 -d -c -"
            USES_STDIN=true
            USES_STDOUT=true
            ;;
        *(gz|Z))
            DECOMP_CMD="gzip -d -c -"
            USES_STDIN=true
            USES_STDOUT=true
            ;;
        *(xz|lzma))
            DECOMP_CMD="xz -d -c -"
            USES_STDIN=true
            USES_STDOUT=true
            ;;
        *)
            print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
            RC=$((RC+1))
            continue
            ;;
    esac

    if ! check_command ${DECOMP_CMD[(w)1]}; then
        echo "ERROR: ${DECOMP_CMD[(w)1]} not installed." >&2
        RC=$((RC+2))
        continue
    fi

    GZTARGET="${ARCHIVE:t:r}"
    if [[ -f $ARCHIVE ]] ; then

        print "Extracting '$ARCHIVE' ..."
        if $USES_STDIN; then
            if $USES_STDOUT; then
                ${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
            else
                ${=DECOMP_CMD} < "$ARCHIVE"
            fi
        else
            if $USES_STDOUT; then
                ${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
            else
                ${=DECOMP_CMD} "$ARCHIVE"
            fi
        fi
        [[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

    elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
        if check_command curl; then
            WGET_CMD="curl -L -s -o -"
        elif check_command wget; then
            WGET_CMD="wget -q -O -"
        elif check_command fetch; then
            WGET_CMD="fetch -q -o -"
        else
            print "ERROR: neither wget, curl nor fetch is installed" >&2
            RC=$((RC+4))
            continue
        fi
        print "Downloading and Extracting '$ARCHIVE' ..."
        if $USES_STDIN; then
            if $USES_STDOUT; then
                ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
                RC=$((RC+$?))
            else
                ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
                RC=$((RC+$?))
            fi
        else
            if $USES_STDOUT; then
                ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
            else
                ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
            fi
        fi

    else
        print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
        RC=$((RC+8))
    fi
done
return $RC
}

# dump terinal color
terminal-color() {
	for clbg in {0..9} {40..47} {100..107} 49 ; do
		#Foreground
		for clfg in {30..37} {90..97} 39 ; do
			#Formatting
			for attr in 0 1 2 4 5 6 7 ; do
				#Print the result
				echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
			done
			echo #Newline
		done
	done
}



umask 022

source $ZSH/oh-my-zsh.sh

[[ -f ${HOME}/.alias ]] && source ${HOME}/.alias

if check_command neofetch; then 
    neofetch
fi

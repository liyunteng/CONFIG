#
# ~/.alias.sh
#

# color on GNU ls(1)
if islinux; then
    ls_options+=( --color=auto )
    # color on FreeBSD and OSX ls(1)
elif isdarwin || isfreebsd; then
    ls_options+=( -G )
fi

# Natural sorting order on GNU ls(1)
# OSX and IllumOS have a -v option that is not natural sorting
if islinux; then
    ls_options+=( -v )
fi

# color on GNU and FreeBSD grep(1)
grep_options+=( --color=auto )
if isdarwin; then
    grep_options+=( -r )
fi

EXCLUDE_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
grep_options+=( --exclude-dir=${EXCLUDE_FOLDERS} )
unset EXCLUDE_FOLDERS

# do we have GNU ls with color-support?
if [[ "$TERM" != dumb ]]; then
    alias ls="command ls ${ls_options:+${ls_options[*]}}"
    alias grep="command grep ${grep_options:+${grep_options[*]}}"
    alias egrep="command egrep ${grep_options:+${grep_options[*]}}"
    alias fgrep="command fgrep ${grep_options:+${grep_options[*]}}"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshrc='${EDITOR} ~/.zshrc'
alias bashrc='${EDITOR} ~/.bashrc'

# listing stuff
#a2# Execute \kbd{ls -lSrah}
alias dir="ls -lSrah"

alias l='ls'
alias ll='ls -l'
alias lsa='ls -a'
alias la='ls -a'
alias lla='ls -al'
#a2# show dot files or directories
alias l.='ls -d .*'
alias ls.='ls -d .*'
alias ll.='ls -ld .*'

# WARN: bash can't work correct with like *(/)
#a2# Only show dot-directories
alias ls.d='ls -d .*(/)'
#alias ll.d='ls -d .*/'
alias ll.d='ls -ld .*(/)'
#a2# Only show dot-files
alias ls.f='ls -ad .*(.)'
alias ll.f='ls -ald .*(.)'
#a2# Only show directories
alias lsd='ls -d *(/)'
# alias lsd='ls -d */'
alias lld='ls -ld *(/)'
# alias lld='ls -ld */'
#a2# Only show empty directories
alias lse='ls -d *(/^F)'
alias lle='ls -dl *(/^F)'

#a2# Only files with setgid/setuid/sticky flag
alias lss='ls -ld *(s,S,t)'
#a2# Only show symlinks
alias lsl='ls -ld *(@)'
#a2# Display only executables
alias lsx='ls -ld *(*)'
#a2# Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/)'
#a2# Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10])"
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
if isdarwin; then
    alias llog="${PAGER} /var/log/system.log"
    alias tlog="tail -f /var/log/system.log"
elif [[ -e /var/log/syslog ]] ; then
    alias llog="$PAGER /var/log/syslog"     # take a look at the syslog
    alias tlog="tail -f /var/log/syslog"    # follow the syslog
elif [[ journalctl ]]; then
    alias llog="journalctl -e"
    alias tlog="journalctl -f"
fi

# Common Alias
alias ..='cd ..'
alias ...='cd ../../'
alias da='du -sch'

alias tailf='tail -f'
alias sgrep='grep -R -n -H -C 5'

alias ff='find . -type f -name'
alias fd='find . -type d -name'

alias h='history'
alias p='ps -f'
alias sortn='sort -n'
alias sortnr='sort -n -r'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# alias psmem='ps -e -orss=,args= | sort -b -k1,1n'
# alias pscpu='ps -e -o pcpu,cpu,nice,state,cputime,args | sort -k1'
if isdarwin; then
    alias psmem='ps a -o user,pid,ppid,rss,vsz,pmem,command | sort -b -k6,6n'
    alias pscpu='ps a -o user,pid,ppid,nice,state,wchan,cputime,pcpu,command | sort -b -k8,8n'
    alias psp='ps -ef | grep -hv grep | grep -hi'
else
    alias psmem='ps a -o user,pid,ppid,rss,vsz,pmem,command k pmem'
    alias pscpu='ps a -o user,pid,ppid,nice,state,wchan,cputime,pcpu,command k pcpu'
    alias psp='ps -ef | grep -v grep | grep -i'
fi
alias x=simple-extract

if which neofetch > /dev/null 2>&1; then
    alias s='neofetch'
fi

GIT_HOME=~/git
KERNEL_HOME=/usr/src/linux
alias tog='cd ${GIT_HOME}'
alias tok='cd ${KERNEL_HOME}'

MY_HOME=/data1/liyunteng
MY_TOOLCHAINS=${MY_HOME}/toolchains
if [[ -d ${MY_HOME} ]]; then
    alias toh='cd ${MY_HOME}'
    alias tot='cd ${MY_TOOLCHAINS}'
fi

export MY_BUILD_ENV=${MY_BUILD_ENV:-"CB0"}
CG1_SYS=${MY_HOME}/g1_sys
CG1_SYS_TOOLCHAIN=${MY_TOOLCHAINS}/arm-himix100-linux
if [[ -d ${CG1_SYS} && ${MY_BUILD_ENV} == "CG1" ]];then
    ADDX_ROOT=${CG1_SYS}
    ADDX_BUILD=${CG1_SYS}
    ADDX_MODULE=${CG1_SYS}/reference/battery_ipcam/modules
    ADDX_OUTPUT=${CG1_SYS}/reference/out/hi3518ev300_battery_ipcam_GC2053/burn
    ADDX_OTHER=${CG1_SYS}/osdrv/platform/liteos/liteos
fi

CB0_SYS=${MY_HOME}/b0_sys
CB0_SYS_TOOLCHAIN_32=${MY_TOOLCHAINS}/mips-gcc472-glibc216-32bit
CB0_SYS_TOOLCHAIN_64=${MY_TOOLCHAINS}/mips-gcc472-glibc216-64bit
if [[ -d ${CB0_SYS} && ${MY_BUILD_ENV} == "CB0" ]]; then
    ADDX_ROOT=${CB0_SYS}
    ADDX_BUILD=${CB0_SYS}/Buildscript
    ADDX_MODULE=${CB0_SYS}/Apps/addx_stream
    ADDX_OUTPUT=${CB0_SYS}/Images/output
    ADDX_OTHER=${CB0_SYS}/Apps
fi

CG121_SYS=${MY_HOME}/g121_sys
if [[ -d ${CG121_SYS} && ${MY_BUILD_ENV} == "CG121" ]]; then
    ADDX_ROOT=${CG121_SYS}
    ADDX_BUILD=${CG121_SYS}
    ADDX_MODULE=${CG121_SYS}/application/t31z/batcam/src/module
    ADDX_OUTPUT=${CG121_SYS}/out
    ADDX_OTHER=${CG121_SYS}/application/t31z/batcam/src
fi

if [[ ${ADDX_ROOT} ]]; then
    alias tor='cd ${ADDX_ROOT}'
    alias tob='cd ${ADDX_BUILD}'
    alias tov='cd ${ADDX_MODULE}'
    alias too='cd ${ADDX_OUTPUT}'
    alias tol='cd ${ADDX_OTHER}'
fi

benv() {
    echo "MY_BUILD_ENV : ${MY_BUILD_ENV}"
    echo "ROOT    (tor): ${ADDX_ROOT}"
    echo "BUILD   (tob): ${ADDX_BUILD}"
    echo "MODULE  (tov): ${ADDX_MODULE}"
    echo "OUTPUT  (too): ${ADDX_OUTPUT}"
    echo "OTHER   (tol): ${ADDX_OTHER}"
}

if [[ -d ${CG1_SYS_TOOLCHAIN} ]]; then
    add-path ${CG1_SYS_TOOLCHAIN}/bin
fi
if [[ -d ${CB0_SYS_TOOLCHAIN_32} ]];then
    add-path ${CB0_SYS_TOOLCHAIN_32}/bin
fi
if [[ -d ${CB0_SYS_TOOLCHAIN_64} ]]; then
    add-path ${CB0_SYS_TOOLCHAIN_64}/bin
fi

# Local Variables:
# mode: sh
# End:

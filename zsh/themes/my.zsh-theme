#!/usr/bin/env zsh

BLUE="%{${fg[blue]}%}"
BOLDBLUE="%{${fg_bold[blud]}%}"
RED="%{${fg[red]}%}"
BOLDRED="%{${fg_bold[red]}%}"
YELLOW="%{${fg[yellow]}%}"
CYAN="%{${fg[cyan]}%}"
BOLDCYAN="%{${fg_bold[cyan]}%}"
GREEN="%{${fg[green]}%}"
BOLDGREEN="%{${fg_bold[green]}%}"
MAGENTA="%{${fg[magenta]}%}"
BOLDMAGENTA="%{${fg_bold[magenta]}%}"
NO_COLOR="%{${reset_color}%}"

ZSH_THEME_GIT_PROMPT_PREFIX="${BLUE}(${RED}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${BLUE})${NO_COLOR} "
ZSH_THEME_GIT_PROMPT_DIRTY=" ${YELLOW}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
# must be \'\'
vcs_info='$(git_prompt_info)'

# ZSH_THEME_GIT_PROMPT_ADDED="${GREEN}✚ ${NO_COLOR}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="${BLUE}✹ ${NO_COLOR}"
# ZSH_THEME_GIT_PROMPT_DELETED="${RED}✖ ${NO_COLOR}"
# ZSH_THEME_GIT_PROMPT_RENAMED="${MAGENTA}➜ ${NO_COLOR}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="${YELLOW}═ ${NO_COLOR}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="${CYAN}✭ ${NO_COLOR}"
# vcs_info='$(git_prompt_info)$(git_prompt_status)'


ret_code="%(?::${BOLDRED}%? )${NO_COLOR}"
host="${SSH_TTY:+${MAGENTA}@${MAGENTA}%m} ${NO_COLOR}"
if [[ $EUID == 0 ]]; then
    user="${BOLDRED}%n%f%b${NO_COLOR}"
    currentdir="${BOLDRED}%~ ${NO_COLOR}"
    prompt="${BOLDRED}# ${NO_COLOR}"
else
    user="${BOLDGREEN}%n%f%b${NO_COLOR}"
    currentdir="${BOLDCYAN}%~ ${NO_COLOR}"
    prompt="${BOLDGREEN}$ ${NO_COLOR}"
fi

PROMPT="${ret_code}${user}${host}${currentdir}${vcs_info}${prompt}"

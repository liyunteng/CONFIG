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


# ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹ %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜ %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═ %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭ %{$reset_color%}"
# vcs_info='$(git_prompt_info)$(git_prompt_status)'

ZSH_THEME_GIT_PROMPT_PREFIX="${BLUE}(${RED}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${NO_COLOR} "
ZSH_THEME_GIT_PROMPT_DIRTY="${BLUE}) ${YELLOW}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="${BLUE})"

ret_code="%(?::${BOLDRED}%? )${NO_COLOR}"
host="${SSH_TTY:+${MAGENTA}@${MAGENTA}%m} ${NO_COLOR}"
# must be \'\'
vcs_info='$(git_prompt_info)'
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


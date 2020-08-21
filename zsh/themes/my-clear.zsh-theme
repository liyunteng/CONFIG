#!/usr/bin/env zsh

USE_UNICODE=1
if [[ $TERM = linux || $TERM = dumb || $TERM = screen ]]; then
    USE_UNICODE=0
fi

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
ZSH_THEME_GIT_PROMPT_SUFFIX="${BLUE}) ${NO_COLOR}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# More symbols to choose from:
# ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣ ⚢ ⚲ ⚳ ⚴ ⚥ ⚤ ⚦ ⚒ ⚑ ⚐ ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠ 
# ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬟  ⬤ 〒 ǀ ǁ ǂ ĭ Ť Ŧ

if [[ ${USE_UNICODE} == 1 ]]; then
    ZSH_THEME_GIT_PROMPT_DIRTY="${BOLDRED} ✗${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_ADDED="${GREEN}✚ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_MODIFIED="${BLUE}✹ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_DELETED="${RED}✖ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_RENAMED="${MAGENTA}➜ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_UNMERGED="${YELLOW}═ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${CYAN}✭ ${NO_COLOR}"

    VCS_IGNORE_CHAR="${YELLOW}⬇ ${NO_COLOR}"
    RETTURN_SUCCESS="" 
    RETTURN_FAILED="${BOLDRED}➜ %? ${NO_COLOR}" 
else
    ZSH_THEME_GIT_PROMPT_DIRTY="${BOLDRED} x${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_ADDED="${GREEN}+ ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_MODIFIED="${BLUE}* ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_DELETED="${RED}- ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_RENAMED="${MAGENTA}-> ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_UNMERGED="${YELLOW}= ${NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${CYAN}^ ${NO_COLOR}"

    VCS_IGNORE_CHAR="${YELLOW}& ${NO_COLOR}"
    RETTURN_SUCCESS=""
    RETTURN_FAILED="${BOLDRED}%? ${NO_COLOR}"
fi

prompt_git() {
    (($+commands[git])) || return
    if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
        return
    fi
    if [[ "$(git config --get oh-my-zsh.hide-dirty 2>/dev/null)" = 1 ]]; then
        echo -n $(git_prompt_info)${VCS_IGNORE_CHAR}
    else
        echo -n $(git_prompt_info)$(git_prompt_status)
    fi
}

prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
        echo -n "${CYAN}(`basename $VIRTUAL_ENV`) ${NO_COLOR}"
    fi
}



ret_code="%(?:${RETTURN_SUCCESS}:${RETTURN_FAILED})"
virtualenv='$(prompt_virtualenv)'
host="${SSH_CLIENT:+${MAGENTA}@%m} ${NO_COLOR}"
vcs_info='$(prompt_git)'

if [[ $EUID == 0 ]]; then
    user="${RED}%n%f%b${NO_COLOR}"
    currentdir="${BOLDRED}%/ ${NO_COLOR}"
    prompt="${BOLDRED}# ${NO_COLOR}"
else
    user="${GREEN}%n%f%b${NO_COLOR}"
    # currentdir="${BOLDCYAN}%3~ ${NO_COLOR}"
    currentdir="${BOLDCYAN}%70<..<%~ ${NO_COLOR}"
    prompt="${BOLDGREEN}$ ${NO_COLOR}"
fi

PROMPT="${ret_code}${virtualenv}${user}${host}${currentdir}${vcs_info}${prompt}"


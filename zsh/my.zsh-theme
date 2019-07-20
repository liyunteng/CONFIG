if [ "$USER" = "root" ]
then USERCOLOR="red"
else USERCOLOR="green"
fi
local ret_status='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}'
local user='%{$fg[green]%}%p%{$fg[$USERCOLOR]%}%n@%m%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'
local prompt='%{$fg_bold[blue]%}$%{$reset_color%}'

# ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}git:%{$fg[blue]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg_bold[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})"

PROMPT="${ret_status} ${user} ${pwd} ${git_branch}${prompt} "

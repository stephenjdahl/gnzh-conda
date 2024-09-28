# Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{082}%n%f'
  PR_USER_OP='%F{082}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{082}%m%f' # no SSH
fi

function venv_info {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%{$fg[grey]%}(${VIRTUAL_ENV:t})%{$reset_color%}"
  fi
}

# `conda config --set changeps1 false`
export CONDA_CHANGEPS1=false
function conda_info {
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo "%F{227}(${CONDA_DEFAULT_ENV})%{$reset_color%}"
  fi
}

local venv='$(venv_info)'
local conda='$(conda_info)'
local gnzh_env=''
if [[ -n ${venv} && -n ${conda} ]]; then
  gnzh_env="${conda} ${venv}"
elif [[ -n ${conda} ]]; then
  gnzh_env="${conda}"
elif [[ -n ${venv} ]]; then
  gnzh_env="${venv}"
else
  gnzh_env=""
fi

local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
local current_dir="%B%F{blue}%~%f%b"
local git_branch='$(git_prompt_info)'

PROMPT="╭─${gnzh_env}${user_host} ${current_dir}${git_branch}
╰─$PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{213}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"

}

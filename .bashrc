# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# history search with arrows
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# ignore duplicate history elements
export HISTIGNORE="&"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# add local python binary path to $PATH
export PATH=$PATH:$HOME/.local/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# easier completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# faster cd upwards
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

# custom virtualenv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
virtualenv_info() {
    [[ -n "$VIRTUAL_ENV" ]] && echo "using \[\033[1;31m\]${VIRTUAL_ENV##*/}\[\033[0m\] "
}

# custom git prompt
git_info() {
    local DIRTY="\[\033[1;33m\]"
    local CLEAN="\[\033[0;32m\]"
    local UNMERGED="\[\033[0;31m\]"
    git rev-parse --git-dir >& /dev/null
    if [[ $? == 0 ]]; then
        echo -n "on "
        if [[ `git ls-files -u >& /dev/null` == '' ]]; then
            git diff --quiet >& /dev/null
            if [[ $? == 1 ]]
            then
                echo -n $DIRTY
            else
                git diff --cached --quiet >& /dev/null
                if [[ $? == 1 ]]; then
                    echo -n $DIRTY
                else
                    echo -n $CLEAN
                fi
            fi
        else
            echo -n $UNMERGED
        fi
        echo -n `git branch | grep '* ' | sed 's/..//'`
        echo -n "\[\033[0m\]"
    fi
}

#PS1='[\u@\h \W]\$ '

set_bash_prompt(){
	PS1="<In \[\033[1;35m\]\w\[\033[0m\] $(virtualenv_info)\n $(git_info)> "
}

PROMPT_COMMAND=set_bash_prompt


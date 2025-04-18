# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

source scl_source enable devtoolset-8 llvm-toolset-7.0
source /usr/share/bash-completion/completions/git
# source /etc/bash_completion.d/git

shopt -s expand_aliases
# shopt -s direxpand

# User specific aliases and functions
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

set -o vi

############################ History ###########################################
# setting history length:
HISTSIZE=50000
HISTFILESIZE=90000

# Avoid duplicates:
export HISTCONTROL=ignoredups:erasedups

# Date & Time:
export HISTTIMEFORMAT="%d/%m/%y %T "

# Ignore VS Code launch injected commands:
HISTIGNORE='env sh /tmp/Microsoft-MIEngine-Cmd-*'

# When the shell exits, append to the history file instead of overwriting it:
shopt -s histappend

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS:
shopt -s checkwinsize

############################ Prompt ############################################

# Modify prompt to include git info
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
PS1='\[\033[01;33m\][\t] \[\033[01;32m\]\u | \[\033[01;36m\]($(parse_git_branch))\[\033[01;31m\] | \w\[\033[00m\]\$ '

# directories
alias ls='ls --color'
LS_COLORS='di=0;34:fi=0:ln=31:pi=0;5:so=0;5:bd=0;5:cd=5:or=0;31;45:mi=0:ex=0;33:*.rpm=37:*.sh=32:*.gz=0;31:*.zip=0;31'
export LS_COLORS

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# [[ -z "$TMUX" ]] && exec tmux

# clin
alias clion='sh /opt/clion-2023.3.2/bin/clion.sh ~/git/rdb/'
alias pycharm='sh /opt/pycharm-community-2023.3.2/bin/pycharm.sh ~/git/rdb/'

# git
alias gl="git log --pretty=format:%Cred%h%Cblue%x20%as%x20%Cgreen%an%x20%Creset%s"
alias glom="gl --author=Ori"

#goto
alias goto_rdb='cd ~/git/rdb'
alias goto_skynet='cd ~/git/skynet-client'

#skynet
alias dps='docker ps'
alias dk='docker kill'
alias dka='docker kill $(dps -q)'
alias skyl='f(){
    if [[ "$@" != "build" ]]; then
        name=" --name my_cluster";
    fi
    cd ~/git/skynet-client;
    python3 ~/git/skynet-client/skynet_client local "$@" $name;
    if [[ "$@" = "test" ]]; then
dl -f client;
fi
cd -;
unset name;
unset -f f;
}; f'
dname='f(){ dps --format "table {{.Names}}" | grep "$@"; unset -f f;}; f'
da='f(){ docker attach $(dname "$@"); unset -f f;}; f'
alias dl='f(){
    if [ "$1" = "-f" ]; then
        docker logs -f $(dname "$2");
    else
        docker logs $(dname "$1");
    fi
    unset -f f;}; f'
alias dstop='python3 skynet_client local dcl --name my_cluster'
alias dbuild='python3 skynet_client local build'
dcreate() {
    python3 skynet_client local ccl --type "$1" --name my_cluster
}

alias dsetup='python3 skynet_client local setup --name my_cluster'

dtest() {
    python3 skynet_client local test --name my_cluster --params "--test_filter $1"
}

dtestv() {
    python3 skynet_client local test --name my_cluster --params "--test_filter $1" --exec valgrind
}

dtestg() {
    python3 skynet_client local test --name my_cluster --params "--test_filter $1" --exec gdb
}

alias de2e='python3 skynet_client local test --name my_cluster --params'

#grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## get rid of command not found ##
alias cd..='cd ..'

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# clac
alias bc='bc -l'

## distrp specifc RHEL/CentOS ##
alias update='yum update'
alias updatey='yum -y update'

alias lh='ls -lisAd .[^.]*'
alias la='ls -lisA'
alias rm='rm -iv'
alias cp='cp -iv'
alias hg='history | grep $1'
alias ld='ls -d */'
alias lc='find . -type f | wc -l'
alias fh='find . -name '

# black
alias black='black -l 80'

. "$HOME/.cargo/env"

## bat
# in your .bashrc/.zshrc/*rc
alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

batdiff() {
    git diff $1 --name-only --relative --diff-filter=d | bat
}

alias ranger='. ranger'
alias trex='~/git/rdb/Debug/gcc/tools/trex/trex --discovery_file $(find ~/git/skynet-client/workspace/*/conf/modules_configuration.json)'
alias trex2='~/git/rdb2/Debug/gcc/tools/trex/trex --discovery_file $(find ~/git/skynet-client/workspace/*/conf/modules_configuration.json)'
alias rebuild='~/git/rdb/rebuild.sh gcc Debug'
alias clangrebuild='~/git/rdb/rebuild.sh clang Debug'
alias debug='ssh -i ~/.ssh/id_user user@debug-server.regatta.dev'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPS="--extended"
alias gco='git checkout $(git branch --all | grep -v HEAD | grep -v remotes/origin/HEAD | sed "s/remotes\/origin\///" | sed "s/* //g" | fzf)'
alias gmerge='git merge $(git branch --all | grep -v HEAD | grep -v remotes/origin/HEAD | sed "s/remotes\/origin\///" | sed "s/* //g" | fzf)'
source ~/git/rdb/setup_rdb_python.sh

alias gencc='f() { ./src/scripts/gen_compile_commands.sh "${1:-Debug}"; }; f'
alias nvim='~/Downloads/nvim-linux-x86_64/bin/nvim'
alias lazygit='~/Downloads/lazygit'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
alias dot='/usr/bin/git --git-dir=/home/orimintz/.dotfiles/ --work-tree=/home/orimintz'

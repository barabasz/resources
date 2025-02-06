#!/bin/zsh

export ZDOTDIR=$HOME/.config/zsh
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000
export HISTFILESIZE=1000
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}
export BINDIR=$HOME/bin
export HOMEDIR=$HOME
export GHDIR=$HOME/GitHub
export GHBINDIR=$HOME/GitHub/bin
export GHCONFDIR=$HOME/GitHub/config
export CONFDIR=$HOME/.config
export PATH=$HOME/bin:$HOME/binos:$HOME/bin/install:$HOME/bin/test:/usr/local/bin:$PATH
export EDITOR='nvim'
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
export COMPLETION_WAITING_DOTS="true"

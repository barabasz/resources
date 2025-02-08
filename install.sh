#!/bin/bash

# THIS SCRIPT IS INTENTIONALLY WRITTEN IN BASH

# Env

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
export GHBINDIR=$GHDIR/bin
export GHCONFDIR=$GHDIR/config
export CONFDIR=$XDG_CONFIG_HOME

# Locale

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en:C
export LC_MESSAGES=en_US.UTF-8
export LC_ADDRESS=pl_PL.UTF-8
export LC_COLLATE=pl_PL.UTF-8
export LC_CTYPE=pl_PL.UTF-8
export LC_IDENTIFICATION=pl_PL.UTF-8
export LC_MEASUREMENT=pl_PL.UTF-8
export LC_MONETARY=pl_PL.UTF-8
export LC_NAME=pl_PL.UTF-8
export LC_NUMERIC=pl_PL.UTF-8
export LC_PAPER=pl_PL.UTF-8
export LC_TELEPHONE=pl_PL.UTF-8
export LC_TIME=pl_PL.UTF-8
export LC_ALL=

# Functions

function aptinstall() {
    if [[ "$(isinstalled needrestart)" == "yes" ]]; then
        needrestart-quiet
    fi
    export NEEDRESTART_MODE=a 
    export DEBIAN_FRONTEND=noninteractive
    aptopt='-qq'
    grpopt='-Eiv'
    filter='^needrestart|^update|^reading|^building|^scanning|^\(|^\s*$'
    sudo apt-get install $aptopt $@ | grep $grpopt $filter
    if [[ "$(isinstalled needrestart)" == "yes" ]]; then
        needrestart-verbose
    fi
}

# Execute external script
function extscript() {
    /bin/bash -c "$(curl -fsSL $1)"
}

# Source external file
function extsource() {
    source /dev/stdin <<< "$(curl -fsSL $1)"
}

# Get SHELL name
function get_shell() {
    echo $SHELL | xargs basename
}

function command_exists() {
   type "$1" &>/dev/null
}

# Check if programm is installed
function isinstalled() {
    test=$(which $1 | grep -o "/$1")
    if [[ "$test" == "/$1" ]]; then
        echo 'yes'
    else
        echo 'no'
    fi
}

# Check if package is installed by Brew
function isinstalledbybrew() {
    brew list $1 &>/dev/null
    if [ $? -eq 0 ]; then
        echo 'yes'
    else
        echo 'no'
    fi
}

# Create dir and enter it
function mdcd() {
    mkdir -p $1 && cd $_
}

# modify /etc/needrestart/needrestart.conf
# use: needrestart-mod parameter value
function needrestart-mod() {
    filename=/etc/needrestart/needrestart.conf
    sudo sed -i "s/^#\?\s\?\$nrconf{$1}.*/\$nrconf{$1} = $2;/" $filename
}
function needrestart-quiet() {
    needrestart-mod verbosity 0
    needrestart-mod systemctl_combine 0
    needrestart-mod kernelhints 0
    needrestart-mod ucodehints 0
}
function needrestart-verbose() {
    needrestart-mod verbosity 1
    needrestart-mod systemctl_combine 1
    needrestart-mod kernelhints 1
    needrestart-mod ucodehints 1
}

# Display OS name
function osname() {
    if [[ -f /etc/os-release ]]; then
        osid=$(cat /etc/os-release | grep "^ID=")
        osname=${osid:3}
    elif [[ -d /System/iOSSupport ]]; then
        osname='macos'
    else
        osname='unknown'
    fi
    osname=$(echo $osname | awk '{print tolower($0)}' | awk '{ gsub(/ /,""); print }')
    printf $osname
}

# Print yellow header
function printhead() {
    bold='\e[1m'
    yellow='\e[33m'
    clear='\033[0m'
    output="\n${yellow}${bold}"$*"${clear}\n"
    printf "$output"
}

# Print green info
function printinfo() {
    bold='\e[1m'
    green='\e[32m'
    clear='\033[0m'
    output="\n${green}${bold}"$*"${clear}\n"
    printf "$output"
}

# Search man with fzf
function fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# Short version info, usage: versioninfo cliname appname versioncommand
# Regex: https://regex101.com/r/KhIknM/1
function verinf() {
    regexver='\b\d{1,}\.\d{1,}(\.\d{1,}){0,}\b'
    message="is installed in"
    blue='\e[0;94m'
    yellow='\e[38;5;227m'
    green='\e[1;32m'
    red='\e[38;5;196m'
    clear='\033[0m'
    if [[ -z "$1" ]]; then
        print "usage:$green verinf$clear cliname appname versioncommand"
        return 1
    elif [[ ! -z "$4" ]]; then
        print "too many parameters"
        return 1
    elif [[ -z "$2" ]]; then
        cliname=$1
        appname=$1
        vercmmd="--version"
    elif [[ -z "$3" ]]; then
        cliname=$1
        appname=$2
        vercmmd="--version"
    else
        cliname=$1
        appname=$2
        vercmmd=$3
    fi
    if command -v "$1" > /dev/null 2>&1; then
        if [ "$SHELL" = "/bin/zsh" ]; then
            app="${green}${appname}${clear}"
            ver="$yellow$($cliname $vercmmd | grep -Eo $regexver | head -1)$clear"
            pth="$blue${$(whereis -b $cliname)#*: }$clear"
        else
            app=$appname
            ver=$($cliname $vercmmd | grep -Eo $regexver | head -1)
            pth=$(whereis -b $cliname)
        fi
        print "$app $ver $message $pth"
    else
        print "${red}$1${clear} is not available"
        return 2
    fi
}

function makeconfln() {
    if [[ -L $CONFDIR/$1 ]] && [[ "$(readlink $CONFDIR/$1)" = "$GHCONFDIR/$1" ]]; then
        echo "symlink $CONFDIR/$1 → $GHCONFDIR/$1 exists"
    else
        if [[ -a $CONFDIR/$1 ]]; then
            echo "removing file or folder $CONFDIR/$1"
            rm -r $CONFDIR/$1
        fi
        ln -sfF $GHCONFDIR/$1 $CONFDIR/$1
        echo "symlink $CONFDIR/$1 → $GHCONFDIR/$1 created"
    fi
}

echo "Install environment and functions successfully loaded."



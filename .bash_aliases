# PK general customisation of Bash

# base-files version 3.7-1

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file
# PATH=/usr/bin:$PATH
# export PATH

# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
# shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell


# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit"

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

export EDITOR="gvim"
export INPUTRC="~/.inputrc"
export LESS="--no-init --ignore-case --quit-if-one-screen --force --quit-on-intr"

# PK: use own DIRCOLORs
# eval "`dircolors -b ~/DIR_COLORS`"

# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

#PK ---------------------

#alias ls='ls -G'
alias g='grep -i -E'
alias t='less -i'
alias l='less -i'
alias m='less -i'
alias d='ls -a'
alias dl='ls -lrt -a'
alias ll='ls -alF'
alias la='ls -A'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
#alias dl='ls -l'
#alias ps='ps -Au | l'

alias psa='ps -aef | l'
alias psg='ps -aef |g'

alias h='history'

alias pu='pushd'
alias po='popd'

alias e='gvim'

# edit and re-read this file
alias be='$EDITOR ~/.bashrc ; source ~/.bashrc'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


set -o vi

# export PS1='\u@\h \w> '
# export PS1='\w> '
# --------------------------


# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

# Change folder and list it at the same time.
function cdl { cd $1; ls;}

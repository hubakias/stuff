# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

git_branch()
{
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\] /'
}

if [[ "$color_prompt" = yes && $EUID = "0" ]]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h \[\033[01;34m\]\w \[\033[01;33m\]$(git_branch)\[\033[01;34m\]\$ \[\033[00m\]'
else
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h \[\033[01;34m\]\w \[\033[01;33m\]$(git_branch)\[\033[01;34m\]\$ \[\033[00m\]'
fi

if [[ $(grep docker /proc/1/cgroup) ]] ; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h \[\033[01;34m\]\w \[\033[01;33m\]$(git_branch)\[\033[01;34m\]\$ \[\033[00m\]'
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# History stuff
HISTCONTROL=ignorespace
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# See who is logged in
if [[ $EUID != "0"  ]]; then
echo $(w | tail -n +3 | awk '{print $1}' | sort | uniq -c)
fi

#Extract almost any archive
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        p7zip -d $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Check if ssh-agent is running.
# If so, make sure the respective vars are set.
if [ "$(pgrep ssh-agent)" ]; then
    if [ ! $SSH_AGENT_PID ] || [ ! $SSH_AUTH_SOCK ]; then
        eval $(ssh-agent)
    fi
fi


# PS1 - Default interation prompt
# PS2 - Continuation interactive prompt ( what will appear on a multiline
#   command - default is ">")
# PS3 - Prompt used by “select” inside shell script
# PS4 – Used by “set -x” to prefix tracing output

# PROMPT_COMMAND will prepend the output of the command (at first run) to PS1
# export PROMPT_COMMAND="echo -n [$(date +%k:%m:%S)]"



#export http_proxy=http://127.0.0.1:3128/
#export https_proxy=$http_proxy
#export ftp_proxy=$http_proxy
#export rsync_proxy=$http_proxy

#export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

#echo "Week number: $(date +%V)"

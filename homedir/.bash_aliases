alias df='df -h'
alias du='du -h'
alias egrep='egrep -i --color=auto'
alias fdupes='fdupes -r -S -H'
alias fgrep='fgrep -i --color=auto'
alias grep='grep -i --color=auto --directories=skip'
alias l='ls -CF'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias locate='locate -i'
alias ls='ls -h --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias dmesg='dmesg -T'
alias bwm-ng='bwm-ng -d'
alias free="free -h"

# Git specific
#alias git-data="git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads"

# Oracle specific - with rlwrap - needs ORACLE_HOME to be set
#alias sqlplus="/usr/bin/rlwrap $ORACLE_HOME/bin/sqlplus"
#alias lsnrctl="/usr/bin/rlwrap $ORACLE_HOME/bin/lsnrctl"

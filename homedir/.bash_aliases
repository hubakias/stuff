alias df='df -h'
alias du='du -h'
alias egrep='egrep -i --color=auto'
alias fgrep='fgrep -i --color=auto'
alias grep='grep -i --color=auto --directories=skip'
alias l='ls -CF'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias locate='locate -i'
alias ls='ls -h --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias free='free -h'
alias tailf='tail -f'
alias vi='vim'

# Kernel specific
alias dmesg='dmesg -T'

# Package specific
alias bwm-ng='bwm-ng -d'
alias fdupes='fdupes -r -S -H'
alias whois='whois -Bd'

# Git specific
#alias git-data="git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads"

# Oracle specific - with rlwrap - needs ORACLE_HOME to be set
#alias sqlplus="/usr/bin/rlwrap $ORACLE_HOME/bin/sqlplus"
#alias lsnrctl="/usr/bin/rlwrap $ORACLE_HOME/bin/lsnrctl"

# alias memory_free="sync; echo 3>/proc/sys/vm/drop_caches && for i in $(tail /proc/swaps -n +2 | awk '$4 != "0" {print $1}') ; do swapoff $i && swapon $i ; done"

# Report the processes that use swap (Process name, id and size in swap)
swap_usage() {
  \egrep -h "^Name:|^Pid:|^VmSwap:" $(\grep VmSwap: /proc/[1-9]*/status | tr ':' ' ' | awk '{print ($3 != 0) ? $1 : "/dev/null"}') | awk '{print $1"\t"$2" "$3}'
}

# Occupy a portion of the memory. CAUTION
memory_fill() {
  \dd if=/dev/zero of=/dev/shm/fill bs=1k count=1024k
#  \dd if=/dev/zero of=/dev/shm/fill bs=1M count="$1"
}

# Get the branch that the current branch spawned from.
# Basic heuristics - limit to branches develop and any starting with "release/".
git_parent_branch() {
  git log --oneline | cut -f 1 -d' ' | (while read commit ; do \
other_branches="$(git branch --contains $commit | egrep -v '^\* ')"; \
if [ -n "${other_branches}" ] ; then echo -e "${commit} is \
in:\n${other_branches}"; break; fi; done | egrep "^  release/|^  develop$" \
| awk '{print $1}')
}


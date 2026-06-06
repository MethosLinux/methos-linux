# ~/.bashrc - Methos Linux User Configuration
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -R'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || true'
alias ip='ip -c'
alias du='du -h'
alias df='df -h'
alias free='free -h'
alias cat='bat --paging=never 2>/dev/null || cat'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Methos specific
alias methos-update='sudo pacman -Syu && pacman -Qe > ~/.methos-packages.txt'
alias methos-list='cat ~/.methos-packages.txt 2>/dev/null || echo "No package list found"'

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Prompt with colors and git info
PS1='\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]$(__git_ps1 " (%s)" 2>/dev/null)\$ '

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
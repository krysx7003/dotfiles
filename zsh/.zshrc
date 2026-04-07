# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
autoload -U colors && colors
PROMPT="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "
bindkey -v
bindkey -s '^[[2;2~' 'wl-paste'
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/napnap/.zshrc'

export PATH="$HOME/.local/scripts:$PATH"

autoload -Uz compinit
compinit
# End of lines added by compinstall

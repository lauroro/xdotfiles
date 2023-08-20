# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lauro/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Prompt
PROMPT='%B%F{blue}%n %~%b%f 
 > '


# Alias
alias sx="startx"
alias ls="ls --color"

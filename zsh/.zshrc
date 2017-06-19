#zmodload zsh/zprof

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd nomatch
unsetopt nomatch
bindkey -v

#zstyle :compinstall filename "$HOME/.zshrc"

source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES

  zsh-users/zsh-syntax-highlighting
  zpm-zsh/autoenv
  bobthecow/git-flow-completion
  #command-not-found
  extract
  vagrant
  tmux
  git
  colored-man-pages
  lukechilds/zsh-nvm

EOBUNDLES

antigen theme kphoen
antigen apply

for file in $ZDOTDIR/{aliases,functions}/*; do
    source "$file"
done

#source /usr/local/bin/virtualenvwrapper.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

group_lazy_load $HOME/.rvm/scripts/rvm rvm irb rake rails
unset -f group_lazy_load

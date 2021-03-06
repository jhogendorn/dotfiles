
alias g='git'

alias glf='git log'
alias gl1='git log --oneline'
alias gl='git log --oneline --decorate'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

alias gp='git push'
alias gpu='git pull'
alias gpur='git pull --rebase'

alias gd='git diff'

alias ga='git add'
alias gap='git add -p'

alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcm='git commit -m'

alias gco='git checkout'

alias gb='git branch'
alias gbc='git checkout -b'
alias gba='git branch -a'
alias gbr='git branch -r'

alias gra='git remote add'
alias grr='git remote rm'
alias grl='git remote -v'

alias gs='git status -sb'
alias gss='git status'
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"

alias gcl='git clone'

alias gr='git rebase'
# alias grp='git checkout -p' # I forget what this does?

alias gcdr='cd ./$(git rev-parse --show-cdup)'


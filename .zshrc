export CLICOLOR=1
export TERM=xterm-256color
autoload -U colors && colors

function update_time {
  PS1="%{$fg[cyan]%}%D{%H:%M}%{$reset_color%} %{$fg[red]%}%~ %{$reset_color%}%% "
}

update_time

precmd() {
  update_time
}

alias ga="git add"
alias gco="git commit"
alias gcom="git commit -m"
alias gcoa="git commit --amend"
alias gcoan="git commit --amend --no-edit"
alias gch="git checkout"
alias gchb="git checkout -b"
alias gre="git rebase"
alias grt="git reset"
alias grth="git reset --hard"
alias gpl="git pull"
alias gph="git push"
alias gphf="git push --force"
alias gb="gbn"
alias gs="git status"
alias ls="exa"
alias vim="nvim"

gbn() {
  i=1
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
    if [ "$branch" = "$current_branch" ]; then
      echo "$(tput setaf 2)$i $branch$(tput sgr0)"
    else
      echo "$i $branch"
    fi
    ((i++))
  done
}

gchn() {
  branch_number=$1
  i=1
  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
    if [ "$i" = "$branch_number" ]; then
      git checkout "$branch"
      return
    fi
    ((i++))
  done
  echo "Branch with number $branch_number not found."
}

gbd() {
  local branch_names=()
  for number in "$@"; do
    local branch_name=$(gbn | grep -E "^$number " | sed -E "s/^$number //")
    if [ -n "$branch_name" ]; then
      branch_names+=("$branch_name")
    fi
  done

  eval "git branch -D ${branch_names[*]}"
}


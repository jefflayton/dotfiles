if status is-interactive
and not set -q TMUX
    tmux
end

fish_user_key_bindings

alias gs="git status"
alias gp="git push"
alias gfo="git fetch origin"
alias gpo="git pull origin"
alias gcb="git checkout -b"
alias gco="git checkout origin"
alias gaa="git add ."
alias gcam="git commit -a -m"
alias nvim2="~/Downloads/nvim-macos-arm64/bin/nvim"

zoxide init fish | source

# Initialize Node
# nvm use

# pnpm
set -gx PNPM_HOME "/Users/jeffreylayton/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

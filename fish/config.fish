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

zoxide init fish | source

# Initialize Node
nvm use

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Initialize Oh My Posh
oh-my-posh init fish --config "$HOME/.config/ohmyposh/config.json" | source

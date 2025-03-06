if status is-interactive
    # Commands to run in interactive sessions can go here
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
# nvm use

# LOG_FILE="/tmp/log/zsh_startup.log"
# echo "$(date '+%Y-%m-%d %H:%M:%S') - ~/.bash_profile start executed" >> "$LOG_FILE"

echo "Running ~/.bash_profile"

source ~/.common_environment

setxkbmap -option caps:escape
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
. "$HOME/.cargo/env"


# echo "$(date '+%Y-%m-%d %H:%M:%S') - ~/.bash_profile end executed" >> "$LOG_FILE"

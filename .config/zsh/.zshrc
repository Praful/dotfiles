# Examples of .zshrc settings
# - https://matt.blissett.me.uk/linux/zsh/zshrc
# - https://leahneukirchen.org/dotfiles/.zshrc
# - https://askubuntu.com/questions/1577/moving-from-bash-to-zsh
# - https://grml.org/zsh/
# - https://grml.org/zsh/zsh-lovers.html
# - https://github.com/mattmc3/ez-compinit/blob/main/functions/compstyle_zshzoo_setup

# ────────────────────────────────
# Zsh History Expansion summary
# ────────────────────────────────
#
# # 🔹 Repeat previous commands
# !!          # previous command
# !-2         # command before last
# !n          # command number n (from history)
# !?str?      # last command containing "str"
#
# # 🔹 Arguments from previous command
# !$          # last argument
# !^          # first argument
# !*          # all arguments
# !:n         # nth argument (e.g. !:2 is 2nd arg)
# !:n-m       # args n through m
# !:n-$       # args n through last
#
# # 🔹 Quick substitutions
# ^foo^bar    # replace first "foo" with "bar" in last cmd
# !!:s/foo/bar/   # replace "foo" with "bar" everywhere
# !!:gs/foo/bar/  # replace all "foo" with "bar"
#
# # 🔹 Path modifiers
# !!:h        # remove last path component (head)
# !!:t        # keep only filename (tail)
# !!:r        # remove file extension (root)
# !!:e        # keep only file extension
# !!:q        # quote the result for shell safety
#
# # 🔹 Examples
# echo foo bar baz
# !^          # foo
# !$          # baz
# !*          # foo bar baz
# !:1-2       # foo bar
#
# ────────────────────────────────

# echo "Running ~/.config/zsh/.zshrc"
# LOG_FILE="/tmp/log/zsh_startup.log"
# echo "$(date '+%Y-%m-%d %H:%M:%S') - ~/config/zsh/.zshrc start executed" >> "$LOG_FILE"
#

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# enable and load completions
# -C uses cache. To rebuild:
#     rm ~/.zcompdump*
#     compinit
autoload -Uz compinit && compinit -C

# zsh specific aliases ============================================
#
# md -- mkdir and cd at once
md() { mkdir -p "$1" && cd "$1"}
compdef md=mkdir

# Allows C-Z to suspend current command.
# Pressing C-Z again will resume it (as will fg).
fancy-ctrl-z () {
  emulate -LR zsh
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# zsh specific aliases ============================================

# autoload =========================================================
# allows commands like: print *(e:age today now:), which prints modified today
autoload -U age
# see zsh-lovers for examples of using zmv
autoload zmv

# https://postgresqlstan.github.io/cli/zsh-run-help/
#run-help
autoload -Uz run-help
# add other help
autoload run−help−git
autoload run−help−ip
autoload run−help−openssl
autoload run−help−p4
autoload run−help−sudo

# press alt-h vim insert mode to get help for command
# does not work
# bindkey '\M-H' run-help
# bindkey -v '^b' run-help
# =================================================================

# uncomment next two lines to print last error code 
# print_last_status() print -u2 Exit status: $?
# precmd_functions+=(print_last_status)

# init vi plugin straight away (not lazily) to avoid it clashing with other plugins
ZVM_INIT_MODE=sourcing

# ZVM_TERM=xterm-256color

function zvm_config() {

  # change default in vi plugin for new line (otherwise last setting is used)
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

  # Retrieve default cursor styles
  # local ncur=$(zvm_cursor_style $ZVM_NORMAL_MODE_CURSOR)
  # local icur=$(zvm_cursor_style $ZVM_INSERT_MODE_CURSOR)

  # Append your custom color for your cursor
  # ZVM_INSERT_MODE_CURSOR=$icur'\e\e]12;red\a'
  # ZVM_INSERT_MODE_CURSOR=$icur'\e\e]12;#108800\a'
  # ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;#008800\a'
}

if [ -f $XDG_CONFIG_HOME/.dircolors ]; then
  eval "$(dircolors -b $XDG_CONFIG_HOME/.dircolors)"
fi

source ~/.fzf/shell/fzf-git.sh

# run here instaed of common_environment because compdef (the zsh completion system)
# needs to be available for this to work
if [ -f $HOME/data/dev/open-source/qsv/qsv.zsh ]; then
  source $HOME/data/dev/open-source/qsv/qsv.zsh
fi

if command -v xan >/dev/null 2>&1; then
    __xan() {
        xan compgen "$1" "$2" "$3"
    }
    # load bash compatibility
    autoload -Uz bashcompinit && bashcompinit

    complete -F __xan -o default xan
fi

# For help, see https://linuxhint.com/ls_colors_bash/
# called by zsh-vi-mode plugin
function zvm_after_init() {
  # [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source ~/data/dev/projects/themes/fzf/themes/catppuccin-fzf-macchiato.sh

  # for fzf-git
  # see https://github.com/chevcast/fzf-git.sh/blob/afe431ea5f5d27c929c758cf8b1b09df5d27203a/README.md
  for o in files branches tags remotes hashes stashes lreflogs each_ref; do
    eval "zvm_bindkey viins '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey viins '^g${o[1]}' fzf-git-$o-widget"
  done


}

# Set key bindings for zsh-vi-mode normal and visual modes.
function zvm_after_lazy_keybindings() {

  # for fzf-git
  for o in files branches tags remotes hashes stashes lreflogs each_ref; do
    eval "zvm_bindkey vicmd '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey vicmd '^g${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey visual '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey visual '^g${o[1]}' fzf-git-$o-widget"
  done
}

source ~/.common_aliases

# meaning of setopt options
# https://zsh.sourceforge.io/Doc/Release/Options.html#Description-of-Options
#
# Zsh settings for history
setopt inc_append_history # add commands immediately to history
setopt hist_ignore_all_dups # don't add dupes to history
setopt hist_reduce_blanks # don't put blanks in history
setopt hist_verify # don't execute immediately
setopt hist_ignore_space #don't include commands starting with space in history file
setopt hist_no_store # don't store history commands
setopt nobeep

# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing allows recursive globbing using ** instead of **/*
# eg ls -l **(.Lm+500) recursively lists files over 500mb
# eg ls -lhS **(.OL[1,10]) recursively lists largest 10 files 
# For examples of globbing, see
# https://web.archive.org/web/20230519161827/http://www.zzapper.co.uk/101ZshGlobs.php
setopt globstarshort

# change to correct, which corrects misspelled commands instead of all words on line
# setopt correct_all
# remove since it's annoying!
# setopt correct

# one history for all open shells
setopt sharehistory
# add more info eg timestamp and elapsed time since command
setopt extendedhistory

# Ref: https://linux.die.net/man/1/zshoptions
# nullglob: don't quit if no matches eg in ls **/*.{txt,py,abc}, nothing is listed if 
# there are, eg, no *.abc files. nullglob will continue, listing the *.txt and *.py files.
setopt extendedglob nomatch notify globcomplete nomenucomplete nocaseglob nullglob

# directory stack: see https://zsh.sourceforge.io/Intro/intro_6.html#SEC6
# these make cd behave live pushd/popd; 
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups 

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# I have alias d set to use exa. Typing d <TAB> doesn't list directories; this fixes it.
setopt COMPLETE_ALIASES

# Don't complete with first option: show menu instead to allow to tab through 
# options.
# zstyle ':autocomplete:*' widget-style menu-complete
# zstyle ':autocomplete:*' widget-style menu-select


# Fuzzy matching from:
# https://superuser.com/questions/415650/does-a-fuzzy-matching-mode-exist-for-the-zsh-shell#:~:text=This%20is%20a%20mode%20where,TextMate
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
# eg if there's a file "my long file name with spaces.txt", you can type mlfn<tab> to 
# select it; also works for directories.
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# sourcing .zshrc several times results in it getting longer and longer to run; 
# There is an issue with re-initializing (one or more) plugins in antidote; As a
# work around, initialize once.
# $ZSH_EVAL_CONTEXT lets us check if .zshrc is being sourced from an existing
# shell or executed in a new shell.
# echo $ZSH_EVAL_CONTEXT
if [[ $ZSH_EVAL_CONTEXT == 'file' ]]; then

  # 1 Aug 2025: these not required since fzf --zsh? 
  # source ~/.fzf/shell/completion.zsh
  # source ~/.fzf/shell/key-bindings-custom.zsh

  # echo "New shell detected; running antidote load"
  
  # Clone antidote if necessary.
  [[ -e $ZDOTDIR/.antidote ]] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git $ZDOTDIR/.antidote

  source ${ZDOTDIR:-~}/.antidote/antidote.zsh
  antidote load
  
  # --------------------------
  # fzf-tab from https://github.com/Aloxaf/fzf-tab
  #
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  # repeat FZF_DEFAULT_OPTS here since they're not picked up
    # --color=fg:#FFFFFF,bg:#1D1F21,fg+:#FFFFFF,bg+:#3E4451 \
  zstyle ':fzf-tab:complete:*' fzf-flags \
    --ansi \
    --bind 'ctrl-/:change-preview-window(down|hidden|)' \
    --bind 'alt-p:page-up' \
    --bind 'alt-n:page-down' \
    --bind 'alt-k:preview-page-up' \
    --bind 'alt-j:preview-page-down' \
    --header 'Press ctrl-/ to cycle preview modes'

  # preview directory's content using eza or show file using bat
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'if [ -d "$realpath" ]; then eza -lh --color=always "$realpath"; else bat --style=numbers --color=always --line-range :300 "$realpath"; fi'

  zstyle ':fzf-tab:*' switch-group '<' '>'
  # typing / <tab> keeps completing path; useful for cd into deep paths
  zstyle ':fzf-tab:*' continuous-trigger '/'
  zstyle ':completion:*' use-fzf-tab yes

  # <space> accepts item from completion list 
  zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
  # <enter> accepts answer and presses <enter> for line
  zstyle ':fzf-tab:*' accept-line enter

  # a cache is useful for slow commands eg apt
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path ~/.cache/zsh/completion-cache

  ## Group matches and show a horizontal line between groups
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' format ' %F{blue}-- %d --%f'

  zstyle ':completion:*:options' description 'yes'
  zstyle ':completion:*:options' auto-description '%d'
  zstyle ':completion:*:corrections' format ' %F{red}-- %d (errors: %e) --%f'
  zstyle ':completion:*:descriptions' format ' %F{purple}-- %d --%f'
  zstyle ':completion:*:messages' format ' %F{green} -- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{yellow}-- no matches found --%f'
  zstyle ':completion:*' verbose yes

  # Sorting behavior
  zstyle ':completion:*' sort true

  # Show files only for certain commands
  _show_files_only() {
    # show all files including hidden
    _path_files -g '*(.) .*(.)'
  }
  compdef _show_files_only nano nvim gvim vim e

  # Directories
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
  zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
  zstyle ':completion:*' squeeze-slashes true
  zstyle ':completion:*' special-dirs ..

  # Kill
  zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
  zstyle ':completion:*:*:kill:*' menu yes select
  zstyle ':completion:*:*:kill:*' force-list always
  zstyle ':completion:*:*:kill:*' insert-ids single



  # --------------------------
  # zsh-autosuggestions plugins
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  #
  # for zsh-autosuggestions
  bindkey '^o' forward-char
  bindkey '^w' forward-word

  bindkey '^X0' run-help
  # --------------------------
  
  fast-theme -q forest

  # this needs to be after calling fzf completion and key-bindings scripts above
  enable-fzf-tab
else
  echo "Skipping antidote load"
fi

if [ -x "$(command -v oh-my-posh)" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/pk-posh-theme.omp.json)"
else
  echo "oh-my-posh not installed"
fi

# https://github.com/ajeetdsouza/zoxide
if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init zsh)"
fi

# set prompt for kitty tab title
precmd () {print -Pn "\e]0;%~\a"}

# Copy current line to clipboard 
copy-line-to-clipboard() {
  if command -v wl-copy >/dev/null 2>&1 && [ -n "$WAYLAND_DISPLAY" ]; then
    print -rn -- "$BUFFER" | wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    print -rn -- "$BUFFER" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    print -rn -- "$BUFFER" | xsel --clipboard --input
  else
    print "No clipboard tool (wl-copy, xclip, or xsel) found!" >&2
    return 1
  fi
}
zle -N copy-line-to-clipboard

# [ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh
#
# in case not done at OS level
#
#!/bin/bash

if [ -z "$WAYLAND_DISPLAY" ]; then
    if [ -n "$DISPLAY" ]; then
        # echo "Running on X11"
        setxkbmap -option caps:escape
    else
        # echo "Display server not detected"
    fi
else
    # echo "Running on Wayland"
fi

# create firenvim directory if it doesn't exist
if [ ! -d "/tmp/firenvim" ]; then
  # If it doesn't exist, create it
  mkdir -p "/tmp/firenvim"
  echo "/tmp/firenvim directory created."
fi
# echo "$(date '+%Y-%m-%d %H:%M:%S') - ~/config/zsh/.zshrc end executed" >> "$LOG_FILE"

# is uv installed
if command -v uv >/dev/null 2>&1; then
  eval "$(uvx --generate-shell-completion zsh)"
  eval "$(uv generate-shell-completion zsh)"
fi

#initialise atuin
#
. "$HOME/.atuin/bin/env"

# eval "$(atuin init zsh)"
export ATUIN_NOBIND="true"
eval "$(atuin init zsh --disable-up-arrow)"

# remove fzf ctrl-r binding
bindkey -r '^R'
bindkey '^r' atuin-search
bindkey -M viins '^R' atuin-search
bindkey -M vicmd '^R' atuin-search

# Bind `yy` in vi-command (normal) mode to copy the current line
bindkey -M vicmd 'yy' copy-line-to-clipboard





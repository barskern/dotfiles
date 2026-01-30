#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Initialize keychain for current shell
eval `keychain --agents gpg,ssh --eval`

# Source the wanted environment setup if present
cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
[[ -r "$cfg_dir/aliases" ]] && source "$cfg_dir/aliases"
[[ -r "$cfg_dir/functions" ]] && source "$cfg_dir/functions"
[[ -r "$cfg_dir/shortcuts" ]] && source "$cfg_dir/shortcuts"
[[ -r "$HOME/.local/share/cargo/env" ]] && source "$HOME/.local/share/cargo/env"

# Simple colored prompt
PS1="\[\e[0;32m\]\u\[\e[m\]@\[\e[0;31m\]\h \[\e[1;34m\]\W\[\e[m\]\$ "

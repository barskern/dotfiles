#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Initialize keychain for current shell
eval `keychain --agents gpg,ssh --eval`

# Source aliases if present
if [[ -f "$XDG_CONFIG_HOME/aliases" ]]; then
    . "$XDG_CONFIG_HOME/aliases";
else
    [[ -f "$HOME/.config/aliases" ]] && . "$HOME/.config/aliases";
fi

# Source functions if present
if [[ -f "$XDG_CONFIG_HOME/functions" ]]; then
    . "$XDG_CONFIG_HOME/functions";
else
    [[ -f "$HOME/.config/functions" ]] && . "$HOME/.config/functions";
fi

PS1="\[\e[0;32m\]\u\[\e[m\]@\[\e[0;31m\]\h \[\e[1;34m\]\W\[\e[m\]\$ "

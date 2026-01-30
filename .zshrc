#
# ~/.zshrc
#

# Ensure zprofile is sourced
[[ -r "/etc/zsh/zprofile" ]] && source /etc/zsh/zprofile

# Jump to tmux if present {{{

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    tmux has-session -t ${USER} 2>/dev/null \
        && exec tmux attach-session -t ${USER} >/dev/null 2>&1
fi

# }}}

# Antigen settings {{{

source "$HOME/.config/antigen.zsh"

antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle aliases
antigen bundle ansible
antigen bundle colored-man-pages
antigen bundle docker
antigen bundle docker-compose
antigen bundle dotenv
antigen bundle fancy-ctrl-z
antigen bundle fzf
antigen bundle git-extras
antigen bundle poetry-env
antigen bundle pip
antigen bundle pyenv
antigen bundle rust
antigen bundle stack
antigen bundle sudo
antigen bundle taskwarrior
antigen bundle terraform
antigen bundle virtualenvwrapper

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# }}}

# General settings {{{

cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
[[ -r "$cfg_dir/environment.d/env.conf" ]] && source "$cfg_dir/environment.d/env.conf"

# Initialize keychain for current shell
eval `keychain --quiet --eval`

[[ -r "$cfg_dir/aliases" ]] && source "$cfg_dir/aliases"
[[ -r "$cfg_dir/functions" ]] && source "$cfg_dir/functions"
[[ -r "$cfg_dir/shortcuts" ]] && source "$cfg_dir/shortcuts"

# }}}

# Custom completions {{{

# OpenShift and kubectl completion
command -v oc >/dev/null && source <(oc completion zsh)
command -v kubectl >/dev/null && source <(kubectl completion zsh)
command -v helm >/dev/null && source <(helm completion zsh)

# }}}

eval "$(starship init zsh)"

#
# ~/.zshrc
#

# Ensure zprofile is sourced
source /etc/zsh/zprofile

# setup pyenv environment
eval "$(pyenv init -)"

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

# Initialize keychain for current shell
eval `keychain --quiet --agents gpg,ssh --eval`

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

# }}}

# added by travis gem
[ -f /home/oruud/.travis/travis.sh ] && source /home/oruud/.travis/travis.sh

# Source generated folder shortcuts
source /home/oruud/.config/shortcuts

eval "$(starship init zsh)"

source /home/oruud/.config/broot/launcher/bash/br

#.bashrc
# =======

# simple cursor ps1
# -----------------
PS1=
if [[ $SSH_CONNECTION ]] ; then
  PS1+='\u@\h'
fi
PS1+='\033[1;95m\]\w\033[1;34m\]$(git_branch) \033[1;95m\]>> \033[0m\]'

# global + local definitions
# --------------------------
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

# env variables
# -------------
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "$HOME/Applications"
add_to_path "$HOME/.local/share/JetBrains/Toolbox/scripts"

# concatenated sources
# --------------------
. "$HOME/.cargo/env"

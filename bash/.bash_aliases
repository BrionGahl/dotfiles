# aliases
# -------

alias godot='$HOME/Applications/Godot_v4.6.3-stable_mono_linux_x86_64/Godot_v4.6.3-stable_mono_linux.x86_64'
alias update-all='sudo dnf upgrade --refresh -y && flatpak update -y'
alias top='htop'
alias restart-kde='pkill -9 plasmashell'

# pull latest and put work on top
alias git-stash-rebase='git stash push && git fetch && git rebase origin master && git stash apply'

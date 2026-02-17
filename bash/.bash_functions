#!/bin/sh

# .bash_functions
# ================

# some helper functions sourced in .bashrc

# add some new path to my existing path
function add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# get current git branch of current directory
function git_branch() {
  # Use 2>/dev/null to hide errors if not in a git repo
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  if [ -n "$branch" ]; then
    echo " git:($branch)"
  fi
}

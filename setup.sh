#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/elcattivo66/dotfiles"

function get_os_type() {
  uname
}

declare ostype="$(get_os_type)"
if [ "${ostype}" == "Darwin" ]; then
  # Install XCode Command Line Tools if necessary
  declare git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"
  if [ ! -e "${git_cmd_path}" ]; then
    xcode-select --install
  else
    echo "Command line developer tools are already installed."
  fi

  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if which -s brew; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Install chezmoi if necessary
  if which -s chezmoi; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi

  # Apply dotfiles
  echo "Applying Chezmoi configuration."
  chezmoi init elcattivo66/dotfiles
  chezmoi apply
fi

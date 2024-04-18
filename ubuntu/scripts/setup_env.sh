#!/bin/bash

# Setup script for my ubuntu dev environment
# This is purely for personal use and probably not applicable to anyone else
# Use at your own risk
# https://github.com/jjjccw

echo "Starting developer environment setup..."

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install basic GNU command line tools
echo "Installing basic GNU command line tools (gzip, wget, curl, tree, git)..."
sudo apt-get install --reinstall coreutils
sudo apt-get install -y gzip wget curl tree git

# Install ZSH if it's not already installed
if ! command -v zsh &> /dev/null
then
    echo "ZSH is not installed. Installing ZSH..."
    sudo apt-get update && sudo apt-get install zsh -y
else
    echo "ZSH is already installed."
fi

# Install Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh-My-Zsh is already installed."
fi

# Set ZSH as the default shell
echo "Setting ZSH as the default shell..."
chsh -s $(which zsh)

# Set the theme to 'simple'
echo "Setting the theme to 'simple'..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="simple"/g' ~/.zshrc

# Reload ZSH configuration
echo "Reloading ZSH configuration..."
source ~/.zshrc

echo "ZSH installation and configuration complete."
echo "You might need to logout and log back in to see the changes."


# Install Tmux
echo "Installing Tmux..."
sudo apt-get install -y tmux

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo snap install --classic code

# Install the latest version of Java with OpenJDK
echo "Installing the latest version of Java with OpenJDK..."
sudo apt-get install -y openjdk-11-jdk
# For the latest OpenJDK version, consider using a PPA or another method if necessary.

# Install the newest version of Python3
echo "Installing the newest version of Python3..."
sudo apt-get install -y python3 python3-pip

# Install git-filter-repo
echo "Installing git-filter-repo..."
python3 -m pip install --user git-filter-repo

# Install the newest version of Rust
echo "Installing Rust..."

# Note: Rust installation prompts for user input. Below is for a non-interactive install:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Firefox
echo "Installing Firefox..."
sudo apt-get install -y firefox

# Set Firefox as the default browser
echo "Setting Firefox as the default browser..."
xdg-settings set default-web-browser firefox.desktop

# Set VS Code as the default text editor
echo "Setting VS Code as the default text editor..."
sudo update-alternatives --install /usr/bin/editor editor /snap/bin/code 100
sudo update-alternatives --set editor /snap/bin/cod

# Final message
echo "Developer environment setup is complete!"
echo "You might need to logout and log back in for some changes to take effect."

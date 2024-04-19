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
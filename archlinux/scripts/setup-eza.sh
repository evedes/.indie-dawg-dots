#!/bin/bash

echo "Installing eza - modern ls replacement with colors and icons..."
sudo pacman -S eza

echo ""
echo "Setting up aliases..."

# Check if aliases file exists
ALIAS_FILE="$HOME/.config/zsh/aliases.zsh"
if [[ ! -f "$ALIAS_FILE" ]]; then
    ALIAS_FILE="$HOME/.zshrc"
fi

# Backup existing aliases
cp "$ALIAS_FILE" "$ALIAS_FILE.backup"

# Add eza aliases if not already present
if ! grep -q "alias ls=" "$ALIAS_FILE"; then
    cat >> "$ALIAS_FILE" << 'EOF'

# Eza (modern ls replacement)
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alh --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias lt='eza --tree --icons --color=always --group-directories-first'
alias l.='eza -a | grep "^\."'

# Enhanced directory listing
alias lsa='eza -lah --icons --color=always --group-directories-first --git'
alias lst='eza -lah --icons --color=always --group-directories-first --git --tree --level=2'
EOF
    echo "✅ Aliases added to $ALIAS_FILE"
else
    echo "⚠️  Aliases already exist, skipping..."
fi

echo ""
echo "Testing eza..."
echo "-------------------"
echo "Basic listing:"
eza --icons --color=always --group-directories-first ~/

echo ""
echo "Detailed listing with Git status:"
eza -lah --icons --color=always --group-directories-first --git ~/

echo ""
echo "Tree view:"
eza --tree --icons --color=always --group-directories-first --level=2 ~/

echo ""
echo "✅ Setup complete!"
echo ""
echo "Available commands:"
echo "  ls  - Basic listing with icons"
echo "  ll  - Long format with details"
echo "  la  - Show all files including hidden"
echo "  lt  - Tree view"
echo "  lsa - Long format with Git status"
echo "  lst - Tree view with details (2 levels)"
echo ""
echo "Reload your shell or run: source ~/.zshrc"
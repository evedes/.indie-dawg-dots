#!/bin/bash

echo "🎨 Installing eza with blue theme matching your rofi..."
echo "=================================================="
echo ""

# Install eza
echo "📦 Installing eza..."
sudo pacman -S eza

# Find the right config file
if [[ -f "$HOME/.zshrc" ]]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    CONFIG_FILE="$HOME/.zshrc"
    touch "$CONFIG_FILE"
fi

echo "📝 Adding configuration to $CONFIG_FILE"

# Backup config
cp "$CONFIG_FILE" "$CONFIG_FILE.backup-$(date +%Y%m%d-%H%M%S)"

# Check if eza config already exists
if ! grep -q "EZA_COLORS" "$CONFIG_FILE"; then
    cat >> "$CONFIG_FILE" << 'EOCONFIG'

# ========================================
# Eza - Modern ls with blue theme
# ========================================

# Blue color palette matching rofi theme
# Colors: bright blue (94), cyan (96), white (97), red (91) for errors
export EZA_COLORS="di=1;94:ex=1;96:ln=3;96:so=94:pi=97:bd=94;1:cd=94;1:su=91;1:sg=91;1:tw=94;1:ow=94;1"
export EZA_COLORS="$EZA_COLORS:ur=94:uw=96:ux=97:ue=97:gr=34:gw=36:gx=37:tr=31:tw=32:tx=33"
export EZA_COLORS="$EZA_COLORS:sn=1;94:da=1;97:in=36:lp=96:ga=1;94:gm=3;96:gd=91:gv=34:gt=97:gi=90:gc=1;91"

# Standard aliases
alias ls='eza --icons=auto --color=always --group-directories-first'
alias ll='eza -alh --icons=auto --color=always --group-directories-first'
alias la='eza -a --icons=auto --color=always --group-directories-first'
alias l='eza -F --icons=auto --color=always --group-directories-first'
alias lt='eza --tree --icons=auto --color=always --group-directories-first --level=2'
alias l.='eza -d .* --icons=auto --color=always'

# Git integration
alias lg='eza -alh --icons=auto --color=always --group-directories-first --git'
alias lsg='eza -alh --icons=auto --color=always --group-directories-first --git --sort=modified'

# Time-based listing
alias lsnew='eza -alh --icons=auto --color=always --group-directories-first --sort=created'
alias lsold='eza -alh --icons=auto --color=always --group-directories-first --sort=created --reverse'

# Size-based listing
alias lsize='eza -alh --icons=auto --color=always --group-directories-first --sort=size --reverse'

# Extended attributes and permissions
alias lx='eza -albhHigUmuSa@ --icons=auto --color=always --group-directories-first --git'

EOCONFIG
    echo "✅ Configuration added!"
else
    echo "⚠️  Configuration already exists, skipping..."
fi

echo ""
echo "🎨 Testing eza with blue theme..."
echo "================================="
echo ""

# Create a test directory with various file types
TEST_DIR="/tmp/eza-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create test files
touch README.md script.sh config.json
chmod +x script.sh
mkdir -p src docs .hidden
touch src/main.rs docs/guide.pdf .hidden/.secret
ln -s README.md README-link

echo "📁 Basic listing (ls):"
eza --icons=auto --color=always --group-directories-first

echo ""
echo "📊 Detailed listing (ll):"
eza -alh --icons=auto --color=always --group-directories-first

echo ""
echo "🌳 Tree view (lt):"
eza --tree --icons=auto --color=always --group-directories-first --level=2

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

echo ""
echo "✨ Setup complete!"
echo ""
echo "📚 Available commands:"
echo "  ls    - Basic listing with icons and colors"
echo "  ll    - Long format with all details"
echo "  la    - Show all including hidden files"
echo "  lt    - Tree view (2 levels)"
echo "  lg    - Long format with Git status"
echo "  lsnew - Sort by newest first"
echo "  lsize - Sort by size (largest first)"
echo ""
echo "🔄 To apply changes, run:"
echo "  source $CONFIG_FILE"
echo ""
echo "💡 Your ls output now matches your blue rofi theme!"
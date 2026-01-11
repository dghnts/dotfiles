#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define files to symlink
# Format: "source_path_relative_to_dotfiles:target_path_relative_to_home"
FILES_TO_LINK=(
    "bash/.bashrc:.bashrc"
    "bash/.profile:.profile"
    "bash/.bash_logout:.bash_logout"
    "bash/.bash_aliases:.bash_aliases"
    "git/.gitconfig:.gitconfig"
    "vim/.vimrv:.vimrv"
)

link_file() {
    local entry="$1"
    IFS=":" read -r src dest <<< "$entry"
    local src_path="$DOTFILES_DIR/$src"
    local dest_path="$HOME/$dest"

    # Backup existing file if it's not a symlink and exists
    if [ -f "$dest_path" ] && [ ! -L "$dest_path" ]; then
        echo "Backing up existing $dest to $dest.bak"
        mv "$dest_path" "$dest_path.bak"
    fi

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest_path")"

    # Create symlink
    echo "Linking $dest_path -> $src_path"
    ln -sf "$src_path" "$dest_path"
}

if [ -n "$1" ]; then
    link_file "$1"
else
    echo "Setting up dotfiles..."
    for entry in "${FILES_TO_LINK[@]}"; do
        link_file "$entry"
    done
    echo "Setup complete!"
fi

#!/bin/bash

# scripts/rename_dotfile.sh
# Automates the process of renaming a managed dotfile.
# 1. Finds the source file in the dotfiles repo
# 2. Renames the source file to match the new name
# 3. Updates setup.sh
# 4. Updates symlinks and commits to Git

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP_SH="$DOTFILES_DIR/setup.sh"

usage() {
    echo "Usage: $0 <old_name> <new_name>"
    echo "Example: $0 .vimrv .vimrc"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

OLD_NAME="$1"
NEW_NAME="$2"

# 1. Find the entry in setup.sh
# The entry format is "category/filename:target_name"
ENTRY=$(grep ":$OLD_NAME\"" "$SETUP_SH" | sed 's/^[[:space:]]*\"//;s/\",$//;s/\"$//')

if [ -z "$ENTRY" ]; then
    echo "Error: Could not find '$OLD_NAME' in $SETUP_SH"
    exit 1
fi

IFS=":" read -r OLD_SRC OLD_DEST <<< "$ENTRY"
OLD_SRC_PATH="$DOTFILES_DIR/$OLD_SRC"
CATEGORY=$(dirname "$OLD_SRC")

# 2. Calculate new paths
NEW_SRC="$CATEGORY/$NEW_NAME"
NEW_SRC_PATH="$DOTFILES_DIR/$NEW_SRC"
NEW_DEST="$NEW_NAME"

echo "Renaming $OLD_NAME to $NEW_NAME..."

# 3. Rename source file in repo
if [ -f "$OLD_SRC_PATH" ]; then
    echo "Step 1: Renaming $OLD_SRC_PATH to $NEW_SRC_PATH..."
    mv "$OLD_SRC_PATH" "$NEW_SRC_PATH"
else
    # Maybe it was already renamed or the file doesn't exist?
    if [ ! -f "$NEW_SRC_PATH" ]; then
        echo "Error: Source file $OLD_SRC_PATH not found."
        exit 1
    fi
fi

# 4. Update setup.sh
echo "Step 2: Updating setup.sh..."
# Escaping for sed
TEMP_FILE=$(mktemp)
sed "s|\"$OLD_SRC:$OLD_DEST\"|\"$NEW_SRC:$NEW_DEST\"|" "$SETUP_SH" > "$TEMP_FILE"
mv "$TEMP_FILE" "$SETUP_SH"
chmod +x "$SETUP_SH"

# 5. Handle HOME directory links
# If OLD_NAME still exists at HOME, move/remove it
if [ -L "$HOME/$OLD_NAME" ]; then
    rm "$HOME/$OLD_NAME"
elif [ -f "$HOME/$OLD_NAME" ] && [ ! -L "$HOME/$OLD_NAME" ]; then
    echo "Warning: $HOME/$OLD_NAME is a real file, not a symlink. Backing up to .bak"
    mv "$HOME/$OLD_NAME" "$HOME/$OLD_NAME.bak"
fi

# 6. Run setup.sh for the new name
echo "Step 3: Updating symlink..."
bash "$SETUP_SH" "$NEW_SRC:$NEW_DEST"

# 7. Commit changes
echo "Step 4: Managing changes with Git..."
cd "$DOTFILES_DIR"
git add .
git commit -m "Rename $OLD_NAME to $NEW_NAME"

echo "Done! $OLD_NAME has been renamed to $NEW_NAME across the repository."

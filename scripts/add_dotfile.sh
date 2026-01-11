#!/bin/bash

# scripts/add_dotfile.sh
# Automates the process of adding a new dotfile to this repository.
# 1. Moves the file to the dotfiles directory
# 2. Updates setup.sh
# 3. Runs setup.sh
# 4. Commits changes to Git

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP_SH="$DOTFILES_DIR/setup.sh"

usage() {
    echo "Usage: $0 <filename> [category]"
    echo "Example: $0 .vimrc vim"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

FILENAME="$1"
# Ensure we are looking at the file in the HOME directory
FILE_PATH="$HOME/$FILENAME"

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File $FILE_PATH does not exist in your home directory."
    exit 1
fi

if [ -L "$FILE_PATH" ]; then
    echo "Error: $FILE_PATH is already a symbolic link."
    exit 1
fi

FILENAME=$(basename "$FILE_PATH")
# Default category: remove leading dot
CATEGORY_DEFAULT="${FILENAME#.}"
CATEGORY="${2:-$CATEGORY_DEFAULT}"

TARGET_DIR="$DOTFILES_DIR/$CATEGORY"
TARGET_PATH="$TARGET_DIR/$FILENAME"

# Relativize source path for setup.sh (relative to dotfiles dir)
REL_SRC_PATH="$CATEGORY/$FILENAME"

# Relativize destination path for setup.sh (relative to HOME)
if [[ "$FILE_PATH" == "$HOME"* ]]; then
    REL_DEST_PATH="${FILE_PATH#$HOME/}"
else
    echo "Error: File must be inside your home directory ($HOME)."
    exit 1
fi

echo "Step 1: Moving $FILE_PATH to $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
mv "$FILE_PATH" "$TARGET_PATH"

echo "Step 2: Updating setup.sh..."
ENTRY="    \"$REL_SRC_PATH:$REL_DEST_PATH\""

# Check if entry already exists in setup.sh
if grep -q "$REL_SRC_PATH:$REL_DEST_PATH" "$SETUP_SH"; then
    echo "Entry already exists in setup.sh. Skipping."
else
    # Insert the entry before the closing parenthesis of the FILES_TO_LINK array
    TEMP_FILE=$(mktemp)
    awk -v entry="$ENTRY" '
        /^FILES_TO_LINK=\(/ { inside=1 }
        inside && /^[[:space:]]*\)/ { print entry; inside=0 }
        { print }
    ' "$SETUP_SH" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$SETUP_SH"
    chmod +x "$SETUP_SH"
fi

echo "Step 3: Running setup.sh..."
bash "$SETUP_SH"

echo "Step 4: Managing changes with Git..."
cd "$DOTFILES_DIR"
git add .
# Only commit if there are changes
if ! git diff --cached --quiet; then
    git commit -m "Add $FILENAME to dotfiles"
    echo "Changes committed."
else
    echo "No changes to commit."
fi

echo "Done! $FILENAME has been added and successfully linked."

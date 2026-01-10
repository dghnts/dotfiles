#!/bin/bash

# 保存先ディレクトリの定義
DOTFILES_DIR="$HOME/dotfiles"
SYSTEM_DIR="$DOTFILES_DIR/system"
LIST_FILE="$SYSTEM_DIR/package_list.txt"

# ディレクトリが存在することを確認
mkdir -p "$SYSTEM_DIR"

# パッケージ一覧を更新
# 手動でインストールしたものに絞る (推奨設定)
apt-mark showmanual > "$LIST_FILE"

# Snapパッケージがある場合は追記
if command -v snap > /dev/null; then
    echo -e "\n# Snap Packages" >> "$LIST_FILE"
    snap list >> "$LIST_FILE"
fi

# Gitに差分があればコミット
cd "$DOTFILES_DIR"
if [[ -n $(git status --porcelain "$LIST_FILE") ]]; then
    git add "$LIST_FILE"
    git commit -m "Auto-update package list: $(date +'%Y-%m-%d')"
    echo "Package list updated and committed."
else
    echo "No changes in package list."
fi

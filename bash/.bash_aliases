# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Dotfiles master command
# No alias needed as scripts/ is in PATH, but we can ensure it's easy to use

# atcoder-cli alias
acc_test_and_submit (){
    echo "🧪 Running tests..."

    # 1. テスト実行
    # ojはカレントディレクトリの test/ を自動参照します
    oj t -c "python ./main.py"

    if [ $? -eq 0 ]; then
        echo "✅ Tests passed!"

        # 3. コードをクリップボードにコピー (WSL2の clip.exe を利用)
        cat main.py | clip.exe
        echo "📋 Code copied to clipboard!"

        # 4. 提出ページをブラウザで開く
        # 現在のディレクトリ名から問題IDを推測してURL生成
        CONTEST_DIR=$(basename $(dirname $(pwd))) # 例: abc380
        TASK_DIR=$(basename $(pwd))               # 例: a
        TASK_ID="${CONTEST_DIR}_${TASK_DIR}"      # 例: abc380_a
        SUBMIT_URL="https://atcoder.jp/contests/${CONTEST_DIR}/submit?taskScreenName=${TASK_ID}"

        # wslu (wslview) でWindows側のブラウザを起動
        wslview "$SUBMIT_URL"

        # 5. Git記録
        echo "🚀 Committing to Git..."
        pushd "$ATCODER_ROOT" > /dev/null
        git add .
        git commit -m "Solved: ${TASK_ID} at $(date +'%Y-%m-%d %H:%M')"
        popd > /dev/null
        echo "💾 Git recorded."

        echo "👉 Just Paste (Ctrl+V) and Submit!"
    else
        echo "❌ Tests failed."
    fi
}

alias acs=acc_test_and_submit

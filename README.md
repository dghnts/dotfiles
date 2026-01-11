# dotfiles

自分の開発環境を管理するためのドットファイル群です。

## 構成

- `bash/`: Bashの設定ファイル (`.bashrc`, `.bash_aliases`, `.profile`, `.bash_logout`)
- `git/`: Gitの設定ファイル (`.gitconfig`)
- `scripts/`: 便利スクリプト (`update_packages.sh` など)
- `system/`: システム状態の記録 (`package_list.txt`)
- `setup.sh`: シンボリックリンクを自動作成するセットアップスクリプト

## 使い方

新しい環境で以下のコマンドを実行すると、各設定ファイルのシンボリックリンクが作成されます。

```bash
./setup.sh
```

## パッケージリストの更新

インストールされているパッケージの一覧を更新するには、以下のスクリプトを実行します。

```bash
./scripts/update_packages.sh
```

## 新しいドットファイルを追加する場合

1. **ファイルを `dotfiles` ディレクトリ内に移動する**
   例として `.vimrc` を追加する場合:
   ```bash
   mkdir -p ~/dotfiles/vim
   mv ~/.vimrc ~/dotfiles/vim/.vimrc
   ```

2. **`setup.sh` を更新する**
   `setup.sh` 内の `FILES_TO_LINK` 配列に、追加したファイルのエントリを記述します。
   ```bash
   FILES_TO_LINK=(
       ...
       "vim/.vimrc:.vimrc"
   )
   ```

3. **セットアップスクリプトを実行する**
   ```bash
   ~/dotfiles/setup.sh
   ```

4. **変更を Git で管理する**
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Add .vimrc"
   ```

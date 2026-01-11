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
dotupdate
```

## 新しいドットファイルを追加する場合

以下のスクリプトを使用することで、ファイルの移動、`setup.sh` の更新、シンボリックリンクの作成、Git へのコミットを自動で行うことができます。

```bash
dotadd <ファイルのパス> [カテゴリ名]
```

**例: `.vimrc` を追加する場合**

```bash
dotadd ~/.vimrc vim
```

このコマンドを実行すると、以下の作業が自動的に行われます：
1. `~/.vimrc` を `~/dotfiles/vim/.vimrc` に移動
2. `setup.sh` の `FILES_TO_LINK` 配列にエントリを追加
3. `setup.sh` を実行してシンボリックリンクを再作成
4. 変更を Git でコミット

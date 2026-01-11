# dotfiles

自分の開発環境を管理するためのドットファイル群です。

## 構成

- `bash/`: Bashの設定ファイル (`.bashrc`, `.bash_aliases`, `.profile`, `.bash_logout`)
- `git/`: Gitの設定ファイル (`.gitconfig`)
- `scripts/`: 管理用スクリプト群
- `system/`: システム状態の記録 (`package_list.txt`)
- `setup.sh`: シンボリックリンクを自動作成するセットアップスクリプト

## 使い方

新しい環境で以下のコマンドを実行すると、各設定ファイルのシンボリックリンクが作成されます。

```bash
./setup.sh
```

一度セットアップが終われば、以降は `dot` コマンドを使用して管理できます。

### 基本コマンド

#### 1. 新しいドットファイルを追加する
```bash
dot add <ファイル名> [カテゴリ名]
```
例: `dot add .vimrc vim`

#### 2. ドットファイルの名前を変更する
```bash
dot mv <旧名> <新名>
```
例: `dot mv .vimrv .vimrc`

#### 3. パッケージリストを更新する
```bash
dot update
```

#### 4. シンボリックリンクを再生成する
```bash
dot setup
```

## 自動化の詳細

`dot add` または `dot mv` を実行すると、以下の作業が自動的に行われます：
1. `dotfiles` リポジトリ内のファイルの移動・リネーム
2. `setup.sh` の `FILES_TO_LINK` 配列の自動更新
3. ホームディレクトリのシンボリックリンクの作成・更新
4. 変更内容の Git コミット

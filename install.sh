DOTPATH = "~/.dotfiles"

if has "git"; then
	git clone --recursive "https://github.com/dghnts/dotfiles.git" "$DOTPATH"
elif has "curl" || has "wget"; then

    tarball="https://github.com/dghnts/dotfiles/archive/main.tar.gz"

    # どっちかでダウンロードして，tar に流す
    if has "curl"; then
        curl -L "$tarball"

    elif has "wget"; then
        wget -O - "$tarball"

    fi | tar zxv

    # 解凍したら，DOTPATH に置く
    mv -f dotfiles-main "$DOTPATH"

else
    die "curl or wget required"
fi

if [! -e $DOTPATH ]; then
    mkdir $DOTPATH
fi
cd $DOTPAH

# 移動できたらリンクを実行する
for file in .??*
do 
	["$file" = ".git"] && continue
	
	ln -snvf "$DOTPATH/$file" "$HOME"/"$file" 
done

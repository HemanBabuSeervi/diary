SHARE="$HOME/.local/share/diary"
cd $SHARE
./crypt.sh decrypt

xdg-open index.pdf

./crypt.sh encrypt

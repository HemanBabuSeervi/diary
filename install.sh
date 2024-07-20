SHARE="$HOME/.local/share/diary"
confidential="backup root index-header.html index-footer.html index.html script.js style.css index.pdf"
header="\
<!DOCTYPE html> \
<html> \
    <head> \
        <link rel=stylesheet href=style.css /> \
    </head> \
    <body>"
footer="\
    <script src=script.js></script> \
    </body> \
</html>"

abortMessage(){
	echo -e "\033[0;31mPlease $1. Aborting Install\033[0m"
	exit
}
if [[ -z $BROWSER ]]; then
	abortMessage 'initialize $BROWSER variable'
fi
if [[ -z $EDITOR ]]; then
	abortMessage 'initialize $EDITOR variable'
fi
if ! command -v wkhtmtopdf &> /dev/null; then
	abortMessage 'install wkhtmltopdf'
fi


echo "========Initializing $SHARE"
mkdir -p $SHARE
cd $SHARE
mkdir backup root

echo "$header" > index-header.html
echo "$footer" > index-footer.html
cat index-header.html index-footer.html > index.html
touch style.css script.js
echo '0' > .decryptStackSize
wkhtmltopdf --enable-local-file-access index.html index.pdf
tar -cf data $confidential

echo "========Creating encrypted file data.gpg"
echo -n "Give your GPG User-ID : "
read gpguid

gpgError(){
    echo "Cound't use $gpguid to initiate data.gpg file"
    echo "Cleaning & Aborting Installation"
    rm -rf $HOME/.local/share/diary
    exit
}
gpg -r $gpguid --encrypt data || gpgError
rm -rf data $confidential
cd -


cp diary.sh writeDiary.sh viewDiary.sh genDiary.sh crypt.sh $SHARE
ln -s -T $SHARE/diary.sh $HOME/.local/bin/diary && echo -e "\n\t========Program Installation Complete========\n"

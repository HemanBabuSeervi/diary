USAGE="Usage: ./crypt.sh [ encrypt | decrypt ]"
SHARE="$HOME/.local/share/diary"
confidential="root backup index-header.html index-footer.html index.html script.js style.css index.pdf"

decryptStackSize(){
    cat .decryptStackSize
}
incDecryptStackSize(){
    echo "$(( $(decryptStackSize)+1 ))" > .decryptStackSize
}
decDecryptStackSize(){
    echo "$(( $(decryptStackSize)-1 ))" > .decryptStackSize
}
isDecryptSafe(){
    #If diary is already decrypted and is being worked on i.e. decryptStackSize > 0. Then dont do anything to preserve the changes being made
    if [[ $(decryptStackSize) -eq 0 ]]; then
        return 0
    fi
    return 1
}
isEncryptSafe(){
    #decryptStackSize returns how many times decryption of diary was requested after the last encryption
    #If decryption was not requested i.e. decryptStackSize==0. There are no files to Encrypt
    #If decryption was requested once i.e. decryptStackSize==1, Encryption can be safely performed
    #If decryption was requested more than once i.e. decryptStackSize>1, it means that other program scripts are still using the files, Encryption will break those scripts
    if [[ $(decryptStackSize) -eq 1 ]]; then
        return 0
    fi
    return 1
}
cd $SHARE
if [[ "$1" = "encrypt" && $# -eq 1 ]]; then
    if ! isEncryptSafe; then
#        echo "Encryption not Safe. NOTE: decryptStackSize was=$(decryptStackSize) isnow=$(($(decryptStackSize)-1))"
        decDecryptStackSize
        exit
    fi
    decDecryptStackSize
    tar -cf data $confidential
    gpg -r heman --encrypt data
#    echo "EnCRYPTED!!!"
    rm -rf data $confidential
elif [[ "$1" = "decrypt" && $# -eq 1 ]]; then
    if ! isDecryptSafe; then
#        echo "Decryption not Safe. NOTE: decryptStackSize was=$(decryptStackSize) isnow=$(($(decryptStackSize)+1))"
        incDecryptStackSize
        exit
    fi
    incDecryptStackSize
    gpg --decrypt data.gpg > data
#    echo "DECRYPTED!!!"
    tar -xf data
    rm data data.gpg
else
    echo $USAGE
fi
cd -

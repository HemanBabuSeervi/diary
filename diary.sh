SHARE="$HOME/.local/share/diary"
USAGE="\
Usage: diary\twrite [ DD MM YYYY ]\n\
\t\tview [ html ]\n\
\t\tedit ( header | footer | style | script )\n\
\t\tgenLoop [ <seconds> ]"

if [[ "$1" = "write" ]]; then
    if [[ "$2" =~ ^[0-9]{2}$ && "$3" =~ ^[0-9]{2}$ && "$4" =~ ^[0-9]{4}$ && $# -eq 4 ]]; then     #Checking if $2 is 2-digit no., $3 is 2-digit no., $4 is 4-digit no.
        $SHARE/writeDiary.sh $2 $3 $4
        $SHARE/genDiary.sh
    elif [[ $# -eq 1 ]]; then
        $SHARE/writeDiary.sh
        $SHARE/genDiary.sh
    else
        echo -e $USAGE
        exit 1
    fi
elif [[ "$1" = "view" ]]; then
    if [[ "$2" = "html" && $# -eq 2 ]]; then
        $SHARE/crypt.sh decrypt
        $BROWSER $SHARE/index.html
        $SHARE/crypt.sh encrypt
    elif [[ $# -eq 1 ]]; then
        $SHARE/viewDiary.sh
    else
        echo -e $USAGE
        exit 2
    fi
elif [[ "$1" = "edit" ]]; then
    if [[ "$2" = "header" && $# -eq 2 ]]; then
        $SHARE/crypt.sh decrypt
        $EDITOR $SHARE/index-header.html
        $SHARE/crypt.sh encrypt
        $SHARE/genDiary.sh
    elif [[ "$2" = "footer" && $# -eq 2 ]]; then
        $SHARE/crypt.sh decrypt
        $EDITOR $SHARE/index-footer.html
        $SHARE/crypt.sh encrypt
        $SHARE/genDiary.sh
    elif [[ "$2" = "style" && $# -eq 2 ]]; then
        $SHARE/crypt.sh decrypt
        $EDITOR $SHARE/style.css
        $SHARE/crypt.sh encrypt
        $SHARE/genDiary.sh
    elif [[ "$2" = "script" && $# -eq 2 ]]; then
        $SHARE/crypt.sh decrypt
        $EDITOR $SHARE/script.js
        $SHARE/crypt.sh encrypt
        $SHARE/genDiary.sh
    else
        echo -e $USAGE
        exit 3
    fi
elif [[ "$1" = "genLoop" ]]; then
    if [[ "$2" =~ ^[0-9]+$ && $# -eq 2 ]]; then
        while true; do
            $SHARE/genDiary.sh
            sleep $2
        done
    elif [[ $# -eq 1 ]]; then
        while true; do
            $SHARE/genDiary.sh
            sleep 3
        done
    else
        echo -e $USAGE
        exit 4
    fi
else
    echo -e $USAGE
    exit 5
fi

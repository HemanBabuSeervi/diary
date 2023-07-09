SHARE="$HOME/.local/share/diary"
cd $SHARE
./crypt.sh decrypt

TERM=ansi   #bug-fix for tidy to work
diary(){
    cat index-header.html > indexUnformatted.html
    for year in $(ls root/[0-9][0-9][0-9][0-9] -dr); do
        year=$(basename $year)
        for month in $(ls root/$year/[0-9][0-9] -dr); do
            month=$(basename $month)
            calenderTitle=$(cal -3 | head -1 | gawk  '{
             n=split($0,a," ",b)
             a[3]=("<span class=\"month-title\">"a[3])
             a[4]=(a[4]"</span>")
             line=b[0]
             for (i=1;i<=n; i++)
                 line=(line a[i] b[i])
             print line
            }')
            calender=$(cal -3 | tail +2)
            echo "<pre class=\"calender\">$calenderTitle" >> indexUnformatted.html
            echo "$calender</pre>" >> indexUnformatted.html
            for day in $(ls root/$year/$month/[0-9][0-9].html -r); do
                day=$(basename $day)
                trueday="$(echo $day | sed 's/.html//')"
                #title="$trueday-$month-$year"
                title=$(date --date="$month/$trueday/$year" +"%A %d %B %Y")
                notes="$(cat root/$year/$month/$day)"
                echo "<div class=\"day\"><h3>$title</h3><div class=notes>$notes</div></div>" >> indexUnformatted.html
            done
        done
    done
    cat index-footer.html >> indexUnformatted.html
}
backup(){
    if [[ -e $1 ]]; then
        backupExt=$(date +"%H-%M-%S=%d-%m-%Y")
        mkdir -p $(dirname "backup/$1")
        mv "$1" "backup/$1.$backupExt"
    fi
}

backup "index.html"
diary

tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > index.html
wkhtmltopdf --enable-local-file-access index.html index.pdf

rm indexUnformatted.html
./crypt.sh encrypt
cd -

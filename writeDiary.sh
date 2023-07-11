SHARE="$HOME/.local/share/diary"
cd $SHARE
./crypt.sh decrypt

if [[ -z $1 && -z $2 && -z $3 ]]; then
    day=$(date +%d)
    month=$(date +%m)
    year=$(date +%Y)
elif [[ $1 =~ ^[0-9]{2}$ && $2 =~ ^[0-9]{2}$ && $3 =~ ^[0-9]{4}$ && $# -eq 3 ]]; then
    day=$1
    month=$2
    year=$3
else
    echo "Usage: writeDiary.sh [DD MM YYYY]"
fi
mkdir -p "root/$year/$month"
$EDITOR "root/$year/$month/$day.html"
cp "root/$year/$month/$day.html" "root/$year/$month/$day.copy.html"
tidy -indent --indent-spaces 4 --tidy-mark no -quiet --show-body-only yes "root/$year/$month/$day.copy.html" > "root/$year/$month/$day.html"

./crypt.sh encrypt
cd -

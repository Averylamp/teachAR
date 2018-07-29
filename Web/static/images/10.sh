new=0
ext=

for i in *
do
        ext="${i#*.}"
        mv "$i" "$new.$ext"
        ((new++))
done

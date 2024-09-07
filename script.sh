#!/bin/zsh
declare -A the_dict

# cat cedict_short.u8| while read line; do
cat cedict_ts.u8| while read line; do
    if [[ ${line:1} == '#' ]]; then continue; fi
    simp=$(echo $line | cut -d ' ' -f1)
    the_dict[${simp}]="${line}"
done

printCsv() {
    simp=""
    pinyin=""
    english=""
    regex='^([^ ]*) ([^ ]*) \[([a-zA-ZÜü0-9 ]+)\] (.*)'
 
    if [[ $1 =~ $regex ]]; then
        simp=$match[1]
        pinyin=$match[3]
        english=$match[4]
    else return
    fi 
    echo "${simp}\t${pinyin}\t${english}"
}

input_text=$(tee)
echo ${input_text} | sed -e 's/\(.\)/\1\n/g' | while read line; do
    printCsv ${the_dict[$line]}
done
#!/bin/zsh

echo "${BASH_VERSION}"

#See https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default - there are some bugs/scoping issues here
declare -A the_dict
# the_dict["lol"]='hi'

# echo ${the_dict["lol"]}


# cat cedict_short.u8| while read line; do
cat cedict_ts.u8| while read line; do
    if [[ ${line:1} == '#' ]]; then continue; fi
    simp=$(echo $line | cut -d ' ' -f1)
    the_dict[${simp}]="${line}"
done

# for key value in ${(kv)the_dict}; do
#     echo "$key -> $value"
# done

# echo ${(k)the_dict}
# echo $the_dict[㐤]
# 
# echo ${the_dict[㐤]}


# char="㐤"
# echo ${the_dict[$char]}

printCsv() {
    line=$1
    simp=$(echo $line | cut -d ' ' -f1)
    pinyin_regex='^([^ ]*) ([^ ]*) \[([a-zA-ZÜü0-9 ]+)\] (.*)'
    pinyin=""
    english=""
    if [[ $line =~ $pinyin_regex ]]; then
        simp=$match[1]
        pinyin=$match[3]
        english=$match[4]
    else return
    fi 
    echo "${simp}\t${pinyin}\t${english}"
}

printCsv ${the_dict[$char]}

input_text=$(tee)
echo ${input_text} | sed -e 's/\(.\)/\1\n/g' | while read line; do
    printCsv ${the_dict[$line]}
done
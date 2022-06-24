
#!/bin/bash
empty_paramter=''
vs_currency=$1
per_page=$2
RankTitle="Rank"
NameTitle="Name"
SymbolTitle="Symbol"
CPTitle="Current Price(${vs_currency^^})"
padding="               "
paddingWithZero="0"
i=0
if [[ $vs_currency != $empty_paramter && $per_page != $empty_paramter ]]
then
    curl -s 'GET' \
    "https://api.coingecko.com/api/v3/coins/markets?vs_currency=$vs_currency&order=market_cap_desc&per_page=$per_page&page=1&sparkline=false" \
    -H 'accept: application/json' | jq . > coins.json

printf "%13s %s %s %s %s %s %s %s\n" "$RankTitle" "${padding:${#RankTitle}}" "$NameTitle" "${padding:${#NameTitle}}" "$SymbolTitle" "${padding:${#SymbolTitle}}" "$CPTitle"

    readarray -t coins < <(jq -c '.[]' coins.json)

    for coin in "${coins[@]}"; do
        ((i++))
        Rank=$i
        Name=$(jq .name <<< "$coin" | sed 's/"//g')
        Symbol=$(jq .symbol <<< "$coin" | sed 's/"//g')
        Current_Price=$(jq .current_price <<< "$coin"  | sed 's/"//g')

        printf "%10s%s%s %s %s %s %s %s %s\n" "${paddingWithZero:${#Rank}}" "$Rank" "${padding:${#Rank}}" "$Name" "${padding:${#Name}}" "$Symbol" "${padding:${#Symbol}}" "$Current_Price"
    done
fi
if [[ $vs_currency == $empty_paramter ]]
then
        echo "Please pass currency as an argument"
fi
if [[ $per_page == $empty_paramter ]]
then
        echo "Please pass per page an argument"
fi






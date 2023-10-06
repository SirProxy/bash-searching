#!/bin/bash

# [?] Script para busca de arquivos.
# [?] Requisitos:
# [?] - lynx browser

# [*] Developer: sirProxy_ <joao@tavares.dev.br>
# [*] Website: https://tavares.dev.br
# [*] Github: https://github.com/SirProxy

CIANO="\e[1;36m"
VERDE="\e[1;32m"
ENDCOLOR="\e[0m"

function loading() {
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '—' "\\" '|' '/' )

    echo -n "${loading_message} "

    tput civis
    trap "tput cnorm" EXIT
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.25
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
    tput cuu1; tput dl1 
}

function escrever() {
  echo -e "[${CIANO}$1${ENDCOLOR}] $2"
}

function banner() {
    echo -e " " 
    echo -e "${CIANO}               ░█▀▀░█▀▀░█▀█░█▀▄░█▀▀░█░█░▀█▀░█▀█░█▀▀ ${ENDCOLOR}"
    echo -e "${CIANO}               ░▀▀█░█▀▀░█▀█░█▀▄░█░░░█▀█░░█░░█░█░█░█ ${ENDCOLOR}"
    echo -e "${CIANO}               ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀ ${ENDCOLOR}"
    echo -e "${CIANO}                            by sirProxy_ ${ENDCOLOR}"
    echo -e " " 
    escrever "?" "Script to search indexed file types on Google and Bing"
    escrever "?" "This script is compatible with all file formats. Example: PDF, DOCS, XML, MP4"
    escrever "?" "Feel free to improve this version. Thank you ${CIANO}╰(*°▽°*)╯${ENDCOLOR}"
    escrever "?" "Version: ${CIANO}0.1${ENDCOLOR}"
    echo -e " "
    escrever "@" "Developer: ${CIANO}sirProxy_ ${ENDCOLOR}<${CIANO}joao@tavares.dev.br${ENDCOLOR}>"
    escrever "@" "Website: ${CIANO}https://tavares.dev.br${ENDCOLOR}"
    escrever "@" "Github: ${CIANO}https://github.com/SirProxy${ENDCOLOR}"
    echo -e " "
}

loading 2 "Loading Searching"

if [ "$1" == "" ] && [ "$2" == "" ] && [ "$3" == "" ]
then

    banner

    escrever "*" "Using: $0 <target_website> <extension> <total_pages>"
    escrever "*" "Example: $0 google.com.br pdf 20"

else

    TARGET=$1
    EXTENSION=$2
    PAGES=$3
    TOTALPAGES=$(((10*$PAGES)-10))

    banner

    escrever "*" "Search: ${CIANO}Google ${ENDCOLOR}| ${CIANO}Bing${ENDCOLOR}"
    escrever "*" "Target: ${CIANO}$TARGET${ENDCOLOR}"
    escrever "*" "Extension: ${CIANO}$EXTENSION${ENDCOLOR}"
    escrever "*" "Total Pages Searched: ${CIANO}$PAGES${ENDCOLOR}"

    echo -e " "
    escrever "!" "Google Search Results:"
    
    for i in `seq 0 10 $TOTALPAGES`
    do
        loading 3 "Searching on page $((($i/10)+1))"
        lynx --dump "http://www.google.com/search?&q=site:$TARGET+ext:$EXTENSION&start=$i" | grep ".$EXTENSION" | cut -d "=" -f2 | egrep -v "site|google|[PDF]|>" | sed 's/...$//' | sed -e 's#^#[+] #'
    done

    echo -e " "
    escrever "!" "Bing Search Results:"

    TOTALPAGES=$(((6*$PAGES)-6))

    for i in `seq 0 6 $TOTALPAGES`
    do
        loading 3 "Searching on page $((($i/6)+1))"
        lynx --dump "https://www.bing.com/search?q=site:$TARGET+filetype:$EXTENSION&first=$i&FORM=PERE" | grep ".pdf" | egrep -v "bing|google|PDF File" | grep -v "PDF file" | cut -d " " -f 4 | sed -e 's#^#[+] #'
    done

    echo -e " "

fi



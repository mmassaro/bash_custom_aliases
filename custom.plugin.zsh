# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
#
#                                   _      _
#                   _o)   __ _  ___/ /__ _/ /_  __ _  (o_
#################   /\\  /  ' \/ _  / _ `/ _  \/  ' \ //\   ##################
#                   \_v /_/_/_/\_,_/\_, /_/ /_/_/_/_/ v_/
#                                  /___/
#
# Author:       Michel Massaro
# Version :     V1.0
# Date :        22/12/16
# Description : custom aliases for bash
#
##############################################################################


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# send_sms
alias sms='sh $HOME/Documents/Script/send_sms/send_sms.sh'

export PATH=$PATH:/opt/local/bin

alias ls='ls --color -h --group-directories-first'
alias lsl='ls --color -l -h --group-directories-first'
alias lsh='ls -lh'
alias lsr='ls -lrt'
alias cp='cp -v'

alias cim='vim'
alias Emacs='/Applications/Emacs.app/Contents/MacOS/./Emacs'

#Ne marche pas sur mac
#alias scons='scons -j $(nproc)'

#Des couleurs pour echo
noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
neutre='\e[0;m'
alias colorLine="echo -e \"${rougefonce}
*******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************
${neutre}\""

# Change keybord configuration
alias fr="setxkbmap fr"
alias us="setxkbmap us"

# generate de nomenclature for the thesis
alias nomencl="makeindex these_michel.nlo -s nomencl.ist -o these_michel.nls"


#alias meteo='curl wttr.in/strasbourg'
meteo(){
  if [ $# -eq 0 ]
  then
      curl wttr.in/strasbourg
  else
      curl wttr.in/$1
  fi
}

#function to create a sconstruct for latex
stex(){

    if [ $# -eq 2 ]
    then

        mkdir ${2}_$1
        cd ${2}_$1
        mkdir images

        touch sconstruct
        echo "import os" >> sconstruct
        echo "env=Environment()" >> sconstruct
        echo "env.PDF('${1}.tex')" >> sconstruct

        touch ${1}.tex

        if [ $2 = "beamer" ]
        then
            cp $HOME/Documents/Bases_Latex/Perso/beamer_massaro.cls .
            cp $HOME/Documents/Bases_Latex/Perso/qrcode.sty .

            echo "% vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\documentclass{beamer_massaro}" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\title{Title}" >> ${1}.tex
            echo "\\date{}" >> ${1}.tex
            echo "\\author[1]{Michel Massaro\\footnote{IRMA, 7 rue Ren\\'e Descartes," >> ${1}.tex
            echo "67084 Strasbourg, France \\\\" >> ${1}.tex
            echo "Email : massaro@math.unistra.fr}}" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\begin{document}" >> ${1}.tex
            echo "\\maketitle" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\end{document}" >> ${1}.tex

        elif [ $2 = "beamerposter" ]
        then

            echo "en construction"

        elif [ $2 = "article" ]
        then
            cp $HOME/Documents/Bases_Latex/Perso/article_massaro.cls .
            cp $HOME/Documents/Bases_Latex/Perso/qrcode.sty .

            echo "% vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\documentclass{article_massaro}" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\title{Title}" >> ${1}.tex
            echo "\\date{}" >> ${1}.tex
            echo "\\author[1]{Michel Massaro\\footnote{IRMA, 7 rue Ren\\'e Descartes," >> ${1}.tex
            echo "67084 Strasbourg, France \\\\" >> ${1}.tex
            echo "Email : massaro@math.unistra.fr}}" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\begin{document}" >> ${1}.tex
            echo "\\maketitle" >> ${1}.tex
            echo "" >> ${1}.tex
            echo "\\end{document}" >> ${1}.tex
        else
            echo "Bad argument"
            cd ..
            rm -r ${2}_$1
        fi
    else
        echo "Bad number argument"
    fi
}

mpifree(){
    mpirun -np $1 FreeFem++-mpi $2
}

gnup(){
    gnuplot -e "set terminal png; set output '${1}.png'; plot '$1' w l"
}

alias cdcdb='cd $HOME/Documents/article_cdb'
cdb(){
    if [ ! -d "$HOME/Documents/article_cdb"  ]; then
        echo "Creation du carnet de bord !"
        stex cdb article
        cd -
        mv article_cdb $HOME/Documents/
    fi
    d=$(date +%d%m%Y-%H%M)
    mkdir $HOME/Documents/article_cdb/images/$d
    sed -i '/end{document}/d' $HOME/Documents/article_cdb/cdb.tex
    echo "\\section{$d}" >> $HOME/Documents/article_cdb/cdb.tex
    echo "" >> $HOME/Documents/article_cdb/cdb.tex
    cat parametres >> $HOME/Documents/article_cdb/cdb.tex
    echo "" >> $HOME/Documents/article_cdb/cdb.tex
    if [ $# -eq 1 ]
    then
        cat $1 | awk '/\\incl/' | awk -vRS="}" -vFS="{" '{print $2}' | awk '/\.png/ || /\.pdf/ || /\.ps/' > tmp
        while read line
        do
            cp $line $HOME/Documents/article_cdb/images/$d/$(echo $line | sed 's/_/-/g')
            sed -i "s/$line/images\/$d\/$line/g" comm
        done < tmp

        sed -i '/incl/s/_/-/g' $1
        cat $1 >> $HOME/Documents/article_cdb/cdb.tex
    fi
    echo "" >> $HOME/Documents/article_cdb/cdb.tex
    echo "\\end{document}" >> $HOME/Documents/article_cdb/cdb.tex
    rm tmp
}

# Premiere lettre du commit en majuscule
function commit {
    git commit -am "`echo "$*" | sed -e 's/^./\U&\E/g'`"
}

extract () {
    if [ -f $1 ]
    then
        case $1 in
            (*.7z) 7z x $1 ;;
            (*.lzma) unlzma $1 ;;
            (*.rar) unrar x $1 ;;
            (*.tar) tar xvf $1 ;;
            (*.tar.bz2) tar xvjf $1 ;;
            (*.bz2) bunzip2 $1 ;;
            (*.tar.gz) tar xvzf $1 ;;
            (*.gz) gunzip $1 ;;
            (*.tar.xz) tar Jxvf $1 ;;
            (*.xz) xz -d $1 ;;
            (*.tbz2) tar xvjf $1 ;;
            (*.tgz) tar xvzf $1 ;;
            (*.zip) unzip $1 ;;
            (*.Z) uncompress ;;
            (*) echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "Error: '$1' is not a valid file!"
        exit 0
    fi
}

#!/bin/bash

function menu_txt(){ #fonction qui permet un affichage textuel d'un menu

choix=0;
b=11
until [ ! "$choix" -lt "$b" ]
do
  echo "
----------------------------------------------------------------------------------------------
1/  Afficher le nom des fichers, les droits d'accès d'un dossier.
2/  Afficher le Type des fichiers d'un dossier passé en argument.
3/  Afficher le Type d'un fichiers passé en argument.
4/  Afficher le help
5/  Afficher un menu graphique
6/  Afficher des statistiques sur le nombre des fichiers et dossiers dans un dossier passé comme argument.
7/  Affiche la version et les noms des auteurs
8/  Afficher le nom des fichers, les droits d'accès et leurs proprietaire d'un dossier passé en argument.
9/  Afficher les droits d'accès, le proprietaire et le groupe d'un ficher passé en argument.
10/ Afficher les utilisateurs qui ont le droit d’écriture d'un fichier passé en argument.
11/  Quitter
-----------------------------------------------------------------------------------------------
"

read -p  "Votre choix :: " choix < /dev/tty
echo " "
if [  "$choix" -lt "$b" ]
then
   case $choix in
1 ) echo "Nombre de dossiers : "
AfficheNbD
echo -e " "
echo "Nombre de fihciers : "
AfficheNbF
echo -e " "
;;
2 )TypeFIle ;;
3 ) TypeFile;;
4 ) HELP;;
5 ) Menu_Graph
;;
6 ) ;;
7 )auteurs;;
8 )AccessFiles
echo -e " "
PropFiles ;;
9 )AccessFile
echo -e " "
PropFile ;;
10 ) Ecriture ;;
* ) echo "Choix invalid"
   esac
fi
done
 exit
}



function auteurs() {
  echo -e "Auteurs : Emna Darragi et Alaa Eddine Belgacem."
  echo -e " "
  echo -e "Version 2.0"
}

function AfficheNbF(){

  cd ~/Desktop/$OPTARG

  # afficher le nombre des dossier : ls -l | grep ^d | wc -l
  ls -l | grep ^- | wc -l >> data.txt
  ls -l | grep ^- | wc -l
}

function AfficheNbD(){

  cd ~/Desktop/$OPTARG

  ls -l | grep ^d | wc -l
}

function TypeFIle(){
  cd ~/Desktop/$OPTARG
  ls -l | grep ^- | cut -f 2 -d '.'
}

function AccessFiles() { #display access rights with file name

    #ls -l | grep ^- | awk '{print $1,  $9}'
    #ls -l | cut -f 1 -d '.'
    cd ~/Desktop/$OPTARG
    ls -l | grep ^- | awk '{print" Nom Du Fichier : " $9, " || Droit D accès : "  $1}'
    #ls -l | grep ^- | cut -d ' ' -f1,12

}

function PropFiles(){
  #ls -l | grep ^- | cut -d ' ' -f3,12
  cd ~/Desktop/$OPTARG
  ls -l | grep ^- | awk '{print" Nom Du Fichier : " $9, " || Proprietaire : "  $3}'
}

#owner ls -l | cut -d ' ' -f3

function stat(){

  gnuplot -persist <<-  EOF
  set title "Clustered bar graph with individual colors\nspecified via plotstyle 'boxes'"
set title  boxed offset 0,-3 font ",15"
set style fill solid border lt -1
set style textbox opaque noborder
set boxwidth 1.0 abs
ClusterSize = 15
unset key

set yrange [0:7]
set xrange [-2:60]
set border 0
category = "Yan Tan Tethera Methera Pimp"
set xtics scale 0 ()
set ytics scale 0 nomirror
set grid y
set colorb horizontal user origin .05, .05 size .9, .05
set palette cubehelix
set bmargin at screen 0.2
set tmargin at screen 0.9

set for [i=1:4] xtics add (word(category,i) 5+(i-1)*ClusterSize)

xcoord(i) =  i*ClusterSize + column(1)
color(i)  = rand(0)

plot for [i=0:3] 'c' \
   using (xcoord(i)):(column(i+2)):(color(i)) with boxes lc palette z
EOF
  #  output = graph.plt
  #  data = data.txt
  #  gnuplot --persist -e "datafile='${data}' ; outputname = '${output}'" graph.plt
}

function HELP()
{
echo `cat HELP.txt`
}

# //////////////////////////////////   ARGUMENT FICHIER ///////////////////////////////////////

function TypeFile()
{
  cd ~/Desktop;
 file --mime-type ${OPTARG}
}

function AccessFile(){
  cd ~/Desktop;
  ls -l ${OPTARG} | awk '{print "Droit D accès : "  $1}'
}

function PropFile() {
  cd ~/Desktop;
  ls -l ${OPTARG} | awk '{print "Proprietaire : "  $3, " || Groupe : " $4}'
}

#-perm /g+w,o+w
#find HELP.txt -printf "%p: %u: %g (%M) \n"
 function Ecriture(){
   cd ~/Desktop
   #command=$(find $OPTARG -perm /u+x,g+x,o+x)
   #command=$(ls -l)
   #echo $command
   if [[ $(find $OPTARG -perm /u+x) ]]; then
     ls -l ${OPTARG} | awk '{print "Utilisateurs : "  $3}'
  else
    echo "auccun utilisateur n'a le droit d'ecriture de ce fichier"
  fi
 }


#/////////////////////////////////////////////////////////////////////////////





function Menu_Graph() #affichage d'un menu graphique avec l'option YAD
{

  champs=$(yad --width=400 --height=400 --title="Donner un dossier ou un fichier" --text-align="center" \
--form \
--field="Dossier:" '' \
--field="Fichier:" '' )
echo "$champs"
#Récupération des champs~/Desktop/${champ1} avec awk.
champ1=$(echo $champs | awk -F'|' '{print $1}')
champ2=$(echo $champs | awk -F'|' '{ print $2 }')
#champ3=$(echo $champs | awk 'BEGIN {FS="|" } { print $3 }')
#Affichage des champs.
echo "$champ1"
#echo "$champ2"




YAD_OPTIONS="--window-icon='dialog-information' --name=IxGestion"

     KEY=$RANDOM


     function show_mod_info {
        TXT="\\n<span face='Monospace'>$(modinfo $1 | sed 's/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g')</span>"
        yad --title=$"Module information" --button="yad-close" --width=500 \
            --image="application-x-addon" --text="$TXT"
    }
    export -f show_mod_info


    # Files tab
    ls -l ~/Desktop/${champ2} | awk '{printf "%s\n%s\n%s\n%s\n", $9,$1,$3,$4}' |\
        yad --plug=$KEY --tabnum=1 --image=drive-harddisk --text=$"Informations sur le fichier en argument" \
            --list --no-selection --column=$"Fichier" --column=$"Droits" --column=$"Proprietaire" --column=$"Groupe" &

    # Repos tab
    ls -l ~/Desktop/${champ1} | grep ^- | awk '{printf "%s\n%s\n%s\n", $9,$1,$3}' |\

        yad --plug=$KEY --tabnum=2 --image=drive-harddisk --text=$"Informations sur les fichiers dans ce repertoires" \
            --list --no-selection --column=$"Nom" --column=$"Droits" --column=$"Proprietaire" &


    # help tab
sed -r "s/:[ ]*/\n/" ~/Desktop/HELP.txt |\
        yad --plug=$KEY --tabnum=3 --image=help --text=$"Help" \
            --text-info =$"content" &

    # Auteurs tab

        yad --plug=$KEY --tabnum=4 --image=help --text=$" Authors : Alaa Eddine Belgacem et Emna Darragi \n Version : 2.0" &



    # main dialog
    TXT=$"<b>Informations sur les répertoires et les fichiers</b>\\n\\n"
    TXT+=$"\\tOS: $(lsb_release -ds) on $(hostname)\\n\\n"
    TXT+=$"\\tVersion de noyau: $(uname -mr)\\n\\n"
    TXT+="\\t<i>$(uptime)</i>"

    yad --notebook --width=1200 --height=500 --title=$"Gestion des repertoires et fichiers" --text="$TXT" --button="close" \
        --key=$KEY  --tab=$"Fichiers" --tab=$"Dossiers" --tab=$"Help" --tab=$"Auteurs"   \
          --active-tab=${1:-1}

}







function show_usage() {
echo "inforep.sh :  [-h|help] [-T] [-t] [-N] [-n] [-d] [-m] [-s]  chemin.."
}
HELP
show_usage ;
if [ $# -gt 0 ]; then

while getopts "hvT:t:A:a:N:n:gm:s:E:" var
do
case $var in
h)HELP
;;
v)auteurs
;;
T)TypeFIle
;;
t)TypeFile
;;
A)AccessFiles
echo -e ""
PropFiles
;;
a)AccessFile
echo -e ""
PropFile
;;
N) echo "Nombre de dossiers : "
AfficheNbD
echo -e " "
echo "Nombre de fihciers : "
AfficheNbF
;;
g)Menu_Graph
;;
m)menu_txt
;;
s)stat
;;
E)Ecriture
;;
*) echo "mauvais argument"
esac
done
else "il faut specifie au moin un argument "
fi

#!/bin/bash

#shopt -s extglob


###################################################################
# Script to create probabilistic dictionaries from aligned text (tmx, csv)
#
# Pablo Gamallo
# ProLNat@GE Group, CiTIUS
# University of Santiago de Compostela
###################################################################

############################
# Config
############################

PROGSDIR=./scripts
TMPDIR=./tmp
FREQDIR=./freq
OUTDIR=./dictionaries

############################
# Functions
############################
help()
{
  echo "Syntax: aligned2dict <format> <lang1> <lang2>  <file> 
      
      languages = gl, es, en, en_GB, pt, ...
      format = tmx, csv
      file = path of the file input 

"
  exit
}


# Parameters
[ $# -lt 4 ] && help
FORMAT=$1 #tmx, csv
LING1=$2 #en, gl,...
LING2=$3
FILE=$4

TOP=10

  
##File with frequencies per segment:
FREQFILE=$FREQDIR"/freq_"${LING1}"-"${LING2}".txt.gz"
#output:
OUTFILE=$OUTDIR/dictionary_$LING1-$LING2.txt


if [ "$FORMAT" == "none" ]  ; then
  FORMAT = "tmx"
fi

if  [ "$FORMAT" == "tmx" ]  ; then
    echo "1. Creating files with frequencies per segment"
    echo $FILE
    echo $LING1
    echo $LING2
    cat $FILE | $PROGSDIR/read_tmx.perl $LING1 $LING2 | gzip -c > $FREQFILE
fi

if  [ "$FORMAT" == "csv" ]  ; then
    echo "1. Creating files with frequencies per segment"
    cat $FILE | $PROGSDIR/read_csv.perl $LING1 $LING2 | gzip -c > $FREQFILE
fi

########################

#rm __filePares* 2>/dev/null
#rm $TMPDIR/*     2>/dev/null


echo "2. pairs of words to compare"


#zcat  $FREQFILE  |$PROGS/juntarFreqsComFiltroPals.perl $TH  >atribs_tmp
zcat  $FREQFILE  > $TMPDIR/atribs_tmp
cat $TMPDIR/atribs_tmp | $PROGSDIR/joinWordsByCntx.perl > $TMPDIR/__tmpPares
$PROGSDIR/pares_toNfilesBil.perl 10 $LING1 $LING2  $TMPDIR/__filePares $TMPDIR/__tmpPares 

echo "3. sorting bilingual pairs"

for i in $TMPDIR/__filePares*; do 
  BASE=`basename $i`;
  zcat $i |sort |uniq -c |awk '($1 >= 1) {print $2, $3}' |gzip -c >$TMPDIR/uniq$BASE;
done

#rm $TMPDIR/__filePares*  2>/dev/null

echo "4. computing similarity"

for j in $TMPDIR/uniq*; do
   ARQ=`basename $j| sed s/__filePares//`;
   
  zcat $j| $PROGSDIR/measures.perl $TMPDIR/atribs_tmp  | gzip -c > $TMPDIR/simil_$ARQ.txt.gz ;

done

echo "5. Final process: generating bilingual dictionary"

zcat $TMPDIR/simil_* |$PROGSDIR/jaccard_toNfiles.perl 10 $TMPDIR/__quase_

#rm $TMPDIR/$PREFFILE*  2>/dev/null

#echo "5. volta a juntar os ficheiros - gera N melhores..."

rm $OUTFILE
for k in $TMPDIR/__quase_*  ; do
 #   echo $k;
    zcat $k |gawk '{print $1, $2, $3}' |$PROGSDIR/Nbest.perl $TOP >>   $OUTFILE
done

echo "Dictionary file saved in ./dictionaries folder"
rm $TMPDIR/*  2>/dev/null

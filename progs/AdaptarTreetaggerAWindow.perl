#!/usr/bin/perl -w

##Entrada: saida do TreeTagger português
##Saida: entrada do parsingCascataByRegularExpressions.perl


$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310Ñ]" ;
$LowerCase = "[a-záéíóúàèìòùçãõñ]" ;



while (<>) {
   chop($_);

   if ( ($_ eq "") || ($_ =~ /^<[^ ]*>$/) ) {
      next
   }

  else {

     ($pal, $tag, $lema) = split("\t", $_);



   #se temos um possível nome próprio (desconhecido ou com lema em minuscula), colocar a forma no lema (para conservar a maiuscula)
   if ( ($pal =~ /\&/) || ($lema =~ /<unknown>/) ) {
         $lema = $pal;
   }
   elsif ( ($tag =~ /^N/) && ($pal =~ /^$UpperCase/) && ($lema =~ /^$LowerCase/) ) {
         $lema = $pal;
   }

   ##mudar pontuacao:
   if ( ($tag =~ /^SENT/) || ($tag =~ /^VIRG/) ) {
        $tag = "Fp";
   }

   ##muda tags:

   elsif ($tag =~ /^N/) {
     $tag = "NOM";
   }

   elsif ($tag =~ /^RB/) {
     $tag = "ADV";
   }

   elsif ($tag =~ /^JJ/) {
     $tag = "ADJ";
   }

   elsif ( ($tag =~ /^VB/) || ($tag =~ /^MD/) )  {
     $tag = "V";
   }


   #elimina dets e preps

   if ( ($tag =~ /^PRP/) || ($tag =~ /^DET/) ||
        ($tag eq "IN") || ($tag eq "TO") || ($tag eq "RP") || ($tag =~ /DT/) )     {
 
   }


   ##elimina aspas
   elsif   ($tag =~ /^QUOTE/)  {
   }
   else {
      print "$pal $lema $tag\n";
   }

 }
}




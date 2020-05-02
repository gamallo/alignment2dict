#!/usr/bin/perl -w

##Entrada: saida do TreeTagger português
##Saida: entrada do parsingCascataByRegularExpressions.perl


$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310Ñ]" ;
$LowerCase = "[a-záéíóúàèìòùçãõñ]" ;

## Lexemas gramaticais especiais:
$AUX="(have|avoir|haber|haver)";
$COP="(be|être|ser)";
$VERY="(very|more|less|quite|muy|bastante|más|menos|poco|máis|mais|pouco|muito|moi|mui|très|peu|assez|plus|moins)";
$PARTITIVO="(de|of)";
$CONJSUB="that";

$COP="be|être|paraître|ser|estar|parecer|semellar|resultar";

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

   #mudar tags:

   ##pronomes:
   if ($tag =~ /^PP/) {
         $tag = "PN";
   }

    ##relativo:
   elsif ($tag =~ /(^WDT|^WP)/) {
         $tag = "PR";
   }


   # numero, adj, adv, particles (RP), prep, nom, det, conjsub
   elsif ($tag =~  /CARD/) {
         $lema = "\@card\@";
   }

   elsif ($tag =~ /^N/) {
     $tag = "NOM";
   }

   elsif ( ($tag =~ /^RB/) || ($tag =~ /^JJR/) ) {
      if ($pal =~ /^$VERY$/) {
        $tag = "ADVQ"; ##quantificador de adj ou adv
      }
      else {
        $tag = "ADV"
      }
   }
   elsif ($tag =~ /^RP/) {
     $tag = "PCLE";
   }

   elsif ($tag =~ /^JJ/) {
     $tag = "ADJ";
   }

   elsif ($tag =~ /(^IN|^TO)/) {
      if ($lema =~ /^$PARTITIVO$/) {
        $tag = "PRPP";
      }
      if ($lema =~ /^$CONJSUB/) {
        $tag = "CS";
      }
      else {
        $tag = "PRP"
      }
   }


   elsif ($tag =~ /DET/) {
        $tag = "DT";
   }





 ##mudar tags nos verbos:
   if ($tag =~ /^VB/) {

     if ($tag =~ /^VBN/ ) {
        $tag = "VERBP";
     }
     elsif ($tag =~ /^VB$/ ) {
        $tag = "VERBI";
     }
     if ($tag =~ /^VBG/ ) {
        $tag = "VERBG";
     }
     elsif ($tag =~ /^VB/) {
        $tag = "VERBF";
     }

     if ($lema =~ /^$AUX$/) {
        $tag = $tag . "AUX";
     }
     if ($lema =~ /^$COP$/) {
        $tag = $tag . "COP";
     }
   }
   ##mudar modais
    if ($tag =~ /^MD/ ) {
        $tag = "VERBF";
   }
   ##mudar auxiliares e compulativos



    ##finais de frase (!?.)
    #if   ( ($tag =~ /^Fat/) || ($tag =~ /^Fit/) ||
     #	   ($tag =~ /^Fp/) ) {
     #      $tag = "SENT";
    #}
    ##final de frase (.)
#    if	   ($tag =~ /^Fp/)  {
 #          $tag = "SENT";
  # }




   ##elimina aspas
   if   ($tag =~ /^QUOTE/)  {
   }
   else {
      print "$pal $lema $tag\n";
   }

 }
}


##as conjunçoes seguem a ser CS (subord) e CC (coordenada)

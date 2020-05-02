#!/usr/bin/perl -w

##Entrada: saida do TreeTagger frances
##Saida: entrada do parsingCascataByRegularExpressions.perl


$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310Ñ]" ;
$LowerCase = "[a-záéíóúàèìòùçãõñaâêîôû]" ;

## Lexemas gramaticais especiais:
$AUX="(have|avoir|haber|haver)";
$COP="(be|être|ser)";
$VERY="(very|more|less|quite|muy|bastante|más|menos|poco|máis|mais|pouco|muito|moi|mui|très|peu|assez|plus|moins)";
$PARTITIVO="(de|of)";

#$COP="be|être|paraître|ser|estar|parecer|semellar|resultar";

while (<>) {
   chop($_);

   if ($_ eq "") {
      next
   }

  else {
     
     ($pal, $tag, $lema) = split("\t", $_);
     

   ##correcçoes ad hoc de problemas de etiquetaçao:

   if ($lema =~ /suivre\|être$/)   {
           $lema = "être"
   }

   ## o lema "du" passa a "de" e "au" a "à":
   if ($lema eq "du") {
       $lema = "de"
   }
   elsif ($lema eq "au") {
      $lema = "à"
   }

   #se temos um possível nome próprio (desconhecido ou com lema em minuscula), colocar a forma no lema (para conservar a maiuscula)
   if ( ($pal =~ /\&/) || ($lema =~ /<unknown>/) ) {
         $lema = $pal;
   }
   elsif ( ($tag =~ /^NOM/) && ($pal =~ /^$UpperCase/) && ($lema =~ /^$LowerCase/) ) {
         $lema = $pal;
   }

   #mudar tags:

   ##pronomes:
   if ($tag =~ /^PRO/) {
     if ( ($tag =~ /(IND|DEM)/) && ($lema =~ /(quelques$|^ce$|^cet|^ces$)/) ) {
         $tag = "DT" ;
     }
     elsif ($tag =~ /REL/) {
        $tag = "PR";
      }
     else{
         $tag = "PN";
     }

   } 
      

   # numero, adj, adv, prep, nom, det, conjsub, nome proprio
   if ($tag =~  /(CARD|^NUM$)/) {
         $lema = "\@card\@";
   }


   elsif ($tag =~ /^ADV/) {
      if ($pal =~ /^$VERY$/) {
        $tag = "ADVQ"; ##quantificador de adj ou adv
      }
   }

  
  elsif  ($tag =~ /^PRP/) {
      if ($lema =~ /^$PARTITIVO$/) {
        $tag = "PRPP";
      }
      else {
        $tag = "PRP"
      }
   }


   elsif ($tag =~ /^DET/) {
        $tag = "DT";
   }
  
   elsif ( ($tag =~ /^KON/) && ($lema eq "que") ) {
        $tag = "CS";
   }
   elsif ($tag =~ /^NAM/) {
        $tag = "NOM";
   }
  

 ##mudar tags nos verbos:
   if ($tag =~ /^V/) {

     if ($tag =~ /:pper/) {
        $tag = "VERBP";
     }
     elsif ($tag =~ /:infi/) {
        $tag = "VERBI";
     }
     elsif ($tag =~ /:ppre/) {
        $tag = "VERBG";
     }
     elsif ($tag =~ /^V/) {
        $tag = "VERBF";
     }

     if ($lema =~ /^$AUX$/) {
        $tag = $tag . "AUX";
     }
     if ($lema =~ /^$COP$/) {
        $tag = $tag . "COP";
     }
   }


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

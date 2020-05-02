#!/usr/bin/perl -w

##Entrada: saida do TreeTagger espanhol
##Saida: entrada do parsingCascataByRegularExpressions.perl


#$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310Ñ]" ;
#$LowerCase = "[a-záéíóúàèìòùçãõñaâêîôû]" ;

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
     



   ## o lema "del" passa a "de" e "al" a "a":
   if ($lema eq "del") {
       $lema = "de";
       $tag = "PREP";
   }
   elsif ($lema eq "al") {
      $lema = "a";
      $tag = "PREP";
   }

   #se temos um possível nome próprio (desconhecido ou com lema em minuscula), colocar a forma no lema (para conservar a maiuscula)
   if ( ($pal =~ /\&/) || ($lema =~ /<unknown>/) ) {
         $lema = $pal;
   }
  # elsif ( ($tag =~ /^NP/) && ($pal =~ /^$UpperCase/) && ($lema =~ /^$LowerCase/) ) {
  #       $lema = $pal;
  # }

   #mudar tags:

   

   # numero, adj, adv, prep, nom, det, conjsub, nome comum e proprio
   if ($tag =~  /(CARD|^NUM$)/) {
         $lema = "\@card\@";
   }


   elsif ($tag =~ /(^ADV|^NEG)/) {
      if ($pal =~ /^$VERY$/) {
        $tag = "ADVQ"; ##quantificador de adj ou adv
      }
      else {
        $tag = "ADV";
      }
   }

  
  elsif  ($tag =~ /^PREP/) {
      if ($lema =~ /^$PARTITIVO$/) {
        $tag = "PRPP";
      }
      else {
        $tag = "PRP"
      }
   }


   elsif  ($tag =~ /(^ART|^DM|^ORD|^QU|^PPO)/) {
        $tag = "DT";
   }
  
   elsif ($tag =~ /^CQUE/) {
        $tag = "CS";
   }
   elsif ($tag =~ /(^NP|NC)/) {
        $tag = "NOM";
   }
  


  ##pronomes (personais, reflexivos, interrogativos, relativos):
   if ( ($tag =~ /^PP/) || ($tag =~ /^INT/)) {
     
      $tag = "PN";
    
   }
   elsif ($tag =~ /REL/) {
        $tag = "PR";
   }
   elsif ($tag =~ /^SE/) { 
      $tag = "PREFL";
   }
  
      

 ##mudar tags nos verbos:
   if ($tag =~ /^V/) {

     if ($tag =~ /adj/) {
        $tag = "VERBP";
     }
     elsif ($tag =~ /inf/) {
        $tag = "VERBI";
     }
     elsif ($tag =~ /ger/) {
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
    if	   ($tag =~ /^FS/)  {
           $tag = "SENT";
   }




   ##elimina aspas
   #if   ($tag =~ /^QT/)  {
   #}
   #else {
    #  print "$pal $lema $tag\n";
   #}

    print "$pal $lema $tag\n";
 }
}


##as conjunçoes seguem a ser CS (subord) e CC (coordenada)

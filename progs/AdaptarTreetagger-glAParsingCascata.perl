#!/usr/bin/perl -w

##Entrada: saida do TreeTagger portugu�s
##Saida: entrada do parsingCascataByRegularExpressions.perl


#$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310�]" ;
#$LowerCase = "[a-z��������������]" ;

## Lexemas gramaticais especiais:
$AUX="(have|avoir|haber|haver)";
$COP="(be|�tre|ser)";
$VERY="(very|more|less|quite|muy|bastante|m�s|menos|poco|m�is|mais|pouco|muito|moi|mui|tr�s|peu|assez|plus|moins)";
$PARTITIVO="(de|of)";

#$COP="be|�tre|para�tre|ser|estar|parecer|semellar|resultar";

while (<>) {
   chop($_);

   if ($_ eq "") {
      next
   }

  else {

     ($pal, $tag, $lema) = split("\t", $_);

   ##correc�oes ad hoc de problemas de etiqueta�ao:

   if ( ($lema =~ /^pol[oa](s?)$/) && ($tag =~ /^PRP/) ) {
           $lema = "por"
   }


   #se temos um poss�vel nome pr�prio (desconhecido ou com lema em minuscula), colocar a forma no lema (para conservar a maiuscula)
   if ( ($pal =~ /\&/) || ($lema =~ /<unknown>/) ) {
         $lema = $pal;
   }
#   elsif ( ($tag =~ /^NOM/) && ($pal =~ /^$UpperCase/) && ($lema =~ /^$LowerCase/) ) {
 #        $lema = $pal;
 #  }

   #mudar tags:

   ##pronomes:
   if ($tag eq "P") {
         $tag = "PN";
   } 
      

   # numero, adj, adv, prep, nom, det, conjsub
   if ($tag =~  /CARD/) {
         $lema = "\@card\@";
   }


   elsif ($tag =~ /^ADV/) {
      if ($pal =~ /^$VERY$/) {
        $tag = "ADVQ"; ##quantificador de adj ou adv
      }
   }


   elsif ($tag =~ /^PRP/) {
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
  
    elsif ($tag =~ /^CONJSUB/) {
        $tag = "CS";
   }

  

 ##mudar tags nos verbos:
   if ($tag =~ /^V/) {

     if ($pal =~ /[ai]d[ao](s?)$/) {
        $tag = "VERBP";
     }
     elsif ($pal =~ /[aei]r$/) {
        $tag = "VERBI";
     }
     elsif ($pal =~ /[aei]ndo$/) {
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
 #  if   ($tag =~ /^QUOTE/)  {
 #  }
 #  else {
      print "$pal $lema $tag\n";
 #  }

 }
}


##as conjun�oes seguem a ser CS (subord) e CC (coordenada)
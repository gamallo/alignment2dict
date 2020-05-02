#!/usr/bin/perl -w

##Entrada: saida do Freeling
##Saida: entrada do parsingCascataByRegularExpressions.perl


## Lexemas gramaticais especiais:
$AUX="(have|avoir|ter|haber|haver)";
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
     #troca do simbolo de composicao tipico de Freeling
     s/\_/\&/g ;

     ($pal, $lema, $tag) = split(" ", $_);

   ##correcçoes ad hoc de problemas de etiquetaçao:

   if ( ($lema =~ /^pol[oa](s?)$/) && ($tag =~ /^SP/) ) {
           $lema = "por"
   }


    #se temos um NP (nome proprio), colocar a forma no lema (para conservar a maiuscula)

   if ($tag =~ /^NP/) {
         $lema = $pal;
   }

   #mudar tags:

   ##pronomes:
   if ($tag =~ /^P/) {
      if ($tag =~ /^P[PDXITNE]/) {
         $tag = "PN";
      } 
      elsif ($tag =~ /^PR/)  {
         $tag = "PR";
      } 
      elsif ($tag =~ /^P0/)  {
         $tag = "PREFL";
      } 
    }

   # numero, adj, adv, prep, nom, det
   if ($tag =~  /^Z/) {
         $tag = "CARD";
         $lema = "\@card\@";
   }

   elsif ($tag =~ /^A/) {
         $tag = "ADJ";
   }


   elsif ($tag =~ /^R/) {
      if ($pal =~ /^$VERY$/) {
        $tag = "ADVQ"; ##quantificador de adj ou adv
      }
      else{
          $tag = "ADV";
	}
   }


   elsif ($tag =~ /^SP/) {
      if ($lema =~ /^$PARTITIVO$/) {
        $tag = "PRPP";
      }
      else {
        $tag = "PRP"
      }
   }


   elsif ($tag =~ /^N/) {
        $tag = "NOM";
   }

   elsif ($tag =~ /^D/) {
        $tag = "DT";
   }

  

 ##mudar tags nos verbos:
   if ($tag =~ /^V/) {

     if ($tag =~ /^V[MSA]P/) {
        $tag = "VERBP";
     }
     elsif ($tag =~ /^V[MSA]N/) {
        $tag = "VERBI";
     }
     elsif ($tag =~ /^V[MSA]G/) {
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
    if	   ($tag =~ /^Fp/)  {
           $tag = "SENT";
   }

   


   ##elimina aspas
   if   ( ($tag =~ /^Fra/) || ( $tag =~ /^Frc/) || 
          ($tag eq "Fe") ) {
   }
   else {
      print "$pal $lema $tag\n";
   }

 }
}


##as conjunçoes seguem a ser CS (subord) e CC (coordenada)

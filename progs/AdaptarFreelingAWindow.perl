#!/usr/bin/perl -w

##Entrada: saida do TreeTagger português
##Saida: entrada do parsingCascataByRegularExpressions.perl


#$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310Ñ]" ;
#$LowerCase = "[a-záéíóúàèìòùçãõñ]" ;



while (<>) {
   chop($_);

   if ( ($_ eq "") || ($_ =~ /^<[^ ]*>$/) ) {
      next
   }

  else {

     ($pal, $lema, $tag) = split(" ", $_);

    ##muda tags:

   if ($tag =~ /^N/) {
     $tag = "NOM";
   }

   elsif ($tag =~ /^RB/) {
     $tag = "ADV";
   }

   elsif ($tag =~ /^A/) {
     $tag = "ADJ";
   }

   elsif ($tag =~ /^V/ )  {
     $tag = "V";
   }


   #elimina dets e preps

   if ( ($tag =~ /^SP/) || ($tag =~ /^D/)  )     {

   }


   ##elimina aspas
  # elsif   ($tag =~ /^QUOTE/)  {
 #  }
   else {
     print "$pal $lema $tag\n";
   }



 }
}




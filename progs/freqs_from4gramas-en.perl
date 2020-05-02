#!/usr/bin/perl

#GERA OS CONTEXTOS, AS PALAVRAS E AS FREQUENCIAS 
#lê os 4gramas etiquetados e desambiguados. 
#Coloca a marca de lingua em cada palavra e contexto.

use progs::funcoes::categorias


#$L=shift(@ARGV);

$CountLine=0;
while ($line = <>) {
    $p1 = "";
    $p2 = "";
    $p3 = "";
    $p4 = "";
    $tag1 = "";
    $tag2 = "";
    $tag3 = "";
    $tag4 = "";
    

   if ( ($CountLines % 100) == 0) {;
       printf  STDERR "- - - processar linha:(%6d) - - -\r",$CountLines;
    }
    $CountLines++;
    

    chop($line);

    ($p1, $p2, $p3, $p4) = split(" ", $line);



    if ($p1 =~ /\_/) {
         ($p1, $tag1) = split ('\_', $p1);
         if (Prep($tag1) ) {
            $IsPrep{$p1}++;
	 }

         if  (Nome($tag1) ) {
            $IsName{$p1}++;
	  }

         if  (Num($tag1) ) {
            $IsNum{$p1}++;
	  }

         if (Mod($tag1) ) {
            $IsMod{$p1}++;
	 }

         if (VPP ($tag1) ) {
            $IsVPP{$p1}++;
         }
         
         if  (Verbo ($tag1) ) {
            $IsVerb{$p1}++;
          }

         if (Adj($tag1) ) {
            $IsAdj{$p1}++;
	 }

# print STDERR "$p1 - $tag1\n";
      }



      if ($p2 =~ /\_/) {
        ($p2, $tag2) = split ('\_', $p2);
        if (Prep($tag2) ) {
            $IsPrep{$p2}++;
	 }

         if  (Nome($tag2) ) {
            $IsName{$p2}++;
	  }

         if  (Num($tag2) ) {
            $IsNum{$p2}++;
	  }

         if (Mod($tag2) ) {
            $IsMod{$p2}++;
	 }
 
         if (VPP ($tag2) ) {
            $IsVPP{$p2}++;
         }

         if  (Verbo ($tag2) ) {
            $IsVerb{$p2}++;
          }

         if (Adj($tag2) ) {
            $IsAdj{$p2}++;
	 }

     }

      if ($p3 =~ /\_/) {
        ($p3, $tag3) = split ('\_', $p3);

          if (Prep($tag3) ) {
            $IsPrep{$p3}++;
	 }

         if  (Nome($tag3) ) {
            $IsName{$p3}++;
	  }

         if  (Num($tag3) ) {
            $IsNum{$p3}++;
	  }

         if (Mod($tag3) ) {
            $IsMod{$p3}++;
	 }

         if (VPP ($tag3) ) {
            $IsVPP{$p3}++;
         }

         if  (Verbo ($tag3) ) {
            $IsVerb{$p3}++;
         }

         if (Adj($tag3) ) {
            $IsAdj{$p3}++;
	 }
       

      }

      if ($p4 =~ /\_/) {
        ($p4, $tag4) = split ('\_', $p4);
        
          if (Prep($tag4) ) {
            $IsPrep{$p4}++;
	 }

         if  (Nome($tag4) ) {
            $IsName{$p4}++;
	  }

         if  (Num($tag4) ) {
            $IsNum{$p4}++;
	  }

         if (Mod($tag4) ) {
            $IsMod{$p4}++;
	 }

         if (VPP ($tag4) ) {
            $IsVPP{$p4}++;
         }

         if  (Verbo ($tag4) ) {
            $IsVerb{$p4}++;
          }

         if (Adj($tag4) ) {
            $IsAdj{$p4}++;
	 }
      }





##REGRAS COM NOUN-PREP (pulamos os modificadores)
     if ( (defined $IsPrep{$p2}) && (defined $IsMod{$p3}) && (defined $IsName{$p1}) && (defined $IsName{$p4}) ){
         
            $conRight{$p1,$p2,$p4}++;
     }
     elsif ( (defined $IsPrep{$p2}) && (defined $IsName{$p1}) && (defined $IsName{$p3}) ) {
         
             $conRight{$p1,$p2,$p3}++;
     }
     elsif ( (defined $IsPrep{$p3}) && (defined $IsMod{$p2}) && (defined $IsName{$p1}) && (defined $IsName{$p4}) ){
        #  print STDERR "okkk\n";
         
            $conRight{$p1,$p3,$p4}++;
     }

     elsif ( (defined $IsPrep{$p2}) && (defined $IsName{$p1}) && (defined $IsNum{$p3}) ) {
         
            $conRight{$p1,$p2,$tag3}++;
     }


##REGRAS COM NOUN-NOUN para o inglês (nao pulamos os modificadores)
    if ((defined $IsName{$p1}) && (defined $IsName{$p2}) ) {
            $NRight{$p2,$p1}++;
     }

##REGRAS COM NOUN-NOUN para linguas latinas (nao pulamos os modificadores)
  #   if ((defined $IsName{$p1}) && (defined $IsName{$p2}) ) {
     #        $NRight{$p1,$p2}++;
    # }


##REGRAS COM NOUN-ADJ (adj) pulamos os adverbios-modificadores
     
     if ( (defined $IsAdj{$p2}) && (defined $IsName{$p1}) ){
         
            $Right{$p1,$p2}++;
     }
     elsif ( (defined $IsAdj{$p3}) && (defined $IsMod{$p2}) && 
          (defined $IsName{$p1}) ){
         
            $Right{$p1,$p3}++;
     }
     elsif ( (defined $IsName{$p2}) && (defined $IsAdj{$p1}) ) {
             $Left{$p2,$p1}++;
     }

     elsif ( (defined $IsNum{$p2}) && (defined $IsName{$p1}) ){
         

            $Right{$p1,$tag2}++;

     }


##REGRAS COM VERB-NOUN e NOUN-VERB (pulamos os modificadores)

      

     if ( (defined $IsVerb{$p1}) && (defined $IsMod{$p2}) && (defined $IsName{$p3}) ){

             $VRight{$p1,$p3}++;
     }
     elsif ( (defined $IsVerb{$p1}) && (defined $IsName{$p2}) ){
             $VRight{$p1,$p2}++;
     }

      ##regras do VPP (se aparece o nome à esquerda, vai para a direita)

      if ( (defined $IsName{$p1}) && (defined $IsMod{$p2}) && (defined $IsVPP{$p3}) ){
            $VRight{$p3,$p1}++;
     }
     elsif ( (defined $IsName{$p1}) && (defined $IsVPP{$p2}) ){
            $VRight{$p2,$p1}++;
     }

     ##regras tipicas do sujeito:
     if ( (defined $IsName{$p1}) && (defined $IsMod{$p2}) && (defined $IsVerb{$p3}) ){
            $VLeft{$p3,$p1}++;
     }
     elsif ( (defined $IsName{$p1}) && (defined $IsVerb{$p2}) ){
            $VLeft{$p2,$p1}++;
     }

##REGRAS COM VERB-PREP-NOUN (pulamos os modificadores)
     if ( (defined $IsVerb{$p1}) && (defined $IsPrep{$p2}) && (defined $IsMod{$p3}) && (defined $IsName{$p4}) ){
           $VconRight{$p1,$p2,$p4}++;
     }
     elsif ( (defined $IsVerb{$p1}) && (defined $IsPrep{$p2}) && (defined $IsName{$p3}) ){
           $VconRight{$p1,$p2,$p3}++;

     }



 



    delete $IsPrep{$p1};
    delete $IsPrep{$p2};
    delete $IsPrep{$p3};
    delete $IsPrep{$p4};

    delete $IsName{$p1} ;
    delete $IsName{$p2};
    delete $IsName{$p3};
    delete $IsName{$p4};

    delete $IsNum{$p1} ;
    delete $IsNum{$p2};
    delete $IsNum{$p3};
    delete $IsNum{$p4};

    delete $IsMod{$p1};
    delete $IsMod{$p2};
    delete $IsMod{$p3};
    delete $IsMod{$p4};

    delete $IsAdj{$p1};
    delete $IsAdj{$p2};
    delete $IsAdj{$p3};
    delete $IsAdj{$p4};

    delete $IsVerb{$p1};
    delete $IsVerb{$p2};
    delete $IsVerb{$p3};
    delete $IsVerb{$p4};

    delete $IsVPP{$p1};
    delete $IsVPP{$p2};
    delete $IsVPP{$p3};
    delete $IsVPP{$p4};


}





print STDERR "fim leitura das ocurrencias em 4gramas\n";
 

foreach $key (sort keys %conRight) {
  ($p1, $p2, $p3) = split (/$;/o, $key);
     if ($conRight{$p1,$p2,$p3}>0) {
       printf "%s_down_%s %s %d\n", $p2, $p1, $p3, $conRight{$p1,$p2,$p3};
       print STDERR "trigram: $p1-$p2-$p3\n";
        printf "%s_up_%s %s %d\n", $p2, $p3, $p1,  $conRight{$p1,$p2,$p3};
     }

}


foreach $key (sort keys %NRight) {
  ($p1, $p2) = split (/$;/o, $key);
     if ($NRight{$p1,$p2}>0) {
       printf "modN_down_%s %s %d\n", $p1, $p2, $NRight{$p1,$p2} ;
       print STDERR "bigram: $p1-modN-$p2\n";
        printf "modN_up_%s %s %d\n", $p2, $p1, $NRight{$p1,$p2} ;
     }

}


foreach $key (sort keys %Right) {
  ($p1, $p2) = split (/$;/o, $key);
     if ($Right{$p1,$p2}>0) {
       printf "Rmod_down_%s %s %d\n", $p1, $p2, $Right{$p1,$p2};
       print STDERR "bigram: $p1-AdjR-$p2 = $Right{$p1,$p2}\n";
        printf "Rmod_up_%s %s %d\n", $p2, $p1, $Right{$p1,$p2};
     }

}


foreach $key (sort keys %Left) {
  ($p1, $p2) = split (/$;/o, $key);
     if ($Left{$p1,$p2}>0) {
       printf "Lmod_down_%s %s %d %s\n", $p1, $p2,  $Left{$p1,$p2} ;
       print STDERR "bigram: $p1-AdjL-$p2 = $Left{$p1,$p2} \n";
       printf "Lmod_up_%s %s %d\n", $p2, $p1, $Left{$p1,$p2};
     }

}


foreach $key (sort keys %VconRight) {
  ($p1, $p2, $p3) = split (/$;/o, $key);
     if ($VconRight{$p1,$p2,$p3}>0) {
       printf "iobj&%s_down_%s %s %d\n", $p2, $p1, $p3, $VconRight{$p1,$p2,$p3};
       print STDERR "verb-trigrama: $p1-$p2-$p3\n";
        printf "iobj&%s_up_%s %s %d\n", $p2, $p3, $p1,  $VconRight{$p1,$p2,$p3} ;
     }

}


foreach $key (sort keys %VRight) {
  ($p1, $p2) = split (/$;/o, $key);
     if ($VRight{$p1,$p2}>0) {
       printf "Robj_down_%s %s %d\n", $p1, $p2, $VRight{$p1,$p2};
       print STDERR "bigram: $p1-VerbR-$p2\n";
        printf "Robj_up_%s %s %d\n", $p2, $p1, $VRight{$p1,$p2} ;
     }

}

foreach $key (sort keys %VLeft) {
  ($p1, $p2) = split (/$;/o, $key);
     if ($VLeft{$p1,$p2}>0) {
       printf "Lobj_down_%s %s %d\n", $p1, $p2, $VLeft{$p1,$p2} ;
       print STDERR "bigram: $p1-VerbL-$p2\n";
        printf "Lobj_up_%s %s %d\n", $p2, $p1, $VLeft{$p1,$p2} ;
     }

}

print  STDERR "o ficheiro de contextos - palavra - freq  foi gerado\n";

#!/usr/bin/perl -w

###ATEN�AO: SO PARA LINGUAS ROMANCES. NO CASO DO INGLES E PRECISO MUDAR A REGRA NOME-NOME!!!!!

#fronteira de frase:
$Border="SENT";

#atalhos de etiquetas-idf:
$ADJ ="ADJ_[0-9]+";
$NOM="NOM_[0-9]+";
$PRP="PRP(?:P?)_[0-9]+";
$PRPP="PRPP_[0-9]+";
$ADV="ADV(?:Q?)_[0-9]+";
$ADVQ="ADVQ_[0-9]+";
$CARD="CARD_[0-9]+";
$CS="CS_[0-9]+";
$DT="DT_[0-9]+";
$P="P[NR]_[0-9]+";
$PR="PR_[0-9]+";
$PREFL="PREFL_[0-9]+";

$VERB="VERB._[0-9]+";
$VERBF="VERBF_[0-9]+"; ##forma finita
$VERBN="VERB[PIG]_[0-9]+"; ##forma nao-finita
$VERBP="VERBP(?:AUX|COP)*_[0-9]+"; ##participio
$VAUX="VERB.AUX_[0-9]+";
$VCOP="VERB.COP_[0-9]+";
$AUX="AUX_[0-9]+";
#$COP="COP_[0-9]+";

##super atalhos:
$N="$NOM|$P|$CARD";


$i=0;
$listTags="";
#$tmp="";
$seq="";
$CountLines=0;

$i=0;
while (<>) {
   chop($_);

  ($pal, $lema, $tag) = split(" ", $_);

  if ( ($CountLines % 100) == 0) {;
       printf  STDERR "- - - processar linha:(%6d) - - -\r",$CountLines;
  }
  $CountLines++;

   ##construimos os vectores da ora�ao
   if ($tag ne $Border) {
     $Pal[$i] = $pal;
     $Lema[$i] = $lema;
     $Tag[$i] = $tag;
     $i++;
     #print STDERR "$i\r";
   }

   elsif ($tag eq $Border) {
     print "\n";

     ##construimos os strings com a lista de tags e os lemas-tags da ora�ao
     for ($i=0;$i<=$#Lema;$i++) {

       $listTags .= "$Tag[$i]_$i" ;
       $seq .= "$Lema[$i]_$Tag[$i]_$i" . " ";
       
	 
      }##fim do for
      $seq .= "\." . "_" . $Border ;
      ##Escrever a ora�ao que vai ser analisada:
      print "SENT::<$seq>\n";
     # print STDERR  "$listTags\n";

###REGRAS DO "VERY-QUITE-MORE" (ADVQ): (eliminamos o adverbioQ)

##########Regra subs: very ADJ|ADV -> ADJ
########## muy bonito -> bonito
      (@temp) = ($listTags =~ /($ADVQ)($ADJ|$ADV)/g);
       $listTags =~ s/($ADVQ)($ADJ|$ADV)/$2/g ; 
       $Rel =  "AdjnL" ;
       DepHead($Rel, @temp);
#########Fim regra

###FIM REGRAS DO VERY

###REGRAS DO "VERY-QUITE-MORE" (ADVQ): (eliminamos o adverbioQ)



###REGRAS DO SV + SUBS (eliminamos o auxiliar e o modal)


##########Regras reflexivo: PREFL VERB -> VERB
########## se arrodilla -> arrodilla
      (@temp) = ($listTags =~ /($PREFL)($VERB)/g);
       $listTags =~ s/($PREFL)($VERB)/$2/g ; 
       $Rel =  "Spec" ;
       DepHead($Rel, @temp);
#########Fim regra
##########Regras reflexivo: VERB PREFL -> VERB
########## arrodillarse -> arrodilla
      (@temp) = ($listTags =~ /($VERB)($PREFL)/g);
       $listTags =~ s/($VERB)($PREFL)/$1/g ; 
       $Rel =  "Spec" ;
       HeadDep($Rel, @temp);
#########Fim regra


#######Regras de AUX e PASSIVE::

##########Regra subs: VERB1(cop) VPP2 -> VERB2 
########## fui comido -> comer (em vpp)
      (@temp) = ($listTags =~ /($VCOP)(?:$ADV)*($VERBP)/g);
       $listTags =~ s/($VCOP)(?:$ADV)*($VERBP)/PASSIVE$2/g ; 
       $Rel =  "PASSIVE" ;
       DepHead($Rel, @temp);
#########Fim regra

##########Regra subs: VERB1(aux) VPASSIVE2 -> VERB2  
########## he PASSIVE_comido -> comer (em vpp) 
      (@temp) = ($listTags =~ /($VAUX)(?:$ADV)*PASSIVE($VERBP)/g) ;
       $listTags =~ s/($VAUX)(?:$ADV)*PASSIVE($VERBP)/$2/g;
       $Rel =  "AUX" ;
       DepHead($Rel, @temp);
#########Fim regra


##########Regra subs: VERB1(aux) VPP2 -> VERB2 (com o tempo do aux)
########## he comido -> comer (forma do aux) 
      (@temp) = ($listTags =~ /($VAUX)(?:$ADV)*($VERBP)/g);
      $listTags =~ s/(VERB.)($AUX)(?:$ADV)*(VERBP(?:AUX|COP)*\_)([0-9]+)/$1\_$4/g;
       $Rel =  "AUX" ;
       DepHead($Rel, @temp);
#########Fim regra     

      $listTags =~ s/(AUX|COP|PASSIVE)//g;
      
  

    
#####Regras de PERIFRASES::
###precisamos uma lista de verbos modais e perifr�sticos em todas as l�nguas...
###problemas: Pedro escuch� cantar a los p�jaros // come para sobrevivir ...

##########Regra subs: VERB1(perifrase) VERB2 -> VERB2 
########## debe comer -> comer (nao finita)
      (@temp) = ($listTags =~ /($VERB)(?:$ADV)*($VERBN)/g);
       $listTags =~ s/($VERB)(?:$ADV)*($VERBN)/$2/g;
       $Rel =  "Spec" ; ##aqui o spec e um verbo
       DepHead($Rel, @temp);

       ##remendo por causa da recursividade do 'g'.
       ## em busca da segunda parte duma dupla perifrase - debe intentar comer
       (@temp) = ($listTags =~ /($VERB)(?:$ADV)*($VERBN)/g);
       $listTags =~ s/($VERB)(?:$ADV)*($VERBN)/$2/g;
       $Rel =  "Spec" ; ##aqui o spec e um verbo
       DepHead($Rel, @temp);      
#########Fim regra     

##########Regra subs: VERB1(perifrase) PRP  VERB2 -> VERB2 - debe de comer
      (@temp) = ($listTags =~ /($VERB)(?:$ADV)*($PRP|$CS)(?:$ADV)*($VERBN)/g);
      $listTags =~ s/($VERB)(?:$ADV)*($PRP|$CS)(?:$ADV)*($VERBN)/$3/g;
      DepRelHead(@temp);
      
      #em busca da segunda parte duma dupla perifrase - debe de tener que comer
      (@temp) = ($listTags =~ /($VERB)(?:$ADV)*($PRP|$CS)(?:$ADV)*($VERBN)/g);
      $listTags =~ s/($VERB)(?:$ADV)*($PRP|$CS)(?:$ADV)*($VERBN)/$3/g;
      DepRelHead(@temp);
#########Fim regra 

###FIM REGRAS SV




###REGRAS DE ADJUNTOS (eliminamos o adjunto)


#####regras adjectivo

##########Regra NOM ADJ
      (@temp) = ($listTags =~ /($NOM)($ADJ|$NOM)/g);
        $listTags =~ s/($NOM)($ADJ|$NOM)/$1/g ; 
        $Rel =  "AdjnR" ;
        HeadDep($Rel, @temp);

       ##duplo adjectivo
       (@temp) = ($listTags =~ /($NOM)($ADJ|$NOM)/g);
        $listTags =~ s/($NOM)($ADJ)/$1/g ; 
        $Rel =  "AdjnR" ;
        HeadDep($Rel, @temp);
#########Fim regra

##########Regra ADJ NOM
      (@temp) = ($listTags =~ /($ADJ|$CARD)($NOM)/g);
        $listTags =~ s/($ADJ|$CARD)($NOM)/$2/g ;
        $Rel =  "AdjnL" ;
        DepHead($Rel, @temp);

       (@temp) = ($listTags =~ /($ADJ|$CARD)($NOM)/g);
        $listTags =~ s/($ADJ|$CARD)($NOM)/$2/g ;
        $Rel =  "AdjnL" ;
        DepHead($Rel, @temp);
#########Fim regra


##########Regras NOM NOM para linguas romances (AdjnR) 
      (@temp) = ($listTags =~ /($NOM)($NOM)/g);
        $listTags =~ s/($NOM)($NOM)/$1/g ; 
        $Rel =  "AdjnR" ;
        HeadDep($Rel, @temp);

#########Fim regra linguas romances

##########Regras NOM NOM para o ingles (AdjnL) 
      #(@temp) = ($listTags =~ /($NOM)($NOM)/g);
       # $listTags =~ s/($NOM)($NOM)/$2/g ; 
       # $Rel =  "AdjnL" ;
       # DepHead($Rel, @temp);

#########Fim regra ingles




#####regras adverbio (repetir depois de fazer as depend�ncias nom-verb)

##########Regra VERB ADV
      (@temp) = ($listTags =~ /($VERB)($ADV)/g);
        $listTags =~ s/($VERB)($ADV)/$1/g ; 
        $Rel =  "AdjnR" ;
        HeadDep($Rel, @temp);

       ##duplo adv.
        (@temp) = ($listTags =~ /($VERB)($ADV)/g);
        $listTags =~ s/($VERB)($ADV)/$1/g ; 
        $Rel =  "AdjnR" ;
        HeadDep($Rel, @temp);
#########Fim regra

##########Regra ADV VERB
      (@temp) = ($listTags =~ /($ADV)($VERB)/g);
        $listTags =~ s/($ADV)($VERB)/$2/g ;
        $Rel =  "AdjnL" ;
        DepHead($Rel, @temp);

      (@temp) = ($listTags =~ /($ADV)($VERB)/g);
        $listTags =~ s/($ADV)($VERB)/$2/g ;
        $Rel =  "AdjnL" ;
        DepHead($Rel, @temp);
#########Fim regra

###FIM REGRAS ADJUNTOS




###REGRAS DE DETERMINANTES


#############Regra DT NOM
      (@temp) = ($listTags =~ /($DT)($N)/g);
       $listTags =~ s/($DT)($N)/$2/g ;
       $Rel =  "Spec" ;
       DepHead($Rel, @temp);

       ##duplo determinante
       (@temp) = ($listTags =~ /($DT)($N)/g);
       $listTags =~ s/($DT)($N)/$2/g ;
       $Rel =  "Spec" ;
       DepHead($Rel, @temp);
#########Fim regra

###FIM REGRAS DETERMINANTES



###REGRAS COMPLEMENTOS PREP

############Regra NOM1 PRP_de NOM2 PRP_de NOM3 -> NOM1 PRP_de NOM2 
## e construe a dependencia: (PRP_de;NOM2;NOM3) 
##permite usar a heuristica "right assoc" no caso de 2 complementos com "de"
(@temp) = ($listTags =~ /(?:$NOM)(?:$PRPP)($NOM)($PRPP)($NOM)/g);
        $listTags =~ s/($NOM)($PRPP)($NOM)($PRPP)($NOM)/$1$2$3/g ;
        HeadRelDep(@temp);
##########Fim Regra

############Regra NOM PRP NOM (3 complementos)
        ##1eiro complento preposicional
        (@temp) = ($listTags =~ /($NOM|$P)($PRP)($N)/g);
        $listTags =~ s/($NOM|$P)($PRP)($N)/$1/g ;
        HeadRelDep(@temp);
       

         ##2ndo complento preposicional
        (@temp) = ($listTags =~ /($NOM|$P)($PRP)($N)/g);
        $listTags =~ s/($NOM|$P)($PRP)($N)/$1/g ;
        HeadRelDep(@temp);

         ##3ndo complento preposicional
        (@temp) = ($listTags =~ /($NOM|$P)($PRP)($N)/g);
        $listTags =~ s/($NOM|$P)($PRP)($N)/$1/g ;
        HeadRelDep(@temp);    
#########Fim regra

###FIM REGRAS COMPLEMENTOS PREP





###REGRAS CLAUSULAS DE RELATIVO

############Regra PR VERB -> PR(lobj) VERB        
        (@temp) = ($listTags =~ /(?:$NOM|$P)($PR)($VERB)(?:$NOM|$P)?/g);
        $Rel =  "Lobj" ;
        DepHead($Rel,@temp);
#########Fim regra

############Regra VERB NOM-> V(Robj)         
        (@temp) = ($listTags =~ /(?:$NOM|$P)(?:$PR)($VERB)($NOM|$P)/g);
        $Rel =  "Robj" ;
        HeadDep($Rel,@temp);
#########Fim regra

#############Regra NOM PR VERB-> NOM        
        (@temp) = ($listTags =~ /($NOM|$P)(?:$PR)($VERB)(?:$NOM|$P)?/g);
        $Rel =  "Lobj" ; 
        DepHead($Rel, @temp);
        ##regra semantica (sintacticamente seria um AdjL com o Nome-antecedente como Head do Verb         ##(nucleo da frase de relativo)
#########Fim regra
         $listTags =~ s/($NOM|$P)($PR)($VERB)($NOM|$P)?/$1/g ;



############Regra PR NOM  VERB -> PR(robj) NOM VERB        
        (@temp) = ($listTags =~ /(?:$NOM|$P)($PR)(?:$NOM|$P)($VERB)/g);
        $Rel =  "Robj" ;
        DepHead($Rel,@temp);
#########Fim regra

#############Regra NOM PR NOM VERB-> NOM        
        (@temp) = ($listTags =~ /($NOM|$P)(?:$PR)(?:$NOM|$P)($VERB)/g);
        $Rel =  "Robj" ; 
        DepHead($Rel, @temp);
        ##regra semantica (sintacticamente seria um AdjL com o Nome-antecedente como Head do Verbo        ##(nucleo da frase de relativo)
        ##########Regra NOM VERB (regra sujeito)
        (@temp) = ($listTags =~ /(?:$NOM|$P)(?:$PR)($NOM|$P)($VERB)/g);
        $Rel =  "Lobj" ;
        DepHead($Rel, @temp);
        #########Fim regra
        $listTags =~ s/($NOM|$P)($PR)($NOM|$P)($VERB)/$1/g ;
#########Fim regra
##faltam regras com participios introductorios duma clausula subordinada
###FIM REGRAS FRASES RELATIVAS


###REGRAS ATRIBUTIVAS

##########Regra NOM VERB ADJ : nom-adj (dependencia semantica???)
      (@temp) = ($listTags =~ /($NOM|$P)(?:$VERB)($ADJ)/g);
       $Rel =  "AdjnR-SEM" ;
       HeadDep($Rel, @temp);
#########Fim regra
##vai ser necessario lan�ar as regras de complemento prep de adjectivo??
############Regra ADJ PRP NOM
        (@temp) = ($listTags =~ /($ADJ)($PRP)($NOM|$P|$VERB)/g);
        $listTags =~ s/($VERB)($PRP)($NOM|$P|$VERB)/$1/g ;
        HeadRelDep(@temp);
#########Fim regra

##########Regra NOM VERB ADJ : v-adj
      (@temp) = ($listTags =~ /(?:$NOM|$P)*($VERB)($ADJ)/g);
       $listTags =~ s/(?:$NOM|$P)*($VERB)($ADJ)/$1/g ;
       $Rel =  "AdjnR" ;
       HeadDep($Rel, @temp);
#########Fim regra

###FIM REGRAS ATRIBUTIVAS 
##(falta atributos de objecto directo...)
##vai ser necessario lan�ar de novo as regras de complemento prep de verbo??


###REGRAS COMPLEMENTOS DE VERBO (ROBJ E COMPLEMENTOS PREP)

##########Regra VERB NOM ##hai um parche: determinantes, DT, soltos que sao pronomes...
      (@temp) = ($listTags =~ /($VERB)($NOM|$P|$DT)/g);
       $listTags =~ s/($VERB)($NOM|$P|$DT)/$1/g ;
        $Rel =  "Robj" ;
        HeadDep($Rel, @temp);
#########Fim regra


############Regra VERB PRP NOM|VERB
        (@temp) = ($listTags =~ /($VERB)($PRP)($N|$DT|$VERB)/g);
        $listTags =~ s/($VERB)($PRP)($N|$DT|$VERB)/$1/g ;
        HeadRelDep(@temp);
#########Fim regra

###fim REGRAS COMPLEMENTOS DE VERBO (ROBJ E COMPLEMENTOS PREP)





###REGRAS LEFT COMPLEMENT (SUBJECT??)

##########Regra NOM VERB (parche: DT soltos)
      (@temp) = ($listTags =~ /($NOM|$P|$DT)($VERB)/g);
      $listTags =~ s/($NOM|$P|$DT)($VERB)/$2/g ;
      $Rel =  "Lobj" ;
      DepHead($Rel, @temp);
#########Fim regra

###FIM REGRAS LEFT COMPLEMENT (SUBJECT??)




###REGRAS COMPLEMENTO ORA�AO SUBSTANTIVA (RIGHT OBJECT)
#############Regra CS VERB -> VERB
      (@temp) = ($listTags =~ /($CS)($VERBF)/g);
      # $listTags =~ s/($CS)($VERBF)/$2/g ;
       $Rel =  "Spec" ;
       DepHead($Rel, @temp);
#########Fim regra
##########Regra VERB VERB
      (@temp) = ($listTags =~ /($VERB)(?:$CS)($VERB)/g);
       $listTags =~ s/($VERB)(?:$CS)($VERB)/$1/g ;
        $Rel =  "Robj" ;
        HeadDep($Rel, @temp);
#########Fim regra
##faltam muitas regras: "consiste en que tu vengas..."




##########REGRAS SOLTAS
#############Regra PRP NOM|VERB|ADJ ->  NOM|VERB|ADJ
        (@temp) = ($listTags =~ /($PRP)($N|$ADJ|$VERB)/g);
        $listTags =~ s/($PRP)($N|$ADJ|$VERB)/$2/g ;
        PrepDep(@temp);   


###########imprimir Hash de dependencias ordenado:
       foreach $triplet (sort {$Ordenar{$a} <=>
                              $Ordenar{$b} }
                         keys %Ordenar ) {
            print "$triplet\n";
       }
       ##final de analise de frase:
       print "---";

      ##Colocar a zero os vectores de cada ora�ao
      ##Colocar numa lista vazia os strings com os tags (listTags) e a ora�ao (seq)
      ##Borrar hash ordenado de triplets
      for ($i=0;$i<=$#Lema;$i++) {
         delete  $Pal[$i];
         delete  $Tag[$i];
         delete  $Lema[$i];
      }
      $i=0;
      $listTags="";
      $seq="";
      foreach $t (keys %Ordenar) {
         delete  $Ordenar{$t};
      }
   } ##fim do elsif

 
}

print "\n";
print STDERR "Fim do parsing...\n";





sub HeadDep {

    my ($y, @x) = @_ ;
    my $n1=0;
    my $n2=0;

    for ($m=0;$m<=$#x;$m++) {
            $Head = $x[$m];
            $m++;
            $Dep = $x[$m];
           ($n1) = ($Head =~ /[\w]+_([0-9]+)/) ;
           ($n2) = ($Dep =~ /[\w]+_([0-9]+)/);

           #print STDERR "($y;$Lema[$n1]_$Head;$Lema[$n2]_$Dep)\n";
           $Ordenar{"($y;$Lema[$n1]_$Head;$Lema[$n2]_$Dep)"} = $n2 ;
    }
}


sub DepHead {

    my ($y, @x) = @_ ;
    my $n1=0;
    my $n2=0;

    for ($m=0;$m<=$#x;$m++) {
            $Dep = $x[$m];
            $m++;
            $Head = $x[$m];
           ($n1) = ($Head =~ /[\w]+_([0-9]+)/) ;
           ($n2) = ($Dep =~ /[\w]+_([0-9]+)/);

           #print "($y;$Lema[$n1]_$Head;$Lema[$n2]_$Dep)\n";
           $Ordenar{"($y;$Lema[$n1]_$Head;$Lema[$n2]_$Dep)"} = $n2 ;
    }
}



sub HeadRelDep {

    my (@x) = @_ ;
    my $n1=0;
    my $n2=0;
    my $n3=0;

     for ($m=0;$m<=$#x;$m++) {
            $Head = $x[$m];
            $m++;
            $Rel = $x[$m];
            $m++;
            $Dep = $x[$m];
           ($n1) = ($Head =~ /[\w]+_([0-9]+)/) ;
           ($n2) = ($Rel =~ /[\w]+_([0-9]+)/);
           ($n3) = ($Dep =~ /[\w]+_([0-9]+)/);

            #print "($Lema[$n2]_$Rel;$Lema[$n1]_$Head;$Lema[$n3]_$Dep)\n";
             $Ordenar{"($Lema[$n2]_$Rel;$Lema[$n1]_$Head;$Lema[$n3]_$Dep)"} = $n3 ;
             $comp = "Comp";
             $Ordenar{"($comp;$Lema[$n2]_$Rel;$Lema[$n3]_$Dep)"} = $n3 ;

    }

}


sub DepRelHead {

    my (@x) = @_ ;
    my $n1=0;
    my $n2=0;
    my $n3=0;

     for ($m=0;$m<=$#x;$m++) {
            $Dep = $x[$m];
            $m++;
            $Rel = $x[$m];
            $m++;
            $Head = $x[$m];
           ($n3) = ($Head =~ /[\w]+_([0-9]+)/) ;
           ($n2) = ($Rel =~ /[\w]+_([0-9]+)/);
           ($n1) = ($Dep =~ /[\w]+_([0-9]+)/);

            #print "($Lema[$n2]_$Rel;$Lema[$n3]_$Head;$Lema[$n1]_$Dep)\n";
             $Ordenar{"($Lema[$n2]_$Rel;$Lema[$n3]_$Head;$Lema[$n1]_$Dep)"} = $n1 ;
             $comp = "Comp";
             $Ordenar{"($comp;$Lema[$n2]_$Rel;$Lema[$n1]_$Dep)"} = $n1 ;

    }

}


sub PrepDep {

    my (@x) = @_ ;
    my $n1=0;
    my $n2=0;
   

     for ($m=0;$m<=$#x;$m++) {
            $Rel = $x[$m];
            $m++;
            $Dep = $x[$m];
           ($n1) = ($Rel =~ /[\w]+_([0-9]+)/) ;
           ($n2) = ($Dep =~ /[\w]+_([0-9]+)/);

            
             $comp = "Comp";
             $Ordenar{"($comp;$Lema[$n1]_$Rel;$Lema[$n2]_$Dep)"} = $n2 ;

    }

}




    
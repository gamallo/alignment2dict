#!/usr/bin/perl -w

##Entrada: saida do TreeTagger ingles
##Saida: entrada do parsingCascataByRegularExpressions.perl


$UpperCase = "[A-Z\301\311\315\323\332\307\303\325\302\312\324\300\310�]" ;
$LowerCase = "[a-z��������������]" ;

## Lexemas gramaticais especiais:
$AUX="(have|avoir|haber|haver)";
$COP="(be|be/have|�tre|ser)";

$Pos=0;
while (<>) {
   chop($_);
   $_ =~ s/[\*\+]+/-/g;

   if ($_ eq "" || $_ =~ /^<[\w\W]*>$/ || $_ !~ /\t/ )  {
      next
   }

  else {

     ($token, $tag, $lemma) = split("\t", $_);

   ##correc�oes ad hoc de problemmas de etiqueta�ao:

   if ( ($lemma =~ /^pol[oa](s?)$/) && ($tag =~ /^PRP/) ) {
           $lemma = "por"
   }
   $lemma =~ s/[\|\/]/-/ ;
   $tag =~ s/\:/;/;
   

   #se temos um poss�vel nome pr�prio (desconhecido ou composto), colocar a forma no lemma (para conservar a maiuscula)
   if ( ($token =~ /\&/) || ($lemma =~ /<unknown>/) ) {
         $lemma = $token;
   }
   elsif ( ($tag =~ /^NP/) && ($token =~ /^$UpperCase/) && ($lemma =~ /^$LowerCase/) ) {
         $lemma = $token;
   }

   #mudar tags:
#   if ($tag =~ /^VIRG/) {
 #     $tag = "COMMA"
  # }

   ##pronomes:
   
   if ($tag =~ /^PP$/) {
      $Exp{"lemma"} = $lemma;
      $Exp{"token"} = $token;
      $Exp{"tag"} =  "PRO";
      $Exp{"type"} = "P";
      $Exp{"person"} = 0;
      $Exp{"gender"} = 0;
      $Exp{"number"} = 0;
      $Exp{"case"} = 0;    
      $Exp{"possessor"} = 0;    
      $Exp{"politeness"} = 0;

   } 
   elsif ($tag =~ /^W/) {
      $Exp{"lemma"} = $lemma;
      $Exp{"token"} = $token;
      $Exp{"tag"} =  "PRO";
      $Exp{"type"} = "W";
      $Exp{"person"} = 3;
      $Exp{"gender"} = 0;
      $Exp{"number"} = 0;
      $Exp{"case"} = 0;    
      $Exp{"possessor"} = 0;    
      $Exp{"politeness"} = 0;

   } 
      
     ##conjunctions:
    elsif ($tag =~ /^CC/) {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "CONJ";
      
    }

    elsif ( $lemma =~ /^that$/ && $tag =~ /^IN/ ) {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "CONJ";
       $Exp{"type"} = "S";
     }      
  
    ##interjections:
    elsif ($tag =~ /^UH/) {
       (@tmp) = split ("", $tag);
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "I";
       $Exp{"type"} = 0;
      
    }

   ##numbers
   elsif ($tag =~  /^CD/) {
   #    $lemma = "\@card\@";
       (@tmp) = split ("", $tag);
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "CARD";
       $Exp{"number"} = "P";
       $Exp{"person"} = 0;         
       $Exp{"gender"} = 0;         
       
   }


    elsif ($tag =~ /^JJ/) {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "ADJ";
       $Exp{"type"} = 0;
       
       if ($tag =~ /R$/) {
          $Exp{"degree"} = "A";
       }
       elsif ($tag =~ /S$/) {
          $Exp{"degree"} = "S";
       }
       else {
          $Exp{"degree"} = 0;  
       }
       $Exp{"gender"} = 0;
       $Exp{"number"} = 0;
       $Exp{"function"} = 0;
   }


   elsif ($tag =~ /^RB/) {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "ADV";
       if ($tag =~ /R$/) {
          $Exp{"degree"} = "A";
       }
       elsif ($tag =~ /S$/) {
          $Exp{"degree"} = "S";
       }
       else {
          $Exp{"degree"} = 0;  
       }
     
   }


   elsif ($tag =~ /(^IN$|^TO$)/) {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "PRP";
       $Exp{"type"} = 0;
      
   }


   elsif ($tag =~ /^N/) {
       (@tmp) = split ("", $tag);
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "NOUN";
       if ($tag =~ /^NP$/) {
          $Exp{"type"} = "P";
          $Exp{"number"} = "S";
       }
       elsif  ($tag =~ /^NPS/)  {
           $Exp{"type"} = "P" ;
           $Exp{"number"} = "P";
       }
       if ($tag =~ /^NN$/) {
          $Exp{"type"} = "C";
          $Exp{"number"} = "S";
       }
       elsif  ($tag =~ /^NNS/)  {
           $Exp{"type"} = "C" ;
           $Exp{"number"} = "P";
       }
       $Exp{"gender"} = 0;
       $Exp{"person"} = 3;

   }

   elsif ($tag =~ /(^DT$|^PDT$|^PP\$$)/) {
       (@tmp) = split ("", $tag);
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "DT";
       if ($tag =~ /^PP\$$/) {
         $Exp{"type"} = "P";
       }
       else{
         $Exp{"type"} = 0;
       }
       $Exp{"person"} = 0;
       $Exp{"gender"} = 0;
       $Exp{"number"} = 0;
       $Exp{"possessor"} = 0;
        
   }

  ##mudar tags nos verbos:
   elsif ($tag =~ /(^V|^MD$)/) {

       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "VERB";
       if  ($lemma =~ /^$AUX$/) {
         $Exp{"type"} = "A";
       }
       elsif ($lemma =~ /^$COP$/) {
          $Exp{"type"} = "S";
       }
       else {
          $Exp{"type"} = 0; 
       }
       if ($tag =~ /^VBN/) {
        $Exp{"mode"} = "P";
       }
      
       elsif ($tag =~ /^VBG$/) {
        $Exp{"mode"} = "G";
       }
       else {
          $Exp{"mode"} = 0; 
       }
       if ($tag =~ /^VBD/) {
        $Exp{"tense"} = "S";
	$Exp{"person"} = 0;
	$Exp{"number"} = 0;
	$Exp{"gender"} = 0;
       }
       elsif ($tag =~ /^VBZ/) {
        $Exp{"tense"} = "P";
        $Exp{"person"} = 3;
        $Exp{"number"} = 0;
	$Exp{"gender"} = 0;
       }
       else {
         $Exp{"tense"} = 0;
         $Exp{"person"} = 0;
         $Exp{"number"} = 0;
         $Exp{"gender"} = 0;
       }
   }

     ##simbolos puntuacao:
  #   elsif  ($token eq "!")  {
       
  #     $Exp{"lemma"} = $lemma;
  #     $Exp{"token"} = $token;
  #     $Exp{"tag"} =  "Fat";
  # }

   elsif  ($token eq "�")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Faa";
   }

   elsif  ($token eq ",")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fc";
   }
   elsif  ($token eq "\[")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fca";
   }
   elsif  ($token eq "\]")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fct";
   }
   elsif  ($token eq "\:" || $lemma eq "\:")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fd";
   } 
   elsif  ($token eq "\"")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fe";
   }
   elsif  ($token eq "-")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fg";
   }
   elsif  ($token eq "\/")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fh";
   }
   elsif  ($token eq "�")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fia";
   } 
 #   elsif  ($token eq "?")  {
       
  #     $Exp{"lemma"} = $lemma;
  #     $Exp{"token"} = $token;
  #     $Exp{"tag"} =  "Flt";
  # } 
   elsif  ($token eq "{")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fla";
   } 
    elsif  ($token eq "}")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Flt";
   } 
   elsif  ($token eq "(")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fpa";
   } 
   elsif  ($token eq ")")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fpt";
   } 
   elsif  ($token eq "\�")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fra";
   } 
   elsif  ($token eq "\�")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Frc";
   } 
   elsif  ($token eq "\.\.\.")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fs";
   } 
   elsif  ($token eq "%")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Ft";
   }  
   elsif  ($token eq "\;")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fx";
   } 

   elsif  ($token eq "[+-=]")  {
       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "Fz";
   }
 
   
   ##particulas
   elsif  ($tag =~ /^RP$/)  {
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "PCLE";
   }

    ##final de frase (.)
    elsif ($token =~ /^\.$|^\?$|^\!$/) {
   # print STDERR "--$lemma -- $tag\n";       
       $Exp{"lemma"} = $lemma;
       $Exp{"token"} = $token;
       $Exp{"tag"} =  "SENT";
       $Exp{"pos"} =  $Pos;
       $Pos=0;
   }
   else {
      $Exp{"lemma"} = $lemma;
      $Exp{"token"} = $token;
      $Exp{"tag"} =  $tag;
   }

  
  
   ##Colocar a posi�ao em todos:
     if ($token !~ /^\.$|^\?$|^\!$/) {
       $Exp{"pos"} =  $Pos;
       $Pos++;
    }

 #  if   ($Exp{"tag"} =~ /^Fra$|^Frc$|Fe$/) {

  # }
 #  else {
       print "$token\t" ;
       foreach $attrib (sort keys %Exp) {
	   print "$attrib:$Exp{$attrib}|" ;
           delete $Exp{$attrib};
       }
       print "\n";
  # }

 }
}


##as conjun�oes seguem a ser CS (subord) e CC (coordenada)
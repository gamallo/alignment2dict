#!/usr/bin/perl -w

#
# toma dois ficheiros: um de pares (pipe) e um outro de frequencias (arg1) e compara palavra por palavra. 
# um parametro (arg2): numero de contextos comuns.
## devolve um ficheiro com pares de palavras usando  dice-min
#
#

$arq = shift(@ARGV);
open(PFILE, $arq) || die "Can't open search-patterns: $!\n";

$CARD = 1; # recomendado: 1


$mycount=0;

while ($line = <PFILE>) {
  chomp $line;
  ($atributo, $objecto, $freq) = split (" ", $line);

  $dic{$objecto}{$atributo} = $freq;
  $freqObj{$objecto} += $freq;
 # $Obj{$objecto}++;
 # $freqAtr{$atributo} += $freq;
#  $nrels++;


  $mycount++;
  if ($mycount % 1000 == 0) {
#     printf STDERR "leu freqs: %10d\r",$mycount;
   }
}

$mycount=0;

while (<>) {
  chop $_;
  ($obj1, $obj2) = split (" ", $_);
  

  $mycount++;
  if ($mycount % 1000 == 0) {
     printf STDERR "count: %10d\r",$mycount;
  }
 
    my $diceMin = 0;
    my  $min = 0;
    foreach $atr (keys %{ $dic{$obj1} }) {

    $assoc1 = 0;
    $assoc2 = 0;
    ##buscar atributos comuns
    if ($dic{$obj2}{$atr}) {
         $baseline++ ;

  #       $rels = $rels . "|" . $atr ;
         $assoc1 = $dic{$obj1}{$atr} ;
         $assoc2 = $dic{$obj2}{$atr} ;

         $min += Min ($assoc1, $assoc2) ;
 
    }

  }


   ##computar


  ##diceMin,:
  if ( $freqObj{$obj1} && $freqObj{$obj2} )  {
    $diceMin = (2*$min) / ($freqObj{$obj1} + $freqObj{$obj2}) ;

  }

  if  ($baseline >= $CARD)  {
      #print STDERR "#$obj1# - #$obj2# ##$diceMin#\n";
     printf "%s %s %.4f\n", $obj1, $obj2,  $diceMin ;
  }

}

#printf STDERR "Total: %10d\n\n",$mycount;







 sub Min {
    local ($x) = $_[0];
    local ($y) = $_[1];

    if ($x <= $y) {
      $result = $x
    }
    else {
      $result = $y
    }

    return $result
}



sub Max {
    local ($x) = $_[0];
    local ($y) = $_[1];

    if ($x >= $y) {
      $result = $x
    }
    else {
      $result = $y
    }

    return $result
}









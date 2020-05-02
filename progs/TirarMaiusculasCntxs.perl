#!/usr/bin/perl -w

##Chama a funçao UpperLowerCase para tirar 
##as maiusculas as palavras dos contextos

##use progs::funcoes::funcoesBasicas


while ($line = <>) { 
   chomp $line;
  ($cntx, $pal, $f, $ling) = split(" ", $line);

  if ($ling ne "") {
 
    $tmp = UpperToLower ($cntx);

    $tmp =~ s/^robj\_/Robj\_/;
    $tmp =~ s/^lobj\_/Lobj\_/;
    $tmp =~ s/^rmod\_/Rmod\_/;
    $tmp =~ s/^lmod\_/Lmod\_/;
    $tmp =~ s/^modn\_/modN\_/;  
    $tmp =~ s/\_card /\_CARD /;  
    $cntx = $tmp;
  
    print "$cntx $pal $f $ling\n" ;
  }
}

print STDERR "Done.\n\n";


sub UpperToLower {
    local ($l) = @_;
     $l =~tr/A-Z/a-z/;
     $l =~tr/Ñ/ñ/;
     $l =~tr/\301\311\315\323\332\307\303\325\302\312\324\300\310/\341\351\355\363\372\347\343\365\342\352\364
\340\350/;
     return $l;
}

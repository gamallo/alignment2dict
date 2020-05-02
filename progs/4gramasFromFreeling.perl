#!/usr/bin/perl

# O GERADOR DE 4-GRAMAS
#lê um texto taggeado com FreeLing
#escreve quatro lemas taggeados por linha (4gramas)

#$ling = shift(@ARGV);

#open (INPUT, "tokens.txt") or die "O ficheiro não pode ser aberto: $!\n";
#open (OUTPUT, ">bigramas.txt");

$prev1 = "#";
$prev2 = "#";
$prev3 = "#";
while ($line = <STDIN>) {
      chop($line);
      ($token, $lema, $tag) = split (" ", $line);
      #$lema = "$lema\#$ling";
      $tagged = "$lema\_$tag";


      print "$prev1 $prev2 $prev3 $tagged\n";
      $prev1 = $prev2;
      $prev2 = $prev3;
      $prev3 = $tagged;
}


print STDERR "foi gerado o ficheiro de 4gramas\n";

#!/usr/bin/perl

# LE UM FICHEIRO DE CLUSTERS E ESCREVE AS PALAVRAS DIFERENTES,



#lê um ficheiro com os clusters (node wset cset) (pipe)


$numPals=0;
while ($line = <STDIN>) {
      chomp($line);
      ($node, $wset, $cset) = split (" ", $line);
      
       if  ($wset =~ /<[0-9]*=/) {
        ($tmp) =  ($wset =~ /<[0-9]*=([^ ]*)>/) ;
        $wset = $tmp;
       # print STDERR "#$wset#\n";
       }
 
      @tmp = split ('\|', $wset);
      for ($i=0;$i<=$#tmp;$i++) {
	if ($tmp[$i] ne "") {
          $Word{$tmp[$i]}++;
        }
      }
}

foreach $p (keys %Word) {
     print "$p\n";
}

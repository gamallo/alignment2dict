#!/usr/bin/perl

# LE UM FICHEIRO DE CLUSTERS E DE SIMIL E ESCOLHE AS PALAVRAS DO SIMIL QUE NAO APARACEM NOS CLUSTERS,



#lê um ficheiro com os clusters (node wset cset) (pipe) e um ficheiro de simils (arg1)

#cat ../intermedio/cluster2/lattice_aclA-H-en_N3.txt |escolherTermosParaClassif.perl ../thesaurus/results/Nomes-aclA-H-en.txt > x



$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro não pode ser aberto: $!\n";




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

$sim="";
while ($line = <FILE>) {
      chomp($line);
      ($w, $wset) = split (" ", $line);
 
      @tmp = split ('\|', $wset);
      for ($i=0;$i<=$#tmp;$i++) {
	if ( ($tmp[$i] ne "") && (defined $Word{$w}) ) {
          ($w2, $sim) = split ("=", $tmp[$i]);
          $Simil{$w}{$w2}++;
        }
      }

}


foreach $w1 (keys %Simil) {
  foreach $w2 (keys %{$Simil{$w1}}) {
   if ( (defined $Word{$w2}) && (!defined $found{$w2}) ) {
     print "$w2\t0\n";
     $found{$w2}++
   }
 }
}

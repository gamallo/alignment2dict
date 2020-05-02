#!/usr/bin/perl

#GERA OS CONTEXTOS, AS PALAVRAS E AS FREQUENCIAS 
#lê o texto taggeado e filtrado. 
#Coloca a marca de lingua em cada palavra e contexto.

use lib "/home/gamallo/ExtractorBilingue/progs/funcoes" ;
use categorias ;
#use progs::funcoes::categorias

$Border="Fp";

$i=0;
$CountLines=0;
while ($line = <>) {

 

  if ( ($CountLines % 100) == 0) {;
       printf  STDERR "- - - processar linha:(%6d) - - -\r",$CountLines;
  }
  $CountLines++;

  chop($line);

   if ($line eq "") {
      next
   }
  
  else {
     
    ($pal, $lema, $tag) = split(" ", $line);
     #print STDERR "$pal - $lema - $tag\n";

    if ($tag ne $Border) {
      $Pal[$i] = $pal;
      $Lema[$i] = $lema;
      $Tag[$i] = $tag;
      $i++;
      #print STDERR "$i\n";
      
    }
   
   elsif ($tag eq $Border) {
 
     for ($i=0;$i<=$#Lema;$i++) {
         
      $n = $i-2;
      $m = $i-1;
      $j = $i+1;
      $k = $i+2;
    
     
      if ($Tag[$i] eq "NOM") { 
       
        ##nome
        if ( ($Tag[$n] eq "NOM") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "N", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N", "N"}++;
        # print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V", "N"}++;
        # print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

################

       if (Verbo ($Tag[$i]) ) { 
       
        ##nome
        if ( ($Tag[$n] eq "NOM") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "N", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V", "V"}++;
         # print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

#########################

        if ($Tag[$i] eq "ADJ") { 
       
        ##nome
        if ( ($Tag[$n] eq "NOM") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "N", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N", "A"}++;
        # print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V", "A"}++;
        # print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

      
    }
    $i=0;
    $n=0;
    $m=0;
    $j=0;
    $k=0;
    for ($i=0;$i<=$#Pal;$i++)  {
        delete $Pal[$i];
        delete $Tag[$i];
        delete $Lema[$i]
    }
   }
  }
    
   
  
 
}




print STDERR "fim leitura do ficheiro entrada\n";
 

foreach $key (sort keys %freq) {
  ($p1, $p2, $cat_cntx, $cat_lema) = split (/$;/o, $key);
     if ($freq{$p1,$p2,$cat_cntx, $cat_lema}>0) {
       printf "%s_%s %s_%s %d\n", $cat_cntx, $p2, $p1, $cat_lema, $freq{$p1,$p2,$cat_cntx, $cat_lema};
     }

}




print  STDERR "o ficheiro de contextos - palavra - freq  foi gerado\n";

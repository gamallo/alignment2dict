#!/usr/bin/perl

#GERA OS CONTEXTOS, AS PALAVRAS E AS FREQUENCIAS 
#lê o texto taggeado e filtrado. 
#Coloca a marca de lingua em cada palavra e contexto.

use lib "/home/gamallo/ExtractorBilingue/progs/funcoes" ;
use categorias ;
#use progs::funcoes::categorias


$L=shift(@ARGV);

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
          
         $freq{$Lema[$i], $Lema[$n], "N1", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N2", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N3", "N"}++;
        # print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N4", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V1", "N"}++;
        # print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V2", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V3", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V4", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A1", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A2", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A3", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A4", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R1", "N"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R2", "N"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R3", "N"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R4", "N"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

################

       if (Verbo ($Tag[$i]) ) { 
       
        ##nome
        if ( ($Tag[$n] eq "NOM") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "N1", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N2", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N3", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N4", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V1", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V2", "V"}++;
         # print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V3", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V4", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A1", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A2", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A3", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A4", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R1", "V"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R2", "V"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R3", "V"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R4", "V"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

#########################

        if ($Tag[$i] eq "ADJ") { 
       
        ##nome
        if ( ($Tag[$n] eq "NOM") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "N1", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "NOM")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "N2", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$j], "N3", "A"}++;
        # print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "NOM") {
         
         $freq{$Lema[$i], $Lema[$k], "N4", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }

        ##verbo
        if ( (Verbo($Tag[$n]) ) && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "V1", "A"}++;
        # print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if ( (Verbo($Tag[$m]))  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "V2", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if (Verbo($Tag[$j]) ) {
         
         $freq{$Lema[$i], $Lema[$j], "V3", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if (Verbo($Tag[$k]) ) {
         
         $freq{$Lema[$i], $Lema[$k], "V4", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      
        ##adj
        if ( ($Tag[$n] eq "ADJ") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "A1", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADJ")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "A2", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$j], "A3", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADJ") {
         
         $freq{$Lema[$i], $Lema[$k], "A4", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
       
         ##adv
        if ( ($Tag[$n] eq "ADV") && ($i > 1)) {
          
         $freq{$Lema[$i], $Lema[$n], "R1", "A"}++;
         #print STDERR "n: $Lema[$i] - $Lema[$n] - $n\n";
        }
        if (($Tag[$m] eq "ADV")  && ($i > 0)) {
         
         $freq{$Lema[$i], $Lema[$m], "R2", "A"}++;
          #print STDERR "m: $Lema[$i] - $Lema[$m] - $m\n";
        }
        if ($Tag[$j] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$j], "R3", "A"}++;
         #print STDERR "j: $Lema[$i] - $Lema[$j] - $j\n";
        }
        if ($Tag[$k] eq "ADV") {
         
         $freq{$Lema[$i], $Lema[$k], "R4", "A"}++; 
         #print STDERR "k: $Lema[$i] - $Lema[$k] - $k\n";
        }
      }

      
    }
    $i=0;
    $n=0;
    $m=0;
    $j=0;
    $k=0;
   }
  }
    
   
  
}





print STDERR "fim leitura do ficheiro entrada\n";
 

foreach $key (sort keys %freq) {
  ($p1, $p2, $cat_cntx, $cat_lema) = split (/$;/o, $key);
     if ($freq{$p1,$p2,$cat_cntx, $cat_lema}>0) {
       printf "%s_%s %s_%s\#%s %d %s\n", $cat_cntx, $p2, $p1, $cat_lema,  $L , $freq{$p1,$p2,$cat_cntx, $cat_lema}, $L;
     }

}




print  STDERR "o ficheiro de contextos - palavra - freq  foi gerado\n";

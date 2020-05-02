#!/usr/bin/perl

#GERA OS CONTEXTOS, AS PALAVRAS E AS FREQUENCIAS 
#lê o texto taggeado e filtrado. 


use lib "/home/gamallo/EntitiesClustering/progs/funcoes" ;
use categorias ;
#use progs::funcoes::categorias


#$L=shift(@ARGV);

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
        ##So seleccionar NOUN
        if ($i != $j &&  Nome($Tag[$i]) && $Lema[$i] !~ /_/) {   
     
      
          for ($j=0;$j<=$#Lema;$j++) {
	   if ( ($i != $j) && 
            ( Verbo ($Tag[$j]) || Nome($Tag[$j]) || Adj($Tag[$j]) || 
              Adv($Tag[$j]) ) ) {
             
                $freq{$Lema[$i], $Lema[$j], $Tag[$j], $Tag[$i] }++;
	   }
          }
        }
     }

     for ($i=0;$i<=$#Pal;$i++)  {
        delete $Pal[$i];
        delete $Tag[$i];
        delete $Lema[$i]
     }
         
     $i=0;
     $j=0;
   }
 }
         
  
}





print STDERR "fim leitura do ficheiro entrada\n";
 

foreach $key (sort keys %freq) {
  ($p1, $p2, $cat_cntx, $cat_lema) = split (/$;/o, $key);
     if ($freq{$p1,$p2,$cat_cntx, $cat_lema}>0) {
       printf "%s_%s %s_%s %d\n", $cat_cntx, $p2, $p1, $cat_lema, $freq{$p1,$p2,$cat_cntx, $cat_lema};
       delete $freq{$p1,$p2,$cat_cntx, $cat_lema} ;
     }

}




print  STDERR "o ficheiro de contextos - palavra - freq  foi gerado\n";

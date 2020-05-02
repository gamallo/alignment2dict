#!/usr/bin/perl 

##Cria o ficheiro de entrada do sistema de clustering hierarquico. 
## A entrada para pipe é a saída do ficheiro de centroides (montemagni). 
## Também toma como argumento este ficheiro


$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro não pode ser aberto: $!\n";


$j=0;
print "IDF" ;
while (<>) {
  chop $_;
  ($idf, $wset, $cset) = ($_ =~ /([^ ]+) <[0-9]*=([^ ]+)> ([^ ]+)/);
 # print STDERR "$wset -- $cset \n";
  
 
  #Cargamos num vector as palavras e os contextos diferentes:
  @tmp = split ('\|', $wset) ;
  for ($i=0;$i<=$#tmp;$i++) {
      if ($tmp[$i] ne "") {
	  if (!$Found{$tmp[$i]}) {
	      $Atributos[$j] = $tmp[$i] ;
	      $Found{$tmp[$i]}++;
              print "\t$tmp[$i]";
              $j++;
          }
      }
  }
  
  @tmp = split ('\|', $cset) ;
  for ($i=0;$i<=$#tmp;$i++) {
      if ($tmp[$i] ne "") {
	  if (!$Found{$tmp[$i]}) {
	      $Atributos[$j] = $tmp[$i] ;
	      $Found{$tmp[$i]}++;
              print "\t$tmp[$i]";
              $j++;
          }
      }
  }
  
}
print "\n";
print STDERR "foi carregado o vector\n";


while ($line = <FILE>) {
  chop $line;
  ($idf, $wset, $cset) = ($line =~ /([^ ]+) <[0-9]*=([^ ]+)> ([^ ]+)/);
 # print STDERR "$wset -- $cset \n";
  print $idf;
 
  #Cargamos num hash as palavras e os contextos do centroide:
  @tmp = split ('\|', $wset) ;
  for ($i=0;$i<=$#tmp;$i++) {
      if ($tmp[$i] ne "") {
	  $atribsOfCentroide{$tmp[$i]}++
      }
  }
  @tmp = split ('\|', $cset) ;
  for ($i=0;$i<=$#tmp;$i++) {
      if ($tmp[$i] ne "") {
	  $atribsOfCentroide{$tmp[$i]}++
      }
  }

  ##Percorremos o vector e assignamos um valor para cada atributo
  for ($j=0;$j<=$#Atributos;$j++) {
      if (defined $atribsOfCentroide{$Atributos[$j]}) {
	  print "\t1";
      }
      else {
          print "\t0";
      }
  }
  print "\n";

  foreach $tmp (keys %atribsOfCentroide) {
      delete $atribsOfCentroide{$tmp} ;
  } 
}




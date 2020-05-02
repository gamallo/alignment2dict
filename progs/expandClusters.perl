#!/usr/bin/perl 

##Toma como entrada pipe a saída do ficheiro de clusters formateado.
## toma com entrada (arg) o ficheiro de centroides
## O resultado é o ficheiro de clusters extendido com os contextos e os wsets. 



$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro não pode ser aberto: $!\n";


while ($line = <FILE>) {
  chop $line;
  ($node, $wset, $cset) =  ($line =~ /([^ ]+) <[0-9]*=([^ ]+)> ([^ ]+)/)  ;
  $Wset{$node} = $wset;
  $Cset{$node} = $cset;
  #print STDERR "$node :: $wset :: $cset\n";

}

while ($line = <STDIN>) {
  chop $line;
  ($node, $filhosDirectos, $filhosTodos) = split ("\t", $line); 
  
   @ListaFilhos = split ('\|', $filhosTodos) ;
   $WordCluster = $Wset{$ListaFilhos[0]};
   $CntxCluster = $Cset{$ListaFilhos[0]};
       for ($i=1;$i<=$#ListaFilhos;$i++) {
          $WordCluster = intersectar ($WordCluster,$Wset{$ListaFilhos[$i]} ); 
          $CntxCluster = intersectar ($CntxCluster,$Cset{$ListaFilhos[$i]} ); 
         
           #printf "%s %s %s %s\n", $node, $Wset{$ListaFilhos[$i]}, $Cset{$ListaFilhos[$i]}, $filhosDirectos ;
      
       }
       if ($WordCluster eq "") { 
	   $WordCluster = "EMPTY";
       }
       if ($CntxCluster eq "") { 
	   $CntxCluster = "EMPTY";
       }
       printf "%s %s %s %s\n", $node, $WordCluster, $CntxCluster, $filhosDirectos ;
 }     



sub intersectar {
    local ($set1) = $_[0];
    local ($set2) = $_[1];

    local @temp1;
    local $i;
    local $intersection;
   # local $count;

   @temp1 = split(/\|/, $set1);
   @temp2 = split(/\|/, $set2);


   $i=0;

    $intersection = "";
    while ($i<=$#temp1) {
      if ($temp1[$i] eq "") { $i++;}
      elsif (index($set2."|", "|".$temp1[$i]."|") ==-1) {
            $i++;
      }
      else {
           $intersection .= "|" . $temp1[$i];
           $i++;
      }
    }


   return $intersection;
}

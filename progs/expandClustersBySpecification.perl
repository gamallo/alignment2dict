#!/usr/bin/perl 

##Toma como entrada pipe a sa�da do ficheiro de clusters formateado.
## toma com entrada (arg) o ficheiro de centroides
## O resultado � o ficheiro de clusters extendido com os contextos (intersects) e os wsets (com reuniao de wsets). 



$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro n�o pode ser aberto: $!\n";


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
	   if ( $Wset{$ListaFilhos[$i]} ne "" )  {
              $WordCluster = intersectar ($WordCluster,$Wset{$ListaFilhos[$i]} ); 
              $CntxCluster = reunir ($CntxCluster,$Cset{$ListaFilhos[$i]} ); 
         
            #printf "%s %s %s %s\n", $node, $Wset{$ListaFilhos[$i]}, $Cset{$ListaFilhos[$i]}, $filhosDirectos ;
	   }
      
       }
       if ($WordCluster eq "") { 
	   $WordCluster = "EMPTY";
       }
       if ($CntxCluster eq "") { 
	   $CntxCluster = "EMPTY";
       }
       if ( ($CntxCluster ne "EMPTY") && ($WordCluster ne "EMPTY") ){
         $WordClusterSorted = sorting($WordCluster) ;
         $CntxClusterSorted = sorting($CntxCluster) ;
      # print "##$WordCluster ##\n";
  #           printf "%s %s %s %s\n", $node, $WordCluster, $CntxCluster, $filhosDirectos ;
       printf "%s %s %s %s\n", $node, $WordClusterSorted, $CntxClusterSorted, $filhosDirectos ;
      }
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

sub reunir {
    local ($set1) = $_[0];
    local ($set2) = $_[1];

    
    local $reunion;
   # local $count;
    
    $reunion = $set1 . "|" . $set2 ;
    $reunion =~ s/\|\|/\|/g  ;

   return $reunion;
}

sub sorting {
    local ($set) = $_[0];
    
    local @temp;
    local $sorted = "";
    
   @temp = split(/\|/, $set);

   foreach $pal1 (@temp) {
       if ( ($pal1 ne "") && (!$found{$pal1}) ) {
          $found{$pal1}++;
	  
          #print "$pal1 :: " ;
          foreach $pal2 (@temp) {
             if ($pal2 ne "") {
                 #print "$pal2=$count";
                if  ($pal1 eq $pal2) {
                    $Pals{$pal1}++;

                }
             }
	  } 
          delete $found{$pal1} ;
       }  
   }

   foreach $w (sort {$Pals{$b} <=>
                      $Pals{$a} }
                      keys %Pals ) {
       #$sorted .=  $w . "=" . $Pals{$w}  . "|" ;
        $sorted .=  $w  . "|" ;

       delete $Pals{$w} ;
   }

   return $sorted
}                    



sub sortAndUniq {
    local ($sep) = $_[0];
    local ($con) = $_[1];
    local ($cadeia) = $_[2];

    local @temp = split($sep,$cadeia);

    @temp = sort @temp;


    local $result = $temp[0];

    for ($i=1; $i<=$#temp; $i++) {
        if (($temp[$i] ne $temp[$i-1]) && ($temp[$i] ne "")) {
           $result .= $con . $temp[$i];
           }
    }
    return $result;
}

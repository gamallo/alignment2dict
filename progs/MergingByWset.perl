#!/usr/bin/perl 

##Toma como entrada pipe o ficheiro de centroides.

## O resultado é o ficheiro de centroides onde se juntam os ficheiros que têm o mesmo wset 


$i=0;
while ($line = <STDIN>) {
  chop $line;
  ($node, $card, $wset, $cset, $idf) =  ($line =~ /([^ ]+) <([0-9]*)=([^ ]+)> ([^ ]+) ([^ ]+)/)  ;
  $Centroides{$node}++;
  $Vector[$i] = $node;
 
  $Escrever{$node} = $line;
  
  @listaWords = split ('\|', $wset) ;
  for ($j=0;$j<=$#listaWords;$j++) {
      $Wset{$node}{$listaWords[$j]}++;
  }
  $Wordset{$node} = "<$card=$wset>";
  $Cset{$node} = $cset;
  $Card{$node} = $card;
  $Idf{$node}  = $idf;
 
  $i++;
 # print STDERR "$node :: $wset :: $cset ::$idf\n";

}

print STDERR "lemos #$i# centroides\n";

$count=0;
foreach $node1 (keys %Centroides) {
    $NewCset{$node1}= "" ;
    ($wset) = ($Wordset{$node1} =~ /<[0-9]*=([^ ]+)>/);
    
    foreach $node2 (keys %Centroides) {
        
        
	if ( ($node1 ne $node2) &&  ($Card{$node1} == $Card{$node2}) ) {
           $found=0;
           $j=0;
           @listaWords = split ('\|', $wset) ;
           while ( ($j<=$#listaWords) && (!$found) )   {   
               if (!defined $Wset{$node2}{$listaWords[$j]}) {
                  # print STDERR "okk: $Wordset{$node1} -- $Wordset{$node1} \n";
                   $found=1;
                   $j++
	       }
               else {$j++}
	   }
	
           if (!$found) {
                 ### os wsets sao iguais.
             # print STDERR  "mesmo wset: $node1 - $node2\n";
	      $NewCset{$node1} .= $Cset{$node2}; 
               delete $Centroides{$node1} ;
	      $count++;
	    }
        }
        
      
    }
     if ($NewCset{$node1} ne "") {	
	 
	   $Cset{$node1} = $Cset{$node1} . "|" .  $NewCset{$node1} ;
           $Cset{$node1} = sortAndUniq('\|','|',$Cset{$node1});
	   $Escrever{$node1} = "$node1 $Wordset{$node1} $Cset{$node1} $Idf{$node1}\n";
           #print "$Escrever{$node1} \n";
           $N++;
           
     }
     
}        
    print STDERR "centroides modificados:: : #$N#\n";
    print STDERR "acabou as comparaçoes :: centroides removidos: #$count#\n";

foreach $node (@Vector) {
    if (defined $Centroides{$node}) {
	print "$Escrever{$node}\n";
    }
}


sub pertence {
    local ($subcadeia) = $_[0];
    local ($cadeia) = $_[1];

    $temp = "|" . $subcadeia . "|";
    if (index ($cadeia."|", $temp) ==-1) {
        return 0;
    }
    else {
        return 1;
    }
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

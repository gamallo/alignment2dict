#!/usr/bin/perl

# LE O FICHEIRO FREQ E DEIXA AQUELES CONTXS QUE TÊM UMA FREQUENCIA ENTRE DOUS THRESHOLDS E ELIMINA PALAVRAS POUCO FREQUENTES,



#lê um ficheiro com todos os freqs (cntx pal freq) (pipe)


##threshold minimo: 2  (num. minimo de palavras)
$th1 = shift(@ARGV);
#threshold maximo 2000
$th2 = shift(@ARGV);
#theshold de palavras: 5
$th3 = shift(@ARGV);



$freq="";
$numPals=0;
while ($line = <STDIN>) {
      chomp($line);
      ($template, $word, $freq) = split (" ", $line);
      
      $word =~ s/_[NVA]\#//;
      $Templates{$template} .= "|" . $word;
      if (!defined $Words{$word}) {
	  $numPals++;
      }
      $Words{$word}++;
      $Dico{$template}{$word} = $freq;


      #print STDERR "$Template{$cntx2}\n";
}


$countMIN=0;
$countMAX=0;
$count=0;
foreach $t (sort keys %Templates) {
   
  (@words) = split ('\|', $Templates{$t});
    #$media = ($#words / $numPals);
     
    if ($#words <= $th1) {
      	$countMIN++;
       # print STDERR "#MIN: $t#\n";
         
    } 
    elsif ($#words >= $th2) {
      	$countMAX++;
        print STDERR "#MAX: $t#\n";
    }   
    else {
      
       foreach $w (keys %{$Dico{$t}}) {  
	 if ( ($Dico{$t}{$w} ne "") && ($Words{$w} >= $th3) ) {
            print "$t $w $Dico{$t}{$w} \n";
            $Found{$t}++;
	  }
       }
       if (defined $Found{$t}) {
          $count++;
       }      
    }
  
      
} 


print STDERR "MIN cntx removidos: ##$countMIN##\n";
print STDERR "MAX cntx removidos: ##$countMAX##\n";
print STDERR "numero total de pals: ##$numPals##\n";
print STDERR "numero de contextos: ##$count##\n";
print STDERR "foi gerado o ficheiro filtrado de contextos-pal-freq\n";

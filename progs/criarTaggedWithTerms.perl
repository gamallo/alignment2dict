#!/usr/bin/perl

# MODIFICA O ARQUIVO DE FREQUENCIAS ENGADINDO OS TERMOS
#lê um texto taggeado com TreeTagger
#escreve o mesmo textos com os termos
#tem um argumento (arg) : a lista de termos


$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro não pode ser aberto: $!\n";


#$Borderline="Fp";
$Borderline= shift(@ARGV);

while ($line = <FILE>) {
    chop($line);
    ($terms, $prob, $tags) = split ("\t", $line);
    (@tmp) = split (" ", $terms);
    
    if ($#tmp > 0) {
       for ($i=0;$i<=$#tmp;$i++) {
         $termo .= $tmp[$i] . "\@";
       }
       $termo =~ s/\@$//;
       print STDERR "$termo\n";
       $Termos{$termo}++
    }
    $termo="";
}

while ($line = <STDIN>) {
      chop($line);
      ($token, $lema, $tag) = split (" ", $line);

      if ($tag ne $Borderline) {
         $Forma[$i] = $token;
         $Tag[$i] = $tag;
         $Lema[$i] = $lema;
         $i++
      }
      elsif ($tag eq $Borderline) {

         for ($j=0;$j<=$#Forma;$j++) {
             $term3 = "$Lema[$j]\@$Lema[$j+1]\@$Lema[$j+2]";
             $term2 = "$Lema[$j]\@$Lema[$j+1]";
             $forma3 = "$Forma[$j]\@$Forma[$j+1]\@$Forma[$j+2]";
             $forma2 = "$Forma[$j]\@$Forma[$j+1]";
             if (defined $Termos{$term3}) {
               if ($Tag[$j] =~ /^V/) {
                 print "$forma3 $term3 V\n";
               }
               else{
                 print "$forma3 $term3 NOUN\n";
               }
               $j += 2;
            }
            elsif (defined $Termos{$term2}) {
              if ($Tag[$j] =~ /^V/) {
                 print "$forma2 $term2 V\n";
              }
              else {
                 print "$forma2 $term2 NOUN\n";
              }                  
              $j += 1;
            }
            else {
               print "$Forma[$j] $Lema[$j] $Tag[$j]\n"
            }
         }
     for ($i=0;$i<=$#Forma;$i++) {
          delete $Forma[$i];
          delete $Tag[$i];
          delete $Lema[$i]
     }
     $i=0;
     print "\. \. $Borderline\n";
     }

} 



print STDERR "foi gerado o ficheiro com termos taggeados\n";

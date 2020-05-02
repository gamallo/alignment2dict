#!/usr/bin/perl -w


$file = shift(@ARGV);
$prefix = shift(@ARGV);
open (FILE, $file) or die "O ficheiro não pode ser aberto: $!\n";

$sim = 0;
$th = 0.40;
$globalCount = 0;


$i=0;
while (<STDIN>) {
  chop $_;
  ($word1, $sim, $word2, $cset) = ($_ =~ /([^ ]+) ([^ ]+) ([^ ]+) <[0-9]*=([^ ]+)>/); 
  $bc{$word1, $word2} = $cset;
  $bcWords{$word1} .= $word2 . " ";
}

print STDERR "----  basic classes carregadas ---- \n";


$i=0;
while ($line = <FILE>) {
  chop $line;
  ($word1, $sim, $word2, $cset) = ($line =~ /([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)/);
  $cent{$word1, $word2} = $cset;
  $centWords{$word1} .= $word2 . " ";
} 

print STDERR "---- centroides carregados ---- \n";

$wset = "";
$cont =0;
foreach $w1 (keys %centWords) {
   printf STDERR "<%6d>\r",$globalCount if ($globalCount++ % 100 == 0);
   $wset = "|" . $w1;
   #$contarJOINT = 0;
   @cWords = split (" ", $centWords{$w1});
   @bWords = split (" ", $bcWords{$w1});
   
   for ($i=0;$i<=$#cWords;$i++) {

        $contarJOINT = 0;
        $csetCENT = $cent{$w1, $cWords[$i]};
        #$wset .= "|" . $cWords[$i];
         for ($j=0;$j<=$#bWords;$j++) {
             #print STDERR "##$bWords[$j]##\n";
	     if (defined $bc{$w1, $bWords[$j]}) {
               $csetBC = $bc{$w1, $bWords[$j]};
               printf STDERR "BEFORE $cWords[$i] -- $bWords[$j]  : $wset\n";
              # if ( ($cREL[$i] ne $bREL[$j]) && (!(defined $cent{$r1, $bREL[$j]})) &&

                if ( ($cWords[$i] ne $bWords[$j])  &&  

                 intersects($csetCENT, $csetBC) 
                   ) {
                printf STDERR "** $cWords[$i] -- $bWords[$j]  : $wset\n";
                 $wset .= "|" . $cWords[$i];
                 $wset .= "|" . $bWords[$j];
                 $contarJOINT++;
                # delete $cent{$w1, $bWords[$j]};
                 delete $bc{$w1, $bWords[$j]};
                # print STDERR "BEFORE: $csetCENT -- $csetBC: $wset\n";
                 $csetCENT = intersectar($csetCENT, $csetBC);
                # print STDERR "INTERSECT: $csetCENT \n";
	      }
	     }

         }

         if ($contarJOINT > 0) { 
              $reunionWSET = sortAndUniq('\|','|',$wset);
              @wset = split ('\|', $reunionWSET);
              $id = $prefix . ++$cont;
              printf "%s <%d=%s> \|%s %s\n", $id,  $#wset,  $reunionWSET, $csetCENT, $id;
              $wset = "|" . $w1;
         }  
      }
    


}

  #printf STDERR "- numero centroides : $n\n";


sub intersects {
    local ($set1) = $_[0];
    local ($set2) = $_[1];

    local @temp1;
    local $i;
    local $count= 0;

   @temp1 = split(/\|/, $set1);
   @temp2 = split(/\|/, $set2);

   
  $i=0;
   $hasIntersection = 0;
    while ($i<=$#temp1) {
      if ($temp1[$i] eq "") { $i++;}
      elsif (index($set2."|", "|".$temp1[$i]."|") ==-1) {
	    $i++;
      }
      else {
           $count++;
           $i++;
      }
    }
    
    if ($#temp1 >= $#temp2) {
	$card = $#temp2 + 1;
    }
    else {$card = $#temp1 + 1}

    $maxCount = ($card * $th);
   
    if ($count > $maxCount ){

          $hasIntersection = 1;
    }

    #printf STDERR "<%s> intersect <%s> = %s\n", $set1, $set2, $hasIntersection?"TRUE":"FALSE";
   return $hasIntersection;
}




sub intersectar {
    local ($set1) = $_[0];
    local ($set2) = $_[1];

    local @temp1;
    local $i;
    local $intersection;
   # local $count;

   @temp1 = split(/\|/, $set1);
#   @temp2 = split(/\|/, $set2);

   
   $i=0;

    $intersection = "";
    while ($i<=$#temp1) {
      if ($temp1[$i] eq "") { $i++;}
      elsif (index("|" . $set2."|", "|".$temp1[$i]."|") ==-1) {
	    $i++;
      }
      else {
           $intersection .= "|" . $temp1[$i];
           $i++;
      }
    }
    
 
   return $intersection;
}



sub sortAndUniq {
    local ($sep) = $_[0];
    local ($con) = $_[1];
    local ($cadeia) = $_[2];
    local $i;
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

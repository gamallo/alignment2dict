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
  ($rel1, $sim, $rel2, $wset) = ($_ =~ /([^ ]+) ([^ ]+) ([^ ]+) <[0-9]*=([^ ]+)>/); 
  $bc{$rel1, $rel2} = $wset;
  $bcREL{$rel1} .= $rel2 . " ";
}

print STDERR "----  basic classes carregadas ---- \n";


$i=0;
while ($line = <FILE>) {
  chop $line;
  ($rel1, $sim, $rel2, $wset) = ($line =~ /([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)/);
  $cent{$rel1, $rel2} = $wset;
  $centREL{$rel1} .= $rel2 . " ";
} 

print STDERR "---- centroides carregados ---- \n";

$cset = "";
$cont =0;
foreach $r1 (keys %centREL) {
   printf STDERR "<%6d>\r",$globalCount if ($globalCount++ % 100 == 0);
   $cset = "|" . $r1;
   $contarJOINT = 0;
   @cREL = split (" ", $centREL{$r1});
   @bREL = split (" ", $bcREL{$r1});
   for ($i=0;$i<=$#cREL;$i++) {
        $wsetCENT = $cent{$r1, $cREL[$i]};
        $cset .= "|" . $cREL[$i];
         for ($j=0;$j<=$#bREL;$j++) {
	     if (defined $bc{$r1, $bREL[$j]}) {
               $wsetBC = $bc{$r1, $bREL[$j]};
               if ( ($cREL[$i] ne $bREL[$j]) && (!(defined $cent{$r1, $bREL[$j]})) &&
                  intersects($wsetCENT, $wsetBC) 
                   ) {
         #       printf STDERR "** $rel[$i] --  $rel[$k] : $wsetBC\n";
                 $cset .= "|" . $bREL[$j];
                 $contarJOINT++;
                 delete $bc{$r1, $bREL[$j]};
                 $wsetCENT = intersectar($wsetCENT, $wsetBC);
               #  print STDERR "INTERSECT: $wsetCENT - $wsetBC: $cset\n";
	      }
	     }

         }
}
         if ($contarJOINT > 0) { 
              $reunionCSET = sortAndUniq('\|','|',$cset);
              @cset = split ('\|', $reunionCSET);
              $id = $prefix . ++$cont;
              printf "%s <%d=%s> \|%s %s\n", $id,  $#cset,  $reunionCSET, $wsetCENT, $id;
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

 #   printf STDERR "<%s> intersect <%s> = %s\n", $set1, $set2, $hasIntersection?"TRUE":"FALSE";
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

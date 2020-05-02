#!/usr/bin/perl -w

$currCen  = "";
$countCen = 0;
#$currOrder = 0;
$globalCount = 0;
$th = 0.40;

while (<STDIN>) {
  chop $_;
  ($rel1, $sim, $rel2, $wset) = ($_ =~ /([^ ]+) ([^ ]+) ([^ ]+) <[0-9]*=([^ ]+)>/); 

  printf STDERR "<%6d>\r",$globalCount if ($globalCount++ % 100 == 0);

 if ($currCen ne $rel1) {
    for $i (1..$countCen) {
      printf "%s %s %s %s\n",$cen[$i]{c1},$cen[$i]{sim},$cen[$i]{c2},$cen[$i]{ws};
    }
    $currCen  = $rel1;
    $countCen = 0;
    #$currOrder = 0;
  }

  #$currOrder++;
  $found = 0;
  $pos = 1;
  while ( !$found && ($pos <= $countCen)) {
    if (intersects($wset, $cen[$pos]{ws})) { $found = 1; }
    else { $pos++; }
  }

  if (!$found) {
     $countCen++;
     $cen[$countCen]{c1} = $rel1;
     $cen[$countCen]{sim} = $sim;
     $cen[$countCen]{c2} = $rel2;
     $cen[$countCen]{ws} = $wset;
    # $cen[$countCen]{ord} = $currOrder;
  }
}

#
# dados do último contexto gerado...
#

for $i (1..$countCen) {
   printf "%s %s %s %s\n",$cen[$i]{c1},$cen[$i]{sim},$cen[$i]{c2},$cen[$i]{ws};
}

sub intersects {
    local ($set1) = $_[0];
    local ($set2) = $_[1];

    local @temp1;
    local $i;
    local $count=0;

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

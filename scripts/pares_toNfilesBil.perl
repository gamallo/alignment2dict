#!/usr/bin/perl 

$N    = shift(@ARGV);
$ling1   = shift(@ARGV);
$ling2   = shift(@ARGV);


$pref = shift(@ARGV);
$arq  = shift(@ARGV); #obtem parametro passado por linha de comando

open(PFILE, $arq) || die "Can't open search-patterns: $!\n";

$output = "00";

for $i (0..$N-1) {
  open $output[$i], "|gzip -c >$pref$output" or die "nao consegui abrir para escrita __filePares$output!";
  $output++;
}

while (<PFILE>) { #le cada linha do arquivo
  @cntxList = split(" ",$_);
  for $i (0..$#cntxList) {
    for $j ($i+1..$#cntxList) {
        $k = length($cntxList[$i].$cntxList[$j]) % $N;
        
        ##so para pares bilingues 
        ($p1, $l1) = split("\#", $cntxList[$i]);
        ($p2, $l2) = split("\#", $cntxList[$j]);
        #print STDERR "$l1 -- $l2  // $cntxList[$i] -- $cntxList[$j]\n";
       # if ( ($l1 ne $l2) && (!defined $found{$cntxList[$i],$cntxList[$j]}) ) {
          if  ($l1 ne $l2 ) {
         ### fim
	  # print STDERR "OKK: $l1 -- $l2:  $cntxList[$i] --  $cntxList[$j]\n";
	      printf { $output[$k] } "%s %s\n", $cntxList[$i], $cntxList[$j] if ($l1 eq $ling1);
	      printf { $output[$k] } "%s %s\n", $cntxList[$j], $cntxList[$i] if ($l2 eq $ling1);
           #$found{$cntxList[$i],$cntxList[$j]}++;
        }
     }
  }
}


for $i (0..$N) {
  close $output[$i];
}


#!/usr/bin/perl 

$N    = shift(@ARGV);
$pref = shift(@ARGV);
#$arq  = shift(@ARGV); #obtem parametro passado por linha de comando

#open(PFILE, $arq) || die "Can't open search-patterns: $!\n";

$output = "00";

for $i (0..$N-1) {
  open $output[$i], "|gzip -c >$pref$output" or die "nao consegui abrir para escrita __tmpPares_$output!";
  $output++;
}

while (<>) { #le cada linha de stdin
  chop $_;
  $line=$_;
  @cntxList = split(" ",$_);
  $k = length($cntxList[$i]) % $N;
  printf { $output[$k] } "%s\n", $line;
}


for $i (0..$N) {
  close $output[$i];
}


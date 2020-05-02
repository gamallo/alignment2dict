#!/usr/bin/perl

while (<>) { #le cada linha do arquivo
  ($pal, $cntx, $freq) = split(" ",$_);
  push @{ $dic{$pal}}, $cntx;
}

foreach $rel (keys %dic) {
  if ($#{$dic{$rel}}>1)    # só no caso da palavra ocorrer em pelo menos dois conte
    {
#      printf "<%s-%d>", $rel,$#{$dic{$rel}}+1;
       for $i (0..$#{$dic{$rel}}) {
           printf " %s", $dic{$rel}[$i];
       }
       printf "\n";
     }
}

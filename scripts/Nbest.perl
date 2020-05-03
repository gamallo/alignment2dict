#!/usr/bin/perl 

$N=shift(@ARGV);

#$count = 0;

while (<>) {
  chop $_;
  ($pal1, $pal2, $sim) = split (" ", $_) ; 
  $pal1 =~ s/\#[\w]+$//;
  $pal2 =~ s/\#[\w]+$//;
  $dico{$pal1}{$pal2} = $sim;
   
  
}


foreach $p1 (keys %dico) {
     $Count{$p1} = 1;
     foreach $p2 (sort {$dico{$p1}{$b} <=>
                      $dico{$p1}{$a} }
                  keys %{ $dico{$p1} }) {

         $p2 =~ s/\#[\w]+$//;
	 #print STDERR "#$p1# - #$p2# - $dico{$p1}{$p2}\n";
          
           if ($Count{$p1} <= $N){
                   $Count{$p1}++;
	   }
     }
     #delete $dico{$p1};
     #delete $Count{$p1};
}

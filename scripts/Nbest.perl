#!/usr/bin/perl 

$N=shift(@ARGV);

#$count = 0;

while (<>) {
  chomp $_;
  ($pal1, $pal2, $sim) = split (" ", $_) ;
  #print STDERR "$pal1 - $pal2\n";
  ($pal1, $tmp) = split ('\#', $pal1);
  ($pal2, $tmp) = split ('\#', $pal2);
  #$pal2 =~ s/\#[\w]+$//;
  #print STDERR "$pal1 - $pal2\n";
  $dico{$pal1}{$pal2} = $sim;
   
  
}


foreach $p1 (keys %dico) {
     $Count{$p1} = 1;
     foreach $p2 (sort {$dico{$p1}{$b} <=>
                      $dico{$p1}{$a} }
                  keys %{ $dico{$p1} }) {

        
	# print STDERR "#$p1# - #$p2# - $dico{$p1}{$p2}\n";
          
	 if ($Count{$p1} <= $N){
	           print "$p1 $p2 $dico{$p1}{$p2}\n";
                   $Count{$p1}++;
	   }
     }
     #delete $dico{$p1};
     #delete $Count{$p1};
}

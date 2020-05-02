#!/usr/bin/perl -w

use strict; 
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';
use utf8;

my $ling1 = shift(@ARGV);
my $ling2 = shift(@ARGV);

my %Dico;
my $count=1;
while (my $entry = <STDIN>) {
    my ($seg1, $seg2) = split ('\t', $entry);
    #print STDERR "-#$seg1#\n";
    #print STDERR "-#$seg2#\n";
    
    # print STDERR  $entry;

    
    my @tok1 = tokenizer ($seg1);
    foreach my $tok (@tok1) {
#	print STDERR "$tok\n";
	$tok = $tok . "#" . $ling1;
	$Dico{$tok}{$count}++;
    }
    my @tok2 = tokenizer ($seg2);
    foreach my $tok (@tok2) {
	$tok = $tok . "#" . $ling2;
	$Dico{$tok}{$count}++;
#	print STDERR "$tok\n";
    }

    $count++;
}

foreach my $tok (sort keys %Dico) {
    foreach my $seg (sort keys %{$Dico{$tok}}) {
	print "$seg $tok $Dico{$tok}{$seg}\n";
    } 
}

sub tokenizer {
    my ($line) = @_;
    $line = SeparateAllComma($line);
    $line = SeparateAllPointComma($line);
    $line = SeparateTwoPoint($line);
    $line = SeparateFinalPoint($line);
    $line = SeparateAllBracket($line);
    $line = SeparateAspas($line);
    $line = SeparateSeveral($line);

    $line = lc $line;

    my @saida = split(" ", $line);
    return @saida;

}



sub SeparateSeveral {
    my ($x) = @_;

       $x =~ s/\</ \< /g;
       $x =~ s/\>/ \> /g;
       $x =~ s/\=/ \= /g;
       $x =~ s/\'/ \' /g;
       $x =~ s/\`/ \` /g;
       $x =~ s/\?/ \? /g;
       $x =~ s/\#/ \# /g;
       $x =~ s/\!/ \! /g;
       $x =~ s/\¡/ \¡ /g;
       $x =~ s/\¿/ \¿ /g;
       return $x;
}

sub SeparateAllComma {
    my ($x) = @_;

       $x =~ s/\,/ \,/g;
       return $x;
}


sub SeparateAllPointComma {
    my ($x) = @_;

       $x =~ s/\;/ \;/g;
       return $x;
}

sub SeparateTwoPoint {
    my ($x) = @_;

       $x =~ s/\:/ \:/g;
       return $x;
}

sub SeparateAllBracket {
    my ($x) = @_;

       $x =~ s/\(/ \( /g;
       $x =~ s/\)/ \) /g;
       return $x;
}


sub SeparateFinalPoint {
    my ($x) = @_;

       $x =~ s/\. [\w]*/ \. /g;
       $x =~ s/\.$/ \./g;
       return $x;
}

sub SeparateAspas {
    my ($x) = @_;

       $x =~ s/\"[ ]*/\" /g;
       $x =~ s/[ ]*\"/ \"/g;
       return $x;
}



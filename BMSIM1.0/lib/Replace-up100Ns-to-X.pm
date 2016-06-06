#!/usr/bin/perl
use strict;
use warnings;

die "#usage:perl $0 <input.fa> <output.fa> \n" unless @ARGV==2; 

my $FA=$ARGV[0];
open (FA, "<$FA")or die "can't open $FA !";
my @G = <FA>;
close FA;
my $head=shift @G;#ȥ����ͷ���������
chomp $head;
my @Gs;
foreach my $g (@G) 
	{
		chomp $g;
		if ($g=~/>.*/) 
			{
				push (@Gs,"X");#�滻fa�ı�ͷΪX
			}
		else
			{
				push (@Gs,$g);
			}
	}
my $G=join ("",@Gs);
#������100Ns��gap��ΪX
#$G =~ s/N+N{99}/X/ig;
#my $count=0;
#$count=$G =~ s/N+N{99}/X/ig;#�滻>=100N��gap
#print "$count\n";
my $outfile=$ARGV[1];
open (OUT, ">$outfile")or die "can't open $outfile !";
print OUT "$head\n$G\n";
close OUT;

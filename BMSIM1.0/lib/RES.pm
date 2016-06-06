#!/usr/bin/perl
package RES;


use strict;
use warnings;
use List::Util qw/sum/;
use Math::Random qw(:all);#�������������ģ��
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5; # number of significant digits to be returned


sub RES1 
	{
	
		my ($subunder1000_che,$subunder1500_che,$subpos_str) = @_; 

		#########�ֱ��ʣ�����10%��1kb���µ�ø��λ�㣬80%��1kb-1.5kb��λ�㣬����1500bp���µ�λ��λ��ȡ��ֵ�����/2��
		my $dataset_length=@$subpos_str;#��ø��λ����=$dataset_length-1
		my $confused_num=0;
		my $confused_length=0;
		my @Numsites_new=();
		my @label_size=();

		#������ø��λ�����������
		for (my $u=0;$u<$dataset_length-1;$u++) 
		{
			my $label_size=$$subpos_str[$u+1]-$$subpos_str[$u]+1;
			push (@label_size,$label_size);
		}
		#print "RES_before\t@$subpos_str\n";


		#ͳ�Ʋ�ͬ����ø��λ��
		my @Size1000_pre=grep{$label_size[$_]<=1000} 0..$#label_size;#��С��1k�ļ���±��������
		my @Size1500_pre=grep{$label_size[$_]>1000 && $label_size[$_]<=1500} 0..$#label_size;#������1kС��1.5k�ļ���±��������
		my $S1000_len=scalar(@Size1000_pre);
		my $S1500_len=scalar(@Size1500_pre);
		my $S1000_remain=int($S1000_len*$subunder1000_che);#$under1000�ɲ����ļ����
		my $S1500_remain=int($S1500_len*$subunder1500_che);#$under1500�ɲ����ļ����
		my $high1000=0;
		my $high1500=0;
		my @S1000_remain=();
		my @S1500_remain=();
		#����������ø��λ�������
		if ($S1000_len==0) #���û��С��1k�ĵ�
			{
				@S1000_remain=();
			}
		else#��С��1k�ĵ�
			{
				$high1000=$S1000_len-1;
				@S1000_remain=random_uniform_integer($S1000_remain, 0, $high1000);

			}

		if ($S1500_len==0) #���û�д���1kС��1.5k�ĵ�
			{
				@S1500_remain=();
			}
		else#����д���1kС��1.5k�ĵ�
			{
				$high1500=$S1500_len-1;
				@S1500_remain=random_uniform_integer($S1500_remain, 0, $high1500);
			}
		
		my @merge=(); 
		#Ѱ��Ҫ�����Ľ��ڵ�<1kb��id������@merge
		#my $Size1000_pre_len=@Size1000_pre;
		for (my $j=0;$j<$S1000_len;$j++) 
		{
			if (grep{$j eq $_} @S1000_remain) 
			{
				next;
			}
			else 
			{
				push (@merge,$Size1000_pre[$j]);
			}
		}

		#Ѱ��Ҫ�����Ľ��ڵ����1kbС��1.5kb��id������@merge
		#my $Size1500_pre_len=@Size1500_pre;
		for (my $k=0;$k<$S1500_len;$k++) 
		{
			if (grep{$k eq $_} @S1500_remain) 
			{
				next;
			}
			else 
			{
				push (@merge,$Size1500_pre[$k]);
			}
		}
		
		#�ϲ�λ�㣬ȡ��ֵ
		my @PosNew=();
		my @MerPos0=();
		my ($MerStr,$MerEnd,$MerLen,$MerPos,$v1,$v2,$MerPos0);
		for (my $v=0;$v<$dataset_length;$v++) 
		{
			if (grep{$_ eq $v} @merge) 
			{
				$v1=$v+1;#�����һ�����Ƿ���merge��
				while (grep{$_ eq $v1} @merge) #merge����������������
				{
					$v2=$v1+1;
					$v1=$v2;#�ټ����һ��λ���Ƿ���merge��
				}
				$MerStr=$v;
				$MerEnd=$v1;
				$MerLen=$MerEnd-$MerStr+1;
				@MerPos0=@$subpos_str[eval($MerStr)..eval($MerEnd)];
				$MerPos0=sum(@MerPos0);
				$MerPos=$MerPos0/$MerLen;
				push (@PosNew,$MerPos);
		
				$v=$v1;
				#if ($v1==$dataset_length-1) #���Ϊ���һ���㣬������ѭ��
				#	{
						#push (@PosNew,$$subpos_str[$v1]);#�����һ������������
				#		last;
				#	}
			}
			else 
			{
				$MerPos=$$subpos_str[$v];#���úϲ���
				push (@PosNew,$MerPos);
			}
		}
		#print "RES_after\t@PosNew\n";

		#return ($return,$subM_ID);
		return (@PosNew);
	}#��Ӧsub


sub RES2 
	{
		#�޸Ĵ�����������ֲ�����ȥ��
		my ($mean,$sd,$subpos_str) = @_; #�ֱ��ʾ�ֵ�ͷ���

		#########�ֱ��ʣ�����10%��1kb���µ�ø��λ�㣬80%��1kb-1.5kb��λ�㣬����1500bp���µ�λ��λ��ȡ��ֵ�����/2��
		my $dataset_length=@$subpos_str;#��ø��λ����=$dataset_length-1
		my $confused_num=0;
		my $confused_length=0;
		my @Numsites_new=();
		my @label_size=();
		my @merge=(); 

		#������ø��λ�����������
		for (my $u=0;$u<$dataset_length-1;$u++) 
		{
			my $label_size=$$subpos_str[$u+1]-$$subpos_str[$u]+1;
			push (@label_size,$label_size);
		}
		#print "RES_before\t@$subpos_str\n";

		#Ѱ��Ҫ�����Ľ��ڵ����1kbС��1.5kb��id������@merge
		my $label_size_len=@label_size;
		for (my $l=0;$l<$label_size_len;$l++) 
		{
			#�����ȱ�׼��
			my $Nlabel_size=($label_size[$l]/1000-$mean)/$sd;#�Ƚ�����ת��Ϊkb
			my $p=1-&uprob ($Nlabel_size);#������̬�ֲ������ܶȺ�����������ܶ�,����Խ���ɹ�����Խ��
			#print "label_size=$label_size[$l]\tp=$p\n";
			my $rbinom=random_binomial(1,1,$p);#����ǰ����ĸ��ʽ��а�Ŭ��ʵ�飬
			if ($rbinom==1)#Ϊ1��ʱ���ʾ�ֱܷ� 
			{
				next;
			}
			else 
			{
				push (@merge,$l);#���±��������
			}
		}
		
		#�ϲ�λ�㣬ȡ��ֵ
		my @PosNew=();
		my @MerPos0=();
		my ($MerStr,$MerEnd,$MerLen,$MerPos,$v1,$v2,$MerPos0);
		for (my $v=0;$v<$dataset_length;$v++) 
		{
			if (grep{$_ eq $v} @merge) 
			{
				$v1=$v+1;#�����һ�����Ƿ���merge��
				while (grep{$_ eq $v1} @merge) #merge����������������
				{
					$v2=$v1+1;
					$v1=$v2;#�ټ����һ��λ���Ƿ���merge��
				}
				$MerStr=$v;
				$MerEnd=$v1;
				$MerLen=$MerEnd-$MerStr+1;
				@MerPos0=@$subpos_str[eval($MerStr)..eval($MerEnd)];
				$MerPos0=sum(@MerPos0);
				$MerPos=$MerPos0/$MerLen;
				push (@PosNew,$MerPos);
		
				$v=$v1;
				#if ($v1==$dataset_length-1) #���Ϊ���һ���㣬������ѭ��
				#	{
						#push (@PosNew,$$subpos_str[$v1]);#�����һ������������
				#		last;
				#	}
			}
			else 
			{
				$MerPos=$$subpos_str[$v];#���úϲ���
				push (@PosNew,$MerPos);
			}
		}
		#print "RES_after\t@PosNew\n";

		return (@PosNew);

	}#��Ӧsub

sub uprob { # Upper probability   N(0,1^2)
	my ($x) = @_;
	return &precision_string(&subuprob($x));
}

sub subuprob {
	my ($x) = @_;
	my $p = 0; # if ($absx > 100)
	my $absx = abs($x);

	if ($absx < 1.9) 
		{
		$p = (1 +
			$absx * (.049867347
			  + $absx * (.0211410061
			  	+ $absx * (.0032776263
				  + $absx * (.0000380036
					+ $absx * (.0000488906
					  + $absx * .000005383)))))) ** -16/2;
		} elsif ($absx <= 100) 
		{
		for (my $i = 18; $i >= 1; $i--) 
			{
			$p = $i / ($absx + $p);
			}
		$p = exp(-.5 * $absx * $absx) 
			/ sqrt(2 * PI) / ($absx + $p);
		}

	$p = 1 - $p if ($x<0);
	return $p;
}

sub log10 {
	my $n = shift;
	return log($n) / log(10);
}

sub precision {
	my ($x) = @_;
	return abs int(&log10(abs $x) - SIGNIFICANT);
}

sub precision_string {
	my ($x) = @_;
	if ($x) {
		return sprintf "%." . &precision($x) . "f", $x;
	} else {
		return "0";
	}
}

1

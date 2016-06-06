#!/usr/bin/perl
package ErrorMOD;

use strict;
use warnings;
use List::Util qw/sum/;
use Math::Random qw(:all);#�������������ģ��

sub FN
	{
		my ($p_FNsub,$mol_pre_FN) = @_; 
		my @mol_FN=();

		###�������ȱ��ø��λ��ģ������ȼ���FN��FP�ٿ�������
		####����FN������λ�㣬Binomial(p)������rbinom(n,1,0.8)����n���������nΪÿ�����ӵ���ø��λ��),��ֵΪ0���ĵ�miss��
		#���볤�ȷֲ���������������ֵ������������������
		my $n_FN=scalar(@$mol_pre_FN)-1;#ø��λ�����
		#��λ��miss��
		#my $mol_len=$n_FN+1;
		for (my $t=0;$t<$n_FN;$t++) 
		{
			my $rbinom=random_binomial(1,1,$p_FNsub);
			if ($rbinom == 1) 
				{
					push (@mol_FN,$$mol_pre_FN[$t]);
				}

		}
		push (@mol_FN,$$mol_pre_FN[-1]);#�����һ��ø��λ���������
		my $mol_pre_FN_len=@$mol_pre_FN;
		my $mol_FN=@mol_FN;
		#print "FN0=$mol_pre_FN_len\tFN1=$mol_FN\n";
		#foreach my $mol_pre_FN (@$mol_pre_FN) 
		#	{
		#		print "mol_pre\t$mol_pre_FN\t";
		#	}
		#	print "\n";
		#foreach my $mol_FN (@mol_FN) 
		#	{
		#		print "mol\t$mol_FN\t";
		#	}
		#	print "\n";
		
		return @mol_FN;#ע�ⷵ�ص�������ø��λ���ܸ�����id���ǲ��Ե�
	}

sub FP
	{
		my ($sublamdaFP,$mol_FP) = @_; 

		#��������λ����
		my $FpApart=0;#��һ��FPλ��
		my $FpPos1=0;
		my $FpPos2=0;
		my @sitePos=();
		my @insert=();

		#��������λ����
		$FpApart=random_exponential(1,$sublamdaFP);#��һ��FPλ���࣬��λΪkb������Ҫת��Ϊbp
		$FpPos2=int($FpPos1+$FpApart*1000);#��ʱ�Ĳ���λ��Ϊ��ʼ����ϼ��(��λ)
		my $mol_len_FP=$$mol_FP[-1];#���ӳ���
		my $Numsites_FP=scalar(@$mol_FP)-1;#ø��λ�����
		#print "FP_before\t";
		#foreach my $FP_before (@$mol_FP) 
		#	{
				#print "$FP_before\t";
		#	}
		#print "\n";
		while ($FpPos2 < $mol_len_FP) #�������λ��С���ܳ�
			{
				while (grep{$_ == $FpPos2} @$mol_FP) #ȥ����ԭʼ���ص��ĵ�
					{
						$FpApart=random_exponential(1,$sublamdaFP);#���²���һ��FPλ��
						$FpPos2=int($FpPos1+$FpApart*1000);
					}
				$Numsites_FP++;#ø��λ�������1
				#����λ��FP
				push (@$mol_FP,$FpPos2);
				#Ѱ�Ҳ���λ���±�
				#@insert=grep{$sitePos[$_]>$FpPos2} 0..$#sitePos;########�޸Ĵ˴���С�ڴ��ʱ��###############
				#splice(@$mol_FP,$insert[0],0,$FpPos2);#����FPλ��
				@sitePos=();
				$FpPos1=$FpPos2;
		
				#�ٲ���FPλ��
				$FpApart=random_exponential(1,$sublamdaFP);#��һ��FPλ����
				$FpPos2=int($FpPos1+$FpApart*1000);#��ʱ�Ĳ���λ��Ϊ��ʼ����ϼ��
		
			}

		#��λ�㰴��С��������
		my @sort_Pos=(sort {$a<=>$b} @$mol_FP);#��ø��λ���������
		#print "FP_after\t";
		foreach my $FP_after (@sort_Pos) 
			{
				#print "$FP_after\t";
			}
		#print "\n";
		return @sort_Pos;
	}


sub Stretch
	{
		my ($sub_m_str,$sub_sd_str,$mol_Str) = @_; 
		###�������죬����rnorm(n,m=1.0,sd=0.02)����n����������ٷֱ����������ÿ�����ӵ�ø��λ��λ�ö������������
		#my @SitePos=();
		#�����ܳ������죬��Ϊӫ����λ�㲻��
		#my @rnorm=random_normal(1, $sub_m_str, $sub_sd_str);#����һ������ٷ���
		my $mol_Str_len=scalar(@$mol_Str);
		#ÿ��ø��λ���������죬��Ϊ�����˶�
		my @sub_pos_str=();
		push (@sub_pos_str,$$mol_Str[0]);
		my $posPre=$$mol_Str[0];
		for (my $s=1;$s<$mol_Str_len;$s++) 
			{
				my $rnorm=random_normal(1, $sub_m_str, $sub_sd_str);#����һ������ٷ���
				$posPre=$posPre+($$mol_Str[$s]-$$mol_Str[$s-1])*$rnorm;
				push (@sub_pos_str,$posPre);
			}

		#my @sub_pos_str = map {$_ * $rnorm[0]} @$mol_Str;#��ÿ��λ���������
		#print "Stretch_before\t@$mol_Str\n";
		#print "Stretch_after\t@sub_pos_str\n";
		return @sub_pos_str;

	}

1;

#!/usr/bin/perl
package SampleBased;

use strict;
use warnings;


###lengths (up 100kb) and labeling signal score (up ��ֵ) 
##���û��ṩ�����ݿ�����ȡ���ڻ����鳤�ȵķ�������
	while($total<$chr_len)#�������з����ܳ��Ƿ����Ⱦɫ���ܳ�
	{
		$n_len=$n_len+100;#�����������μ�����
		@MolLen=random_exponential($n_len,$EXPav);#����ָ���ֲ�
		#@MolLenUp100=grep{$_>=100} @MolLen;#��ȡ����100kb�ķ���
		@MolLenUp100=grep{$_>0} @MolLen;#��ȡ����0kb�ķ���
		$sum=sum @MolLenUp100;
		my $num=@MolLenUp100;
		$total=$sum*1000;
	}

#���û�����SNR��intensity���г�ȡ��Ӧ����ֵ�������RESģ����

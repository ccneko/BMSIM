#!/usr/bin/perl
package Fragile;

use strict;
use warnings;
use Math::Random qw(:all);#�������������ģ��
#use constant PI => 3.1415926536;
#use constant SIGNIFICANT => 5; # number of significant digits to be returned

sub FragileSite 
	{
		#����<250bp������ֵ�ͷ���
		#my ($mean1,$sd1,$mean2,$sd2,$PosSet,$DistanceSet,$OriSet) = @_; #�ֱ��ʾ�ֵ�ͷ���,FragileSiteλ�ã����
		my ($a,$b,$PosSet,$DistanceSet) = @_; #ָ���ֲ���������,FragileSiteλ�ã����

		my $PosSet_length=@$PosSet;#�����λ��
		#my $DistanceSet_length=@$DistanceSet;#�������
		my @FragilePos=(); 
		my ($p,$rbinom,$x)=0;
		for (my $l=0;$l<$PosSet_length;$l++) 
		{
			#��������������perl
			#�ж����������
			#if ($$OriSet[$l] eq "+") #type I fragile
			#{
				#��ȫ����
				#$p=0;

				#��ȫ������
				#$p=1;

				#�ۻ���̬���ѷ�
				#$Nlabel_size=($$DistanceSet[$l]-$mean1)/$sd1;#�Ƚ���������׼��
				#$p=1-&uprob ($Nlabel_size);#���ݾ����������㲻�ϵĸ��ʣ�����Խ�����ϼ��ɹ�����Խ��

				#Τ���ֲ����ѷ�
				#$x=$Nlabel_size/100;#�����ȳ���100ʹ��С��10
				#$p=$a*$b*$x**($b-1)*exp(-$a*$x**$b)#����weibull��ʽ������Ѹ��ʣ�a,b�ֱ�Ϊλ�ò����ͳ߶Ȳ���
				#my $p=$a*$b*$x**($b-1)*exp(-$a*$x**$b);#����weibull��ʽ������Ѹ��ʣ�a,b�ֱ�Ϊλ�ò����ͳ߶Ȳ���

				#ָ���ֲ����ѷ��õ��ɹ�����
				$x=$$DistanceSet[$l];
				$p=1-$a*exp($x*$b);#����ָ���ֲ���ʽ������Ѹ��ʣ�1-���Ѹ��ʵóɹ��������ڰ�Ŭ��ʵ��
				print "x=$x;p=$p\n";

				#���а�Ŭ��ʵ��
				#$rbinom=1;
				$rbinom=random_binomial(1,1,$p);#����ǰ����ĸ��ʽ��а�Ŭ��ʵ�飬
			#}
			#else #type II fragile
			#{
				#�ۻ���̬���ѷ�
				#$Nlabel_size=($$DistanceSet[$l]-$mean2)/$sd2;#�Ƚ���������׼��
				#$p=1-&uprob ($Nlabel_size);#���ݾ����������㲻�ϵĸ��ʣ�����Խ�����ϼ��ɹ�����Խ��
				
				#��ȫ����
				#$p=0;

				#$rbinom=1;
				#$rbinom=random_binomial(1,1,$p);#����ǰ����ĸ��ʽ��а�Ŭ��ʵ�飬
			#}
			if ($rbinom==1)#Ϊ1��ʱ���ʾ���ϣ��˴�����X
			{
				next;
			}
			else #��Ϊ1��ʱ���ʾ���ˣ������滻�ű���Ӧλ�㴦������б�ΪX
			{
				push (@FragilePos,$$PosSet[$l]);#�Ѷ���λ�ô�������
			}
		
		}
		return (@FragilePos);#���ض���λ������

	}#��Ӧsub



1

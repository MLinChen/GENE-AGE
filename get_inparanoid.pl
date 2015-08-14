#!/usr/bin/perl -w
use strict;
open(IN, "E:/共表达网络/ANIMAL/InParanoid.H.sapiens-M/HSA.MMU.txt") or die "$!";
open(OUT, ">E:/共表达网络/ANIMAL/InParanoid.H.sapiens-M/hsa.mmu") or die "$!";

my $groupnum=1;
my $hsa="H.sapiens";
my $sce="S.cerevisiae";
my $hsaid;
my @grouphsa;
my @groupsce;
while (<IN>) {
    chomp $_;
    my @tmp=split /\t/,$_;
    if ($tmp[0]==$groupnum) {
        if ($tmp[3]==1) {
            if ($tmp[2]=~/$hsa/) {
                push @grouphsa,$tmp[4];
            }
            else{
                push @groupsce,$tmp[4];
            }
        }
    }                        
    else{
        for my $i (@grouphsa){
            for (@groupsce){
                print OUT "$i\t$_\t$groupnum\n";
            }
        }
        @grouphsa=();
        @groupsce=();
        $groupnum=$tmp[0];
        if ($tmp[3]==1) {
            if ($tmp[2]=~/$hsa/) {
                push @grouphsa,$tmp[4];
            }
            else{
                push @groupsce,$tmp[4];
            }
        }
    }    
}


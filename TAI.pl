#!/usr/bin/perl -w
use strict;
open(EXP,"E:/Coexp/ANIMAL/DREexp/dreavg.txt") or die "$!";#################
open(AGE,"E:/Coexp/ANIMAL/DREexp/dreage.txt") or die "$!";#################
open(DCI,"E:/Coexp/ANIMAL/RESULT/DRE_HSA70.out") or die "$!";#################
open(OUT1,">E:/Coexp/ANIMAL/DREexp/dre_hsa_tdi.out") or die "$!";#################
open(OUT2,">E:/Coexp/ANIMAL/DREexp/dre_hsa_tdiexp.out") or die "$!";#################
sub log2 {
my $n = shift;
return log($n)/log(2);
}
my %dci=();
while (<DCI>) {
    chomp;
    my @tmp=split /\t/;
    $dci{$tmp[0]}=$tmp[2];############
}
my %age=();
while (<AGE>) {
    chomp;
    my @tmp=split /\t/;
    $age{$tmp[0]}=$tmp[1];
}
my $count=0;
while (<EXP>) {
    #my $lie=0;#
    chomp;
    my @line=();
    @line=split /\t/;
    my $id=shift @line;
    if ((defined $dci{$id})&&(defined $age{$id})) {
        print OUT1 "$id\t";
        print OUT2 "$id\t";
        $count+=1;
        for (@line){
            my $exp=log2($_);
            my $texp=$age{$id}*$exp;
            print OUT1 "$texp\t";
            print OUT2 "$exp\t";
            #$lie+=1;
        }
        print OUT1 "\n";
        print OUT2 "\n";
        #print "$id\t$lie\n";#
    }
}
print "$count\n";






#!/usr/bin/perl -w
use strict;
my ($A,$M)= @ARGV;
open(PS, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/PS/$A") or die "$!";
my %ps;
my @in=<PS>;
shift @in;
for (@in) {
    chomp;
    my @tmp=split /\t/;
    $ps{$tmp[0]}=$tmp[1];
}
sub get_PCC {
    my ($specie,$id,$MR)=@_;
    my $up=0;
    my $down=0;
    my $lost=0;
    my $in=0;
    my @lost;
    open(SPE, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/$specie/$id") or die "$id";
    while (<SPE>) {
        chomp $_;
        my @tmp=split /\t/,$_;
        if ($tmp[1]<=$MR) {
            my $pairid="$tmp[0]";
            if (defined $ps{$tmp[0]}) {
                $up+=$tmp[2]*$ps{$tmp[0]};
                $down+=$tmp[2];
                $in+=1;
            }
            else {
                $lost+=1;
                push @lost,$tmp[0];
            }
        }
        else {
            last;
        }
    }
    close SPE;
    my $cai=$up/$down;
    print "$in\t$lost\n";
    return $cai;
}
open(OUT, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/PS/CAI_$A.out") or die "$!";
open(ID, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/PS/ID_$A") or die "$!";
while (<ID>){
    chomp;
    my $id=$_;
    my $cai=get_PCC($A,$id,$M);
    print OUT "$id\t$cai\n";
}
close OUT;

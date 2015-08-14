#!/usr/bin/perl -w
use strict;
open(AGE, "E:/Hourglass/kaksriceob.txt") or die "ERROR in opening AGE file"; 
open(EXP, "E:/Hourglass/expressionriceobTDI.txt") or die "ERROR in opening EXP file";
open(OUT, ">E:/Hourglass/TDIriceob.txt") or die "ERROR in writing file";
print OUT "Stage\tpse\te\tTAI\n";
my @agefile=<AGE>;
my %age;
for my $line (@agefile) {
    chomp($line);
    my @tmp=split /\t/,$line;
    $age{$tmp[0]} = $tmp[1];
}
print $age{LOC_Os06g09290};
my @expfile=<EXP>;
my $IDs=shift(@expfile);
chomp($IDs);
my @ids=split /\t/,$IDs;
shift (@ids);
for my $l (@expfile){
    my $pse=0;
    my $e=0;
    chomp ($l);
    my @tmp=split /\t/,$l;
    my $stage=shift(@tmp);
    my $len=@tmp;
    for my $i (0..$len-1){
        $e=$e+$tmp[$i];
        $pse=$pse+$age{$ids[$i]}*$tmp[$i];
    }
    my $TAI=$pse/$e;
    print OUT "$stage\t$pse\t$e\t$TAI\n";
}
close AGE;
close EXP;
close OUT;
#!/usr/bin/perl -w
use strict;
open(AF55TAR, q/C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\AF55-S3-S5target.txt/) or die "$!";
open(Q89TAR, q/C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\Q89-S3-S5target.txt/) or die "$!";
open(AF55, q/C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\onlyS3-S5-AF55.txt/) or die "$!";
open(Q89, q/C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\onlyS3-S5-Q89.txt/) or die "$!";
open(JOIN, q/C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\joinS3-S5-AF55-Q89.txt/) or die "$!";
open(WRITEAF, q/>C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\onlyS3-S5-AF55target.txt/) or die "$!";
open(WRITEQ, q/>C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\onlyS3-S5-Q89target.txt/) or die "$!";
open(WRITEJ, q/>>C:\Users\Eric Chen\Desktop\YLmiRNA\2124\24nt结果集\关注\joinS3-S5-AF55-Q89target.txt/) or die "$!";
my @af55tar=<AF55TAR>;
my @q89tar=<Q89TAR>;
my @af55=<AF55>;
my @q89=<Q89>;
my @join=<JOIN>;
for my $af55 (@af55){
    chomp $af55;
    my @af=split /\t/,$af55;
    my $a=$af[0];
    for (@af55tar){
        if (/$a/) {
            print WRITEAF "$_";
        }
    }
}
close WRITEAF;
close AF55;
for $89 (@q89){
    chomp $89;
    my @q=split /\t/,$89;
    my $b=$q[0];
    for (@q89tar){
        if (/$b/) {
            print WRITEQ "$_";
        }
    }
}
close WRITEQ;
close Q89;
for my $join (@join){
    chomp $join;
    my @j=split /\t/,$join;
    my $c=$j[0];
    for (@af55tar){
        if (/$c/) {
            print WRITEJ "$_";
        }
    }
    for (@q89tar){
        if (/$c/) {
            print WRITEJ "$_";
        }
    }
}
close WRITEJ;
close JOIN;
close AF55TAR;
close Q89TAR;



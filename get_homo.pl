#!/usr/bin/perl -w
use strict;
use warnings;
my ($A,$B)=@ARGV;
open(HOMO, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/HOMO/homologene.id") or die "$!";
open(OUT, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/HOMO/$A\_$B") or die "$!";

sub get_taxid{
    my %hash=('SCE',"4932",'HSA',"9606",'MCC',"9544",'MMU',"10090",'DME',"7227",'CEL',"6239");
    if (@_==2){
        my ($a,$b)=@_;
        print "$a\_$hash{$a};$b\_$hash{$b}.\n";
        return ($hash{$a},$hash{$b});
    }
    else{
        print "Only 2 species supported.\n";
    }
}


my ($idA,$idB)=get_taxid($A,$B);
my $groupnum=3;
my @groupA;
my @groupB;
while (<HOMO>) {
    chomp $_;
    my @tmp=split /\t/,$_;
    if ($tmp[0]==$groupnum) {
        if ($tmp[1]==$idA) {
            push @groupA,$tmp[2];
        }
        elsif ($tmp[1]==$idB){
            push @groupB,$tmp[2];
        }
    }                       
    else{
        if (@groupB>1) {
            for my $i (@groupA){
                print OUT "$i\t@groupB\t$groupnum\n";
            }
        }
        elsif (@groupB==1) {
            for my $i (@groupA){
                for (@groupB){
                    print OUT "$i\t$_\t$groupnum\n";
                }
            }
        }
        else {
            print "No $B homologs found in group $groupnum.\n";
        }      
        @groupA=();
        @groupB=();
        $groupnum=$tmp[0];
        if ($tmp[0]==$groupnum) {
            if ($tmp[1]==$idA) {
                push @groupA,$tmp[2];
            }
            elsif ($tmp[1]==$idB){
                push @groupB,$tmp[2];
            }
        }                       
    }    
}
if ((@groupA==0)&&(@groupB==0)) {
    print "finished.\n";
}
else {
    for my $i (@groupA){
        for (@groupB){
            print OUT "$i\t$_\t$groupnum\n";
        }
    }
    print "$groupnum finished.\n";
}
print "$groupnum groups processed. Well done.\n";
close 




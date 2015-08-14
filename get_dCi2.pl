#!/usr/bin/perl -w
use strict;
my ($A,$B,$M)= @ARGV;
sub get_pair_pcc_hash {
    my ($specie,$id)=@_;
    my %hash=();
    open(SPE, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/$specie/$id") or die "$!";
    while (<SPE>) {
        chomp $_;
        my @tmp=split /\t/,$_;
        my $pairid="$id\-$tmp[0]";
        my $pcc=$tmp[2];
        $hash{$pairid}=$pcc;
    }
    close SPE;
    return %hash;
}

sub get_MR_pair {
    my ($specie,$id,$MR)=@_;
    my @pairs=();
    open(SPE, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/$specie/$id") or die "$id";
    while (<SPE>) {
        chomp $_;
        my @tmp=split /\t/,$_;
        if ($tmp[1]<=$MR) {
            my $pairid="$id\-$tmp[0]";
            push @pairs,$pairid;
        }
        else {
            last;
        }
    }
    close SPE;
    return @pairs;
}

sub get_homo_pair_B {
    my @homo_pair;
    my %h=();
    open(H, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/HOMO/$A\_$B\_IN") or die "$!";
    for (<H>){
        chomp $_;
        my @tmpa=split /\t/,$_;
        $h{$tmpa[1]}=$tmpa[0];
    }
    for (@_){
        my @tmp=split /-/,$_;
        my $pairnew="$h{$tmp[0]}\-$h{$tmp[1]}";
        push @homo_pair,$pairnew;    
    }
    return @homo_pair;
    close H;
}

sub get_homo_pair_A {
    my %h=();
    open(H, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/HOMO/$A\_$B\_IN") or die "$!";
    for (<H>){
        chomp $_;
        my @tmpa=split /\t/,$_;
        $h{$tmpa[0]}=$tmpa[1];
    }
    my @tmp=split /-/,$_;
    my $homopair="$h{$tmp[0]}\-$h{$tmp[1]}";   
    return $homopair;
    close H;
}

sub get_uniq{
    my %tmp;
    @tmp{@_}=();
    my @uniq=sort keys %tmp;
    return @uniq;
}

open(OUT, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/$A\_$B/result$M.out") or die "$!";
open(PRO, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/$A\_$B/presult$M.out") or die "$!";
open(HOMO, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/HOMO/$A\_$B\_IN") or die "$!";
my @ho=<HOMO>;
my %homo=();
for (@ho){
    chomp $_;
    my @tmpa=split /\t/,$_;
    $homo{$tmpa[0]}=$tmpa[1];
}

my $count=0;
for (@ho) {
    my @allA=();
    chomp $_;
    my @tmpb=split /\t/,$_;
    my ($Aid,$Bid)=@tmpb;
    #print "$Aid,$Bid\n";
    my @pairs_A=get_MR_pair($A,$Aid,$M);
    shift @pairs_A;
    #print "$Aid\t@pairs_A\n";
    
    push @allA,@pairs_A;
    my @pairs_B=get_MR_pair($B,$Bid,$M);
    my @onlyB=();#ֻ������B�й����Ļ����
    my @bothB=();#�������о������Ļ����
    for (@pairs_B){
        my @i=get_homo_pair_B($_);
        my $j=shift @i;
        #print "$j\n";
        my @tmpc=split /-/,$j;
        if ($tmpc[1]) {
            push @bothB,$j;
        }
        else {
            push @onlyB,$_;
        }
    }
    push @allA,@bothB;
    
    my @uniqA=get_uniq(@allA);
    my %Apcc=get_pair_pcc_hash($A,$Aid);
    my %Bpcc=get_pair_pcc_hash($B,$Bid);
    
    my $fangchahe=0;
    my $coexpnum=-1;
    my $nonhomo=0;
    my $homonum=-1;
    if (@onlyB>0) {
        for (@onlyB){
            $fangchahe+=$Bpcc{$_}**2;
            $coexpnum+=1;
            $nonhomo+=1;
            print PRO "$Aid\-\t$_\n";
        }
    }
    $coexpnum+=@uniqA;
    for (@uniqA){
        my $pairA=$_;
        my $pairB=get_homo_pair_A($pairA);
        print PRO "$pairA\t$pairB\n";
        
        if ((defined $Apcc{$pairA})&&(defined $Bpcc{$pairB})) {
            $fangchahe+=($Apcc{$pairA}-$Bpcc{$pairB})**2;
            $homonum+=1;
        }
        else {
            $fangchahe+=$Apcc{$pairA}**2;
            $nonhomo+=1;
        }
    }
    my $dC;
    if ($coexpnum<=0) {
        $dC="NA";
    }
    else{
        $dC=sqrt($fangchahe/$coexpnum);
    }
    print OUT "$Aid\t$Bid\t$dC\t$coexpnum\t$homonum\t$nonhomo\n";
    #print "$Aid\t$Bid\t$dC\t$coexpnum\t$homonum\t$nonhomo\n";
    $count+=1;
    print "finished NO:$count ID:$Aid\n";
}

#!/usr/bin/perl -w
use strict;
my $M=shift @ARGV;
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

sub get_homo_pair_sce {
    my @homo_pair;
    my %h=();
    open(H, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/hsa_sce.out") or die "$!";
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

sub get_homo_pair_hsa {
    my %h=();
    open(H, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/hsa_sce.out") or die "$!";
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

open(OUT, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/result$M.out") or die "$!";
open(PRO, ">/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/presult$M.out") or die "$!";
open(HOMO, "/share/home/ChenMiaolin/CoexpData/ANIMAL/RAW/hsa_sce.out") or die "$!";
my @ho=<HOMO>;
my %homo=();
for (@ho){
    chomp $_;
    my @tmpa=split /\t/,$_;
    $homo{$tmpa[0]}=$tmpa[1];
}

my $count=0;
for (@ho) {
    my @allhsa=();
    chomp $_;
    my @tmpb=split /\t/,$_;
    my ($hsaid,$sceid)=@tmpb;
    my @pairs_hsa=get_MR_pair("HSA",$hsaid,$M);
    push @allhsa,@pairs_hsa;
    my @pairs_sce=get_MR_pair("SCE",$sceid,$M);
    my @homo_sce=get_homo_pair_sce(@pairs_sce);
    push @allhsa,@homo_sce;
    
    my @uniqhsa=get_uniq(@allhsa);
    my %hsapcc=get_pair_pcc_hash("HSA",$hsaid);
    my %scepcc=get_pair_pcc_hash("SCE",$sceid);
    
    my $fangchahe=0;
    my $homonum=0;
    my $nonhomo=0;
    my $coexpnum=@uniqhsa;
    for (@uniqhsa){
        chomp $_;
        my $pairhsa=$_;
        my $pairsce=get_homo_pair_hsa($pairhsa);
        print PRO "$pairhsa\t$pairsce\n";
        
        if ((defined $hsapcc{$pairhsa})&&(defined $scepcc{$pairsce})) {
            $fangchahe+=($hsapcc{$pairhsa}-$scepcc{$pairsce})**2;
            $homonum+=1;
        }
        else {
            $fangchahe+=$hsapcc{$pairhsa}**2;
            $nonhomo+=1;
        }
    }
    my $dC=sqrt($fangchahe/$coexpnum);
    print OUT "$hsaid\t$sceid\t$dC\t$coexpnum\t$homonum\t$nonhomo\n";
    $count+=1;
    print "finished NO:$count ID:$hsaid\n";
}

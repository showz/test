#!/usr/bin/perl -w

use Data::Dumper;

use strict;

sub nextMove {
	my($player,$board) = @_;

	my $your_player;
	if($player eq 'X'){
		$your_player = 'O';
	}else{
		$your_player = 'X';
	}

	my $answer;
	my $my_bingo_list;
	my $your_bingo_list;
	my $space_list;
	my $count = getCount($board);
	$my_bingo_list = getBingoList($player, $board);
	$your_bingo_list = getBingoList($your_player, $board);
	$space_list = getSpaceList($board);
	
	if($player eq 'X'){
		if($count == 0){
			$answer = '2 0';
		}elsif($count == 2){
			if(defined($space_list->{"0 2"}) || defined($space_list->{"1 1"})){
				$answer = '1 0';
			}elsif(defined($space_list->{"0 0"}) || defined($space_list->{"2 2"})){
				$answer = '0 2';
			}else{
				if(!defined($space_list->{"1 0"})){
					$answer = "1 0";
				}else{
					$answer = "2 1";
				}
			}
		}elsif($count >= 4){
			$answer = checkBingo($my_bingo_list, $space_list);
			if(!$answer){
				$answer = checkBingo($your_bingo_list, $space_list);
			}
			if(!$answer){
				foreach my $key ( keys %{$space_list} ){
					$answer = $key;
					last;
				}
			}
		}
	}else{
		if($count == 1){
			if(defined($space_list->{"1 1"})){
				$answer = '1 1';
			}else{
				$answer = '2 0';
			}
		}elsif($count >= 3){
			$answer = checkBingo($my_bingo_list, $space_list);
			if(!$answer){
				$answer = checkBingo($your_bingo_list, $space_list);
			}
			if(!$answer){
				if(!defined($space_list->{"0 2"}) && !defined($space_list->{"2 0"}) && defined($space_list->{"0 1"})){
					$answer = '0 1';
				}elsif(!defined($space_list->{"0 0"}) && !defined($space_list->{"2 2"}) && defined($space_list->{"1 0"})){
					$answer = '1 0';
				}
			}
			if(!$answer){
				foreach my $key ( keys %{$space_list} ){
					$answer = $key;
					last;
				}
			}
		}
	}

	print $answer;
}

sub getCount {
	my $board = $_[0];

	my $count = 0;
	foreach my $b (@{$board}){
		foreach my $b2 (split('', $b)){
			if($b2 eq 'X' || $b2 eq 'O'){
				$count++;
			}
		}
	}
	return $count;
}

sub checkBingo {
	my $bingo_list = $_[0];
	my $space_list = $_[1];

	foreach my $key (keys %{$bingo_list}){
		my $count = keys %{$bingo_list->{$key}};
		if($count == 1){
			foreach my $k (keys %{$bingo_list->{$key}}){
				if(defined($space_list->{$k})){
					return $k;
				}
			}
		}
	}
}

sub getBingoList {
	my ( $player, $board ) = @_;

	my %bingo_list = makeBingoList();
	my $i = 0;
	foreach my $b (@{$board}){
		chomp($b);
		my $j = 0;
		foreach my $b2 (split('', $b)){
			if($b2 eq $player){
				if($i == 0){
					delete $bingo_list{'0'}{"0 $j"};
				}
				if($i == 1){
					delete $bingo_list{'1'}{"1 $j"};
				}
				if($i == 2){
					delete $bingo_list{'2'}{"2 $j"};
				}
				if($j == 0){
					delete $bingo_list{'3'}{"$i 0"};
				}
				if($j == 1){
					delete $bingo_list{'4'}{"$i 1"};
				}
				if($j == 2){
					delete $bingo_list{'5'}{"$i 2"};
				}
				if($i == $j){
					delete $bingo_list{'6'}{"$i $j"};
				}
				if(($i == 0 && $j == 2) || ($i == 1 && $j == 1) || ($i == 2 && $j == 0)){
					delete $bingo_list{'7'}{"$i $j"};
				}
			}
			$j++;
		}
		$i++;
	}
	return \%bingo_list;
}

sub makeBingoList {
	my %bingo_list;

	$bingo_list{'0'}{'0 0'} = 1;
	$bingo_list{'0'}{'0 1'} = 1;
	$bingo_list{'0'}{'0 2'} = 1;
	$bingo_list{'1'}{'1 0'} = 1;
	$bingo_list{'1'}{'1 1'} = 1;
	$bingo_list{'1'}{'1 2'} = 1;
	$bingo_list{'2'}{'2 0'} = 1;
	$bingo_list{'2'}{'2 1'} = 1;
	$bingo_list{'2'}{'2 2'} = 1;
	$bingo_list{'3'}{'0 0'} = 1;
	$bingo_list{'3'}{'1 0'} = 1;
	$bingo_list{'3'}{'2 0'} = 1;
	$bingo_list{'4'}{'0 1'} = 1;
	$bingo_list{'4'}{'1 1'} = 1;
	$bingo_list{'4'}{'2 1'} = 1;
	$bingo_list{'5'}{'0 2'} = 1;
	$bingo_list{'5'}{'1 2'} = 1;
	$bingo_list{'5'}{'2 2'} = 1;
	$bingo_list{'6'}{'0 0'} = 1;
	$bingo_list{'6'}{'1 1'} = 1;
	$bingo_list{'6'}{'2 2'} = 1;
	$bingo_list{'7'}{'0 2'} = 1;
	$bingo_list{'7'}{'1 1'} = 1;
	$bingo_list{'7'}{'2 0'} = 1;

	return %bingo_list;
}

sub getSpaceList {
	my $board = $_[0];

	my %space_list = makeSpaceList();
	my $i = 0;
	foreach my $b (@{$board}){
		chomp($b);
		my $j = 0;
		foreach my $b2 (split('', $b)){
			if($b2 eq 'X' || $b2 eq 'O'){
				delete $space_list{"$i $j"};
			}
			$j++;
		}
		$i++;
	}
	return \%space_list;
}

sub makeSpaceList {
	my %space_list;

	$space_list{'0 0'} = 1;
	$space_list{'0 1'} = 1;
	$space_list{'0 2'} = 1;
	$space_list{'1 0'} = 1;
	$space_list{'1 1'} = 1;
	$space_list{'1 2'} = 1;
	$space_list{'2 0'} = 1;
	$space_list{'2 1'} = 1;
	$space_list{'2 2'} = 1;

	return %space_list;
}

my $pyer = <>;
chomp($pyer);
my @board;

for (my $i=0;$i<3;$i++) {
	$board[$i] = <>;
}

nextMove($pyer,\@board);

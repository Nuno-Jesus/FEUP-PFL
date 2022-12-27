:-use_module(library(lists)).

:-consult('board.pl').
:-consult('io.pl').

% initialize game
% init_game(+Size, -GameState)
init_game(Size, GameState) :-
	init_board(Size, Board),
	print_board(Board).
	
	
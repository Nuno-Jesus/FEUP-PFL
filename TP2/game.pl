:-use_module(library(lists)).

:-consult('board.pl').
:-consult('io.pl').

% initialize game
% init_game(+Size, -GameState)
init_game(gameState(NewBoard), Size) :-
	init_board(Size, Board),
	init_pieces(Board, NewBoard).
	
	
:-use_module(library(lists)).

:-consult('board.pl').

% initialize game
% init_game(-GameState)
init_game(gameState(NewBoard, player(0, 8, 'R'), player(1, 8, 'B'))) :-
	init_board(NewBoard).

	
	
:-use_module(library(lists)).

:-consult('board.pl').

% initialize game
% init_game(-GameState)
init_game(gameState(NewBoard, player(0, 8, 'R'), player(1, 8, 'B'))) :-
	init_board(NewBoard).
	
get_piles([], []).
get_piles([H|T], Piles) :-
	findall(X-Y, (length([H|T], X), nth1(Y, H, [_|_])) ,Piles1),
	get_piles(T, Piles2),
	append(Piles1, Piles2, Piles).	

cycle(gameState(Board, _, _)) :-
	display_board(Board),
	get_piles(Board, Piles),
	write(Piles).


	
	
:-consult('game.pl').
:-consult('board.pl').
:-consult('io.pl').

% start the game
play :- 
	init_game(GameState),
	print_menu.	
	%cycle(GameState).
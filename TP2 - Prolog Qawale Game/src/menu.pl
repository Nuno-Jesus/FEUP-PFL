:- consult('io.pl').
:- consult('game.pl').

% menu cycle. Prints title, options and prompts user for input.
% menu/0
menu:-
	print_title,
	repeat,
	print_options,
	read_option(Option),
	write('The game will start\n'),
	start_game(Option),
	!.

% initializes game mode corresponding to option
% start_game(+Option)
start_game('1'):- 
	init_game('h', 'h', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('2'):- 
	init_game('cr', 'h', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('3'):- 
	init_game('h', 'cr', GameState),
	display_game(GameState),
	game_loop(GameState).

start_game('4'):- 
	init_game('cg', 'h', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('5'):- 
	init_game('h', 'cg', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('6'):- 
	init_game('cr', 'cg', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('7'):- 
	init_game('cg', 'cr', GameState),
	display_game(GameState),
	game_loop(GameState).

start_game('8'):- 
	init_game('cr', 'cr', GameState),
	display_game(GameState),
	game_loop(GameState).
	
start_game('9'):- 
	init_game('cg', 'cg', GameState),
	display_game(GameState),
	game_loop(GameState).
	

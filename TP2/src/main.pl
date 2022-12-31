:-consult('game.pl').
:-consult('board.pl').
:-consult('io.pl').

% start the game
play :- 
	init_game(GameState),
	display_game(GameState),
	game_loop(GameState).
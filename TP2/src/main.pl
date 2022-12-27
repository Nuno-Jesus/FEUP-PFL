:-consult('game.pl').
:-consult('board.pl').
:-consult('io.pl').

% start the game
play :- 
	init_game(gameState(Board, Player1, Player2)),
	print_board(Board).

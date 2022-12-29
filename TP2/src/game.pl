:-use_module(library(lists)).

:-consult('board.pl').
:-consult('tools.pl').

% initialize game
% init_game(-GameState)
init_game(gameState(NewBoard, player(0, 'R', 8), player(1, 'B', 8), 1)) :-
	init_board(NewBoard).
	
% get_piles(+Board, -Piles)
get_piles([], []).
get_piles([H|T], Piles) :-
	findall(X-Y, (length(T, X), nth0(Y, H, [_|_])) ,Piles1),
	get_piles(T, Piles2),
	append(Piles1, Piles2, Piles).
	
% get_paths(+Board, +Position, -Path)
get_path(Board, X-Y, Path):-
	at(Board, X, Y, Elem),
	length(Elem, PileSize),
	PileSize1 is PileSize+1,
	length(Board, Limit),
	dfs(X-Y, PileSize1, Limit, Path).
	
dfs(Position, PileSize, Limit, Path) :-
	dfs1(Position, PileSize, Limit, [Position], ThePath),
	reverse(ThePath,Path).

dfs1(_, 0, _, Path, Path).
dfs1(S, PileSize, Limit, SoFar, Path) :-
	PileSize > 0,
	PileSize1 is PileSize-1,
	arc(S,S2, Limit),
	\+(member(S2,SoFar)),
	dfs1(S2, PileSize1, Limit, [S2|SoFar], Path).
	
arc(X-Y, X1-Y1, Limit):-
	(X1 is X+0, Y1 is Y+1, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X+0, Y1 is Y-1, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X+1, Y1 is Y+0, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X-1, Y1 is Y+0, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 ).

% next_turn(+Last, -Next)
% next_turn(1, 0).
% next_turn(0, 1).

% valid_moves(+Board, -List)
valid_moves(Board, List):-
	get_piles(Board, Piles),
	valid_moves_aux(Board, Piles, List).

% valid_moves_aux(+Board, +Piles, -List)
valid_moves_aux(_, [], []).
valid_moves_aux(Board, [H|T], List):-
	findall(Path, (get_path(Board, H, Path)), List1),
	valid_moves_aux(Board, T, List2),
	append(List1, List2, List).

% evaluate_move(Board, +Move)
% evaluate_move(Move):-	
%	valid_moves(Board, List),
%	member(Move, List).
	
% move(+GameState, +Move, -NewGameState)
%move(GameState, Move, NewGameState):-
	
% push_piece(+Cell, +Piece, -NewCell)
%push_piece(Cell, Piece, NewCell):-

% walk(+Board, +Path, +Stack, -NewBoard)
%walk(+Board, +Path, +Stack, -NewBoard)

%cycle(gameState(Board, Player1, Player2, Turn)):-
	% check winning condition

cycle(gameState(Board, Player1, Player2, Turn)) :-
	display_game(gameState(Board, Player1, Player2, Turn)),
	valid_moves(Board, List),
	get_piles(Board, Piles),
	write(Piles),
	nl,
	write(List).
%	read_move(Move),
%	evaluate_move(Board, Move),
%	move(gameState(Board, Player1, Player2, Turn), Move, NewGameState),
%	cycle(NewGameState).


	
	
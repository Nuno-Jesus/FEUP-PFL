:-use_module(library(lists)).
:-use_module(library(random)).

:-consult('board.pl').
:-consult('tools.pl').

% initialize game
% init_game(+Type1, +Type2, -GameState)
init_game(Type1, Type2, gameState(NewBoard, player(0, Type1, 'R', 8), player(1, Type2, 'B', 8), 0)) :-
	init_board(NewBoard).
	
% get_piles(+Board, -Piles)
get_piles(Board, Piles) :-
	findall(X-Y, (at(Board, X, Y, [_|_])) ,Piles).
	
% get_paths(+Board, +Position, -Path)
get_path(Board, X-Y, Path):-
	at(Board, X, Y, Elem),
	length(Elem, PileSize),
	PileSize1 is PileSize+1,
	length(Board, Limit),
	dfs(X-Y, PileSize1, Limit, Path).

% next_turn(+Last, -Next)
next_turn(1, 0).
next_turn(0, 1).

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

% evaluate_move(+Board, +Move)
evaluate_move(Board, Move):-	
	valid_moves(Board, List),
	member(Move, List).
	
% move(+GameState, +Move, -NewGameState)
move(gameState(Board, player(Turn, Type, Piece, NP), Player2, Turn), Move, gameState(NewBoard, player(Turn, Type, Piece, NP1), Player2, NextTurn)):-
	move_aux(Board, Piece, Move, NewBoard),
	NP1 is NP-1,
	next_turn(Turn, NextTurn).
	

% move(+GameState, +Move, -NewGameState)
move(gameState(Board, Player1, player(Turn, Type, Piece, NP), Turn), Move, gameState(NewBoard, Player1, player(Turn, Type, Piece, NP1), NextTurn)):-
	move_aux(Board, Piece, Move, NewBoard),
	NP1 is NP-1,
	next_turn(Turn, NextTurn).

% move_aux(+Board, +Piece, +Move, -NewBoard)
move_aux(Board, Piece, [X-Y|T], NewBoard):-
	push_piece(Board, X-Y, Piece, Stack, NewBoardAux),
	walk(NewBoardAux, T, Stack, NewBoard).

% push_piece(+Board, +Position, +Piece, -Stack, -NewBoard)
push_piece(Board, X-Y, Piece, [Piece|Stack], NewBoard):-
	at(Board, X, Y, Stack),
	replace_matrix(Board, X, Y, [], NewBoard).
	
% walk(+Board, +Path, +Stack, -NewBoard)
walk(Board, [], [], Board).
walk(Board, [X-Y|T], Stack, NewBoard):-
	last_element(Stack, Piece),
	pop_last_element(Stack, NewStack),
	at(Board, X, Y, Pile),
	replace_matrix(Board, X, Y, [Piece|Pile], NewBoardAux),
	walk(NewBoardAux, T, NewStack, NewBoard).
	
% choose_move(+Board, +Player, -Move)
choose_move(Board, player(_, 'h', _, _), Move):-
	repeat,
	read_move(Move),
	evaluate_move(Board, Move),
	!.
	
choose_move(Board, player(_, 'cr', _, _), Move):-
	valid_moves(Board, List),
	random_member(Move, List).
	
choose_move(Board, player(_, 'cg', Piece, _), BestMove):-
	valid_moves(Board, Moves),
	setof(Score-Move, (member(Move, Moves), move_score(Board, Move, Piece, Score)), Set),
	best_move(Set, BestMove).

% best_move(+Set, -BestMove)
best_move(Set, BestMove):-
	last(Set, Score-_),
	findall(MoveAux, (member(ScoreAux-MoveAux, Set), is_same(ScoreAux, Score)), Result),
	random_member(BestMove, Result).
	
% move_score(+Board, +Move, +Piece, -Score)
move_score(Board, Move, Piece, Score):-
	move_aux(Board, Piece, Move, NewBoard),
	board_score(NewBoard, Piece, Score).
	
% board_score(+NewBoard, +Piece, -Score)
board_score(NewBoard, Piece, 0):-
	opposite_piece(Piece, EnemyPiece),
	verify_end(NewBoard, EnemyPiece).
	
board_score(NewBoard, Piece, 100000):-
	verify_end(NewBoard, Piece).

board_score(NewBoard, Piece, Score):-
	count_top_pieces(NewBoard, Piece, Score).
	
	
% verify_end(+Board, +Piece)
verify_end(Board, Piece):- verify_columns(Board, Piece).
verify_end(Board, Piece):- verify_rows(Board, Piece).

game_loop(gameState(Board, player(_, _, P1, _), player(_, _, P2, _), _)):-
	verify_end(Board, P1),
	verify_end(Board, P2),
	write('Draw\n').

game_loop(gameState(Board, player(ID1, _, P1, _), _, _)):-
	verify_end(Board, P1),
	format('Player ~w wins!!~n', [ID1]).

game_loop(gameState(Board, _, player(ID2, _, P2, _), _)):-
	verify_end(Board, P2),
	format('Player ~w wins!!~n', [ID2]).

game_loop(gameState(_, player(_, _, _, 0), player(_, _, _, 0), _)):-
	write('Draw\n').
	
game_loop(gameState(Board, player(Turn, Type, Piece, NP), Player2, Turn)) :-
	choose_move(Board, player(Turn, Type, Piece, NP), Move),
	move(gameState(Board, player(Turn, Type, Piece, NP), Player2, Turn), Move, NewGameState),
	display_game(NewGameState),
	game_loop(NewGameState).
	
game_loop(gameState(Board, Player1, player(Turn, Type, Piece, NP), Turn)) :-
	choose_move(Board, player(Turn, Type, Piece, NP), Move),
	move(gameState(Board, Player1, player(Turn, Type, Piece, NP), Turn), Move, NewGameState),
	display_game(NewGameState),
	game_loop(NewGameState).


	
	
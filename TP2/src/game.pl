:-use_module(library(lists)).

:-consult('board.pl').
:-consult('tools.pl').

% initialize game
% init_game(-GameState)
init_game(gameState(NewBoard, player(0, 'R', 8), player(1, 'B', 8), 0)) :-
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

% evaluate_move(+GameState, +Move)
evaluate_move(gameState(Board, _, _, _), Move):-	
	valid_moves(Board, List),
	member(Move, List).
	
% move(+GameState, +Move, -NewGameState)
move(gameState(Board, player(Turn, Piece, NP), Player2, Turn), Move, gameState(NewBoard, player(Turn, Piece, NP1), Player2, NextTurn)):-
	move_aux(Board, Piece, Move, NewBoard),
	NP1 is NP-1,
	next_turn(Turn, NextTurn),
	write('Next player 2\n').
	

% move(+GameState, +Move, -NewGameState)
move(gameState(Board, Player1, player(Turn, Piece, NP), Turn), Move, gameState(NewBoard, Player1, player(Turn, Piece, NP1), NextTurn)):-
	move_aux(Board, Piece, Move, NewBoard),
	NP1 is NP-1,
	next_turn(Turn, NextTurn),
	write('Next player 1\n').

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
	
% choose_move(+GameState, -Move)
choose_move(GameState, Move):-
	repeat,
	read_move(Move),
	evaluate_move(GameState, Move),
	!.

% verify_end(+Board, +Piece)
verify_end(Board, Piece):- verify_columns(Board, Piece).
verify_end(Board, Piece):- verify_rows(Board, Piece).

% verify_columns(+Board, +Piece)
verify_columns(Board, Piece):- 
	transp(Board, BoardAux),
	verify_rows(BoardAux, Piece).

% verify_rows(+Board, +Piece)
verify_rows(Board, Piece):-
	member(Line, Board),
	verify_line(Line, Piece).
	
% verify_line(+Line, +Piece)
verify_line(Line, Piece):- 
	no_empty_cells(Line),
	verify_line_aux(Line, Piece).
	
% verify_line_aux(+Line, +Piece)
verify_line_aux([], _).
verify_line_aux([[Top|_]|T], Piece):-
	is_same(Piece, Top),
	verify_line_aux(T, Piece).
	
% no_empty_cells(+Line)
no_empty_cells([]).
no_empty_cells([H|T]):-
	\+is_empty(H),
	no_empty_cells(T).

game_loop(gameState(Board, player(_, P1, _), player(_, P2, _), _)):-
	verify_end(Board, P1),
	verify_end(Board, P2),
	write('Draw\n').

game_loop(gameState(Board, player(ID1, P1, _), _, _)):-
	verify_end(Board, P1),
	write(ID1), nl.

game_loop(gameState(Board, _, player(ID2, P2, _), _)):-
	verify_end(Board, P2),
	write(ID2), nl.

game_loop(gameState(_, player(_, _, 0), player(_, _, 0), _)):-
	write('Draw\n').
	
game_loop(GameState) :-
	choose_move(GameState, Move),
	move(GameState, Move, NewGameState),
	display_game(NewGameState),
	game_loop(NewGameState).


	
	
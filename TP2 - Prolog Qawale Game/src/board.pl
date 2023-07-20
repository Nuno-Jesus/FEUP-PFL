:- use_module(library(lists)).
:- consult('tools.pl').

% opposite_piece(+Piece, -EnemyPiece)
opposite_piece('B', 'R').
opposite_piece('R', 'B').

% calculate size of largest cell in the board
% max_cell_size(+Board, -MaxCellSize)
max_cell_size(Board, MaxCellSize):-
	findall(MaxCellSizeRow, (member(Row, Board), max_cell_size_row(Row, MaxCellSizeRow)), Result),
	max_member(MaxCellSize, Result).

% calculate size of largest cell in row
% max_cell_size_row(+Row, -MaxCellSize)
max_cell_size_row(Row, MaxCellSize):-
	findall(Size, (member(Cell, Row), length(Cell, Size)), Result),
	max_member(MaxCellSize, Result).

% init Board row
% init_row(+Row, -NewRow)
init_row(Row, NewRow) :-
	replace_list(Row, 0, ['G', 'G'], Row1),
    replace_list(Row1, 3, ['G', 'G'], NewRow).

% initialize board pieces
% init_pieces(+Board, -NewBoard)
init_pieces([H|T], NewBoard) :-
    append(X, [Last], T),
	init_row(H, H1),
	init_row(Last, L1),
    append([H1|X], [L1], NewBoard).

% initialize board
% init_board(-NewBoard)
init_board(NewBoard) :-
	length(Row, 4),
    maplist(=([]), Row),
    length(Board, 4),
    maplist(=(Row), Board),
    init_pieces(Board, NewBoard).

% count top pieces of type Piece in board
% count_top_pieces(+Board, +Piece, -Result)
count_top_pieces(Board, Piece, Result):-
	findall(Count, (member(Row, Board), count_top_pieces_aux(Row, Piece, Count)), RowCount),
	sumlist(RowCount, Result).

% count_top_pieces_aux(+Row, +Piece, -Count)
count_top_pieces_aux(Row, Piece, Count):-
	findall(1, (member([H|_], Row), is_same(Piece, H)), Result),
	sumlist(Result, Count).

% verify columns for endGame state
% verify_columns(+Board, +Piece)
verify_columns(Board, Piece):- 
	transp(Board, BoardAux),
	verify_rows(BoardAux, Piece).

% verify rows for endgame state 
% verify_rows(+Board, +Piece)
verify_rows(Board, Piece):-
	member(Line, Board),
	verify_line(Line, Piece).
	
% verifu Row for endgame state
% verify_line(+Line, +Piece)
verify_line(Line, Piece):- 
	no_empty_cells(Line),
	verify_line_aux(Line, Piece).

% verify_line_aux(+Line, +Piece)
verify_line_aux([], _).
verify_line_aux([[Top|_]|T], Piece):-
	is_same(Piece, Top),
	verify_line_aux(T, Piece).

% check if row has empty cells
% no_empty_cells(+Line)
no_empty_cells([]).
no_empty_cells([H|T]):-
	\+is_empty(H),
	no_empty_cells(T).
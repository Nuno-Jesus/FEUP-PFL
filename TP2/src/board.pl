:- use_module(library(lists)).
:- consult('tools.pl').

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
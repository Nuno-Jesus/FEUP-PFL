:- use_module(library(lists)).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
    I > 0, 
    I1 is I-1, 
    replace(T, I1, X, R).

init_row(Row, NewRow) :-
	replace(Row, 0, ['G', 'G'], Row1),
    replace(Row1, 3, ['G', 'G'], NewRow).
    
% initialize board pieces
% init_pieces(?Board)

init_pieces([H|T], NewBoard) :-
    append(X, [Last], T),
	init_row(H, H1),
	init_row(Last, L1),
    append([H1|X], [L1], NewBoard).
	

% initialize board
% init_board(+Size,-Board)
init_board(Size, Board) :-
	length(Row, Size),
    maplist(=([]), Row),
    length(Board, Size),
    maplist(=(Row), Board).
:-use_module(library(lists)).

% initialize row
% init_row()

% initialize board
% init_board(+Size,-Board)
init_board(Size, Board):-
	length(Row, Size),
    maplist(=([]), Row),
    length(Board, Size),
    maplist(=(Row), Board).
	
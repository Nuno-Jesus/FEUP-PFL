:-use_module(library(lists)).

% print board
% print_board(+Board)
print_board([]).
print_board([X|XS]):-
	print_row(X),
	print_board(XS).

% print row
% print_row(+Row)
print_row(Row):-
    write(Row),
    nl.
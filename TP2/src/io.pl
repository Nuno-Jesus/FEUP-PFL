:-use_module(library(lists)).

% print board
% display_board(+Board)
display_board([]).
display_board([X|XS]):-
	print_row(X),
	display_board(XS).

% print row
% print_row(+Row)
print_row(Row):-
    write(Row),
    nl.

display_game(gameState(Board, _, _, _)):-
	display_board(Board).
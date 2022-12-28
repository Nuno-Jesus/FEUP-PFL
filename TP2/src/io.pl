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

% Prints the menu title
% print_title/0
print_title :-
  	write('\t    (____          (_       (__        (__      (_       (__      (________\n'),
	write('\t  (__    (__      (_ __     (__        (__     (_ __     (__      (__      \n'),
	write('\t(__       (__    (_  (__    (__   (_   (__    (_  (__    (__      (__      \n'),
	write('\t(__       (__   (__   (__   (__  (__   (__   (__   (__   (__      (______  \n'),
	write('\t(__       (__  (______ (__  (__ (_ (__ (__  (______ (__  (__      (__      \n'),
	write('\t  (__ (_ (__  (__       (__ (_ (_    (____ (__       (__ (__      (__      \n'),
	write('\t    (__ __   (__         (__(__        (__(__         (__(________(________\n'),
	write('\t       (_                                                                  \n').

% Prints the initial menu
% print_menu/0

option('1', 'Human vs Human').
option('2', 'Computer vs Human').
option('3', 'Human vs Computer').
option('4', 'Computer vs Computer').

print_menu_aux([]).
print_menu_aux([X|XS]) :-
	write(X),
	nl,
	print_menu_aux(XS).

print_menu :-
	print_title,
	findall([A]-B, option(A, B), Options),
	print_menu_aux(Options).

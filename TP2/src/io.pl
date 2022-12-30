:-use_module(library(lists)).
:-consult('tools.pl').

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

% Receives and prints a list of the menu options
% print_options(+Options)
print_options([]).
print_options([X|XS]) :-
	write(X),
	nl,
	print_options(XS).

% Prints the title and the options
print_menu :-
	print_title,
	findall([A]-B, option(A, B), Options),
	print_options(Options).

% read_option(-Option)
read_option(Option) :-
	get_char(Option),
	findall(A, option(A, _), Options),
	member(Option, Options).
	
% read_move(-Move)
read_move(Move):-
	repeat,
	read_keyboard(Input),
	validate_input(Input, Move),
	!.

% read_keyboard(-Input)
read_keyboard(Input):-
	write('Please write a valid command: X0-Y0 X1-Y1 X2-Y2 ...'),
	nl,
	get_code(Code),
	read_keyboard_aux(Code, Input),
	!.

% read_keyboard_aux(+Ch, -Input)
read_keyboard_aux(13, []).
read_keyboard_aux(10, []).
read_keyboard_aux(Code, [Ch|Rest]):-
	get_code(Code1),
	char_code(Ch, Code),
	read_keyboard_aux(Code1, Rest).
	
% validate_input(+Input, -Moves)
validate_input(Input, Moves):-
	delete(Input, ' ', Input1),
	length(Input1, Len),
	!,
	Len > 2, !, divides(Len, 3),
	validate_input_aux(Input1, Moves).

% validate_input_aux(+Input, -Position, -Success)
validate_input_aux([], []).
validate_input_aux([X|[M|[Y|T]]], Moves):-
	verify_number(X, NX), !, verify_number(Y, NY),
	!,
	verify_parser(M),
	!,
	validate_input_aux(T, Rest),
	append([NX-NY], Rest, Moves).

	
	
	
	
	

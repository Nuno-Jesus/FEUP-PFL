:-use_module(library(lists)).
:-consult('tools.pl').

% display_cell(+Cell, +CellSize)
display_cell(Cell, CellSize):-
	length(Cell, Size),
	BlankSpace is CellSize-Size,
	length(CellRest, BlankSpace),
	maplist(=('.'), CellRest),
	reverse(Cell, CellAux),
	append(CellAux, CellRest, CellResult),
	write('['),
	display_cell_aux(CellResult).
	
% display_cell_aux(+Cell, +BlankSpace)
display_cell_aux([]):- write(']').
display_cell_aux([H|T]):-
	write(H),
	display_cell_aux(T).
	

% print board
% display_board(+Type, +Board)
display_board('h', Board):-
	max_cell_size(Board, CellSize),
	display_board_aux(Board, CellSize).

display_board('cr', Board):-
	max_cell_size(Board, CellSize),
	display_board_aux(Board, CellSize),
	write('Press any key to continue\n'),
	get_char(_).
	
display_board('cg', Board):-
	max_cell_size(Board, CellSize),
	display_board_aux(Board, CellSize),
	write('Press any key to continue\n'),
	get_char(_).
	
% display_board_aux(+Board, +CellSize)
display_board_aux([], _).
display_board_aux([H|T], CellSize):-
	print_row(H, CellSize),
	display_board_aux(T, CellSize).

% print row
% print_row(+Row, CellSize)
print_row([],_) :- nl. 
print_row([H|T], CellSize):-
    display_cell(H, CellSize),
	print_row(T, CellSize).

display_game(gameState(Board, player(Turn, Type , _, _), _, Turn)):-
	length(Board, Size),
	display_move_direction(Size),
	display_board(Type, Board).
	
display_game(gameState(Board, _, player(Turn, Type, _, _), Turn)):-
	length(Board, Size),
	display_move_direction(Size),
	display_board(Type, Board).
	
% display_move_direction(+Size)
display_move_direction(Size):-
	format('Board Size : ~w~n', [Size]),
	MaxIndex is Size-1,
	format('X: left->right (0->~w) | ', [MaxIndex]),
	format('Y: up->down (0->~w)~n', [MaxIndex]).
	

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

option('1', 'Human vs Human').
option('2', 'Computer Random vs Human').
option('3', 'Human vs Computer Random').
option('4', 'Computer Greedy vs Human').
option('5', 'Human vs Computer Greedy').
option('6', 'Computer Random vs Computer Greedy').
option('7', 'Computer Greedy vs Computer Random').
option('8', 'Computer Random vs Computer Random').
option('9', 'Computer Greedy vs Computer Greedy').

% Prints the options
print_options :-
	findall([A]-B, option(A, B), Options),
	print_options_aux(Options).

% Receives and prints a list of the menu options
% print_options(+Options)
print_options_aux([]).
print_options_aux([X|XS]) :-
	write(X),
	nl,
	print_options_aux(XS).

% read_option(-Option)
read_option(H) :-
	write('Please write a valid option\n'),
	read_keyboard([H|_]),
	findall(A, option(A, _), Options),
	member(H, Options),
	!.
	
% read_move(-Move)
read_move(Move):-
	repeat,
	read_keyboard(Input),
	validate_input(Input, Move),
	!.

% read_keyboard(-Input)
read_keyboard(Input):-
	% write('Please write a valid command: X0-Y0 X1-Y1 X2-Y2 ...'),
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

	
	
	
	
	

% replaces Element of old list at index
% replace_list(+Old, +Index, +Ele, -New)
replace_list([_|T], 0, X, [X|T]).
replace_list([H|T], I, X, [H|R]):- 
    I > 0, 
    I1 is I-1, 
    replace_list(T, I1, X, R).

% last_element(+List, -Last)	
last_element(List, Last):- append(_, [Last], List).

% pop_last_element(+List, -Res)
pop_last_element(List, Res):- append(Res, [_], List). 

% replace_matrix_aux(+Old, +IndX, +IndY, +Ele, -New)	
replace_matrix([List|T], IndX, 0, Ele, [NewList|T]):-
	replace_list(List, IndX, Ele, NewList).
replace_matrix([List|T], IndX, IndY, Ele, [List|R]):-
	IndY > 0,
	IndY1 is IndY-1,
	replace_matrix(T, IndX, IndY1, Ele, R).
	
% at(+Matrix, +IndX, +IndY, -Val)
at(Matrix, IndX, IndY, Val) :-
	nth0(IndY, Matrix, Y1), 
	nth0(IndX, Y1, Val).
	
dfs(Position, Distance, Limit, Path) :-
	dfs1(Position, Distance, Limit, [Position], ThePath),
	reverse(ThePath,Path).

dfs1(_, 0, _, Path, Path).
dfs1(S, Distance, Limit, SoFar, Path) :-
	Distance > 0,
	Distance1 is Distance-1,
	arc(S,S2, Limit),
	\+(member(S2,SoFar)),
	dfs1(S2, Distance1, Limit, [S2|SoFar], Path).
	
arc(X-Y, X1-Y1, Limit):-
	(X1 is X+0, Y1 is Y+1, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X+0, Y1 is Y-1, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X+1, Y1 is Y+0, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 );
	(X1 is X-1, Y1 is Y+0, X1 < Limit, X1 >= 0, Y1 < Limit, Y1 >= 0 ).
	
% verify_number(+Ch, -N)
verify_number(Ch, N):- 
	char_code(Ch, Code),
	Code > 47, Code < 58,
	N is Code-48.

% verify_parser(+Ch)
verify_parser('-').

% divides(+N)
divides(N,D) :-
    0 is N mod D.

% converter(+Len, +FakeInd, -RealInd)
converter(Len, FakeInd, RealInd):-
	Ind is Len-1, 
	RealInd is (FakeInd - Ind)*(-1).

% is_empty(+List)
is_empty([]).

% is_same(+X, +Y)
is_same(X,X).

% transp(+List, -Result)
transp([[]|_], []).
transp(Matrix, [Row|Rows]) :- 
	transpose_first_col(Matrix, Row, RestMatrix),
	transp(RestMatrix, Rows).

% transpose_first_col(+Matrix, -Row, -RestMatrix)
transpose_first_col([], [], []).
transpose_first_col([[H|T]|Rows], [H|Hs], [T|Ts]) :- transpose_first_col(Rows, Hs, Ts).
	
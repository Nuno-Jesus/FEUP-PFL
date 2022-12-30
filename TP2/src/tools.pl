% replaces Element of old list at index
% replace_list(+Old, +Index, +Ele, -New)
replace_list([_|T], 0, X, [X|T]).
replace_list([H|T], I, X, [H|R]):- 
    I > 0, 
    I1 is I-1, 
    replace_list(T, I1, X, R).

% replace_matrix(+Old, +IndX, +IndY, +Ele, -New)	
replace_matrix([List|T], IndX, 0, Ele, [NewList|T]):-
	replace_list(List, IndX, Ele, NewList).
replace_matrix([List|T], IndX, IndY, Ele, [List|R]):-
	IndY > 0,
	IndY1 is IndY-1,
	replace_matrix(T, IndX, IndY1, Ele, R).
	
% at(+Matrix, +IndX, +IndY, -Val)
at(Matrix, IndX, IndY, Val) :-
	nth0(IndX, Matrix, IndX1), 
	nth0(IndY, IndX1, Val).
	
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
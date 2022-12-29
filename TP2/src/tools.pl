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
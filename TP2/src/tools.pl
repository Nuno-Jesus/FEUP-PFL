% replaces Element of old list at index
% replace(+Old, +Index, +Ele, -New)
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
    I > 0, 
    I1 is I-1, 
    replace(T, I1, X, R).
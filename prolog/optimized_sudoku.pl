%:- initialization(main).


solve(T) :-
    maplist(domain_1_9, T),
    sudoku_rows(T),
    transpose(T,Tmp), sudoku_rows(Tmp),
    sudoku_blocks(T),
    maplist(fd_labeling, T),
    maplist(show,T).
     
domain_1_9(T) :- fd_domain(T,1,9).
sudoku_rows(T) :- maplist(fd_all_different, T).
     
sudoku_blocks(T) :-
    findall(mn(M,N), (between(1,3,M), between(1,3,N)), MN),
    maplist(block2D_different(T), MN).
     
block2D_different(T, mn(M,N)) :-
    block3(M,T,T3), 
    maplist(block3(N), T3, T9),
    concat(T9,Xs), 
    fd_all_different(Xs).
    % where
    block3(M,Xs,Ys) :-
    append(Pre,Zs,Xs), 
    length(Pre,L), 
    L is (M - 1) * 3,
    prefix(Ys,Zs), 
    length(Ys,3).
     
     
% utils/list
between(M,N,X) :- X = M ; M < N -> M1 is M + 1, between(M1,N,X).
     
maplist(_,[]).
maplist(F,[X|Xs]) :- call(F,X), maplist(F,Xs).
     
maplist(_,[],[]).
maplist(F,[X|Xs],[Y|Ys]) :- call(F,X,Y), maplist(F,Xs,Ys).
     
maplist(_,[],[],[]).
maplist(F,[X|Xs],[Y|Ys],[Z|Zs]) :- call(F,X,Y,Z), maplist(F,Xs,Ys,Zs).
     
concat([],[]).
concat([X|Xs],Ys) :- append(X,Zs,Ys), concat(Xs,Zs).
     
transpose([],[]).
transpose([[X|Xh]|XX],[[X|Yh]|YY]) :-
    maplist(bind_head, Yh, XX, XY),
    maplist(bind_head, Xh, YY, YX),
    transpose(XY,YX).
    % where
    bind_head([],[],[]).
    bind_head(X,[X|XY],XY).
     
     
% tests
test([ [_,_,3,_,_,_,_,_,_]
    , [4,_,_,_,8,_,_,3,6]
    , [_,_,8,_,_,_,1,_,_]
    , [_,4,_,_,6,_,_,7,3]
    , [_,_,_,9,_,_,_,_,_]
    , [_,_,_,_,_,2,_,_,5]
    , [_,_,4,_,7,_,_,6,8]
    , [6,_,_,_,_,_,_,_,_]
    , [7,_,_,6,_,_,5,_,_]
    ]).
     
main :- test(T), solve(T), halt.
show(X) :- write(X), nl.
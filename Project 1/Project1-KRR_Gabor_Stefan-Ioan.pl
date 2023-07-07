
negate(n(A),A).
negate(A,n(A)).


merge_lists_no_duplicates(LIST1, LIST2, RESULT):- 
    append(LIST1,LIST2,R), list_to_set(R, RESULT).


get_neg_val([[],_],R1,R1).
get_neg_val([[A|TAIL],L2],R1,L):-
    negate(A,N),
    member(N,L2),
    append(R1,[[A,N]],R1_NEW),
    get_neg_val([TAIL,L2],R1_NEW,L).
get_neg_val([[A|TAIL],L2],R1,L):-
    get_neg_val([TAIL,L2],R1,L).



substract_helper(KB,_,[],EXT_M,EXT_M).
substract_helper(KB,[A,B],[[NA,NB]|N_TAIL],EXT_MEMBERS,L):-
    subtract(A,[NA],A_SUBS),
    subtract(B,[NB],B_SUBS),
    merge_lists_no_duplicates(A_SUBS,B_SUBS,NEW_LIST),
    sort(NEW_LIST,N_L_S),
    \+member(N_L_S,KB),
    append(EXT_MEMBERS,[N_L_S], EXT_MEMBERS_UP),
    substract_helper(KB,[A,B],N_TAIL,EXT_MEMBERS_UP, L).

substract_helper(KB,[A,B],[N_HEAD|N_TAIL],EXT_MEMBERS,L):-
    substract_helper(KB,[A,B],N_TAIL,EXT_MEMBERS,L).


get_new_members(KB,[],NEW_M,NEW_M).

get_new_members(KB,[A|COMB],NEW_M, L):-
    get_neg_val(A,[],N_VAL),
    \+ N_VAL = [],
    substract_helper(KB,A,N_VAL,[],EXT_MEMBERS),
    append(NEW_M, EXT_MEMBERS, NEW_M_UP),
    get_new_members(KB,COMB,NEW_M_UP, L).

get_new_members(KB,[A|COMB],NEW_M, L):-
    get_new_members(KB,COMB,NEW_M, L).


combinate(_,[]):- true.
combinate([A|TAIL],[A|COMBINATE]):-
    combinate(TAIL,COMBINATE).
combinate([_|TAIL],[A|COMBINATE]):-
    combinate(TAIL,[A|COMBINATE]).


res(KB):-member([],KB), print("UNSAT").

res(KB):-
    findall([A,B],combinate(KB,[A,B]),COMB),
    get_new_members(KB,COMB,[],NEW_M),
    \+ NEW_M =[],
    append(KB,NEW_M, NEW_KB),
    print('new members'),
    print(NEW_M),
    print('new KB'),
    print(NEW_KB),
    res(NEW_KB).

res(KB):-print("SAT").
    

sort_KB([],S,S).

sort_KB([A|B],S,L):-
    sort(A,C),
    append(S,[C],S2),
    sort_KB(B,S2,L).


before_res(KB,KB_S):-
    sort_KB(KB,[],KB_S),
    res(KB_S).





work(X) :- \+ lottery(X).
work(X) :- house(X).
lottery(X) :- house(X).
house(X) :- enoughPayment(X).
enoughPayment(X) :- party(X).

lottery(andrei):-true.
party(X).







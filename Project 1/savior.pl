
negate(n(A),A).
negate(A,n(A)).

containsOp(X, List):- member(n(X), List).
containsOp(n(X), List) :- member(X, List).


merge_lists_no_duplicates(L1, L2, R):- 
    append(L1,L2,R1), list_to_set(R1, R).


get_neg_val([[],_],R1,R1).
get_neg_val([[H|T],L2],R1,R2):-
    negate(H,N),
    member(N,L2),
    append(R1,[[H,N]],R1_NEW),
    get_neg_val([T,L2],R1_NEW,R2).
get_neg_val([[H|T],L2],R1,R2):-
    get_neg_val([T,L2],R1,R2).



substract_helper(KB,_,[],EXT_M,EXT_M).
substract_helper(KB,[A,B],[N_HEAD|N_TAIL],EXT_MEMBERS,L):-
    subtract(A,N_HEAD,A_SUBS),
    subtract(B,N_HEAD,B_SUBS),
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
combinate([X|T],[X|Comb]):-
    combinate(T,Comb).
combinate([_|T],[X|Comb]):-
    combinate(T,[X|Comb]).


res(KB):-member([],KB), print("UNSAT").

res(KB):-
    %sort_KB(KB,KB_S),
    findall([A,B],combinate(KB,[A,B]),COMB),
    get_new_members(KB,COMB,[],NEW_M),
    \+ NEW_M =[],
    append(KB,NEW_M, NEW_KB),
    print('noii membrii'),
    print(NEW_M),
    print('noua KB'),
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

    

check_member(KB,[],List,List).
check_member(KB,[A|EXT_M],List,NEW_M):-
    \+ member(A,KB),
    append(List,[A],List_UP),
    check_member(KB,EXT_M,List_UP,NEW_M).

check_member(KB,[A|EXT_M],List,NEW_M):-
    check_member(KB,EXT_M,List,NEW_M).

delete_one(_, [], []).
delete_one(A, [A|TAIL], TAIL).
delete_one(A, [HEAD|TAIL], [HEAD|RESULT]) :-
  delete_one(A, TAIL, RESULT).
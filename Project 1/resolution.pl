
negate(n(A),A).
negate(A,n(A)).

containsOp(X, List):- member(n(X), List).
containsOp(n(X), List) :- member(X, List).




get_neg_val([],_,R1,R1).
get_neg_val([H|T],L2,R1,R2):-
    negate(H,N),
    member(N,L2),
    append(R1,[[H,N]],R1_NEW),
    get_neg_val(T,L2,R1_NEW,R2).
get_neg_val([H|T],L2,R1,R2):-
    get_neg_val(T,L2,R1,R2).





% findOpIn2Members([[],List], Pair) :- true.
% findOpIn2Members([[A|TAIL],List],Pair) :- (negate(A,B), member(B,List) -> append([],[A,B], Pair) , findOpIn2Members([TAIL,List],Pair) ; findOpIn2Members([TAIL,List], Pair)).

findOpIn2Members([[A|TAIL],List],LIST_N_VAL, RESULT):-
  negate(A,B),
  member(B,List),
  append(LIST_N_VAL,[[A,B]], NEW_LIST_N_VAL),
  findOpIn2Members([TAIL,List],Pair) ; findOpIn2Members([TAIL,List], Pair)).



remove_duplicates([],[]).
remove_duplicates(X,Y) :-
    setof(Z,member(Z,X),Y).



delete_one(_, [], []).
delete_one(A, [A|TAIL], TAIL).
delete_one(A, [HEAD|TAIL], [HEAD|RESULT]) :-
  delete_one(A, TAIL, RESULT).




remove_complementary([],[]).  
remove_complementary([A|TAIL],RESULT) :- 
  containsOp(A,TAIL),
  delete_one(A,[A|TAIL],RESULTA),
  delete_one(n(A),RESULTA,RESULTNA),
  remove_complementary(RESULTNA,RESULT).

remove_complementary([A|TAIL],[A|RESULT]):-
  remove_complementary(TAIL,RESULT).


combinate(_,[]):- true.
combinate([A|TAIL],[A|Combinate]):-
    combinate(TAIL,Combinate).
combinate([_|TAIL],[A|Combinate]):-
    combinate(TAIL,[A|Combinate]).


merge_lists_no_duplicates([L1, L2], R):- 
  append(L1,L2,R1), list_to_set(R1, R).

res(KB) :- member([],KB),
  print("unsatisfiable").

res(KB):-
  findall([A,B],combinate(KB,[A,B]),ALL),
  get_new_members_KB(ALL,KB,NewKB),
  (var(NewKB) -> print("satisfiable"),   print(NewKB) ; append(KB,NewKB,NewKB2), res(NewKB2)).


get_new_members_KB([],KB,NewKB):- true.

get_new_members_KB([A|TAIL],KB, NewKB):-
  findOpIn2Members(A),
  merge_lists_no_duplicates(A,NoDup),
  remove_complementary(NoDup,NoCom),
  (\+member(NoCom,KB) ->
  (var(NewKB) -> append([], [NoCom], NewKB ) ; append(NewKB,[NoCom],NewKB2) ),
  %merge_lists_no_duplicates([KB,[NoCom]], NewKB),
  print(NewKB2),
  get_new_members_KB(TAIL,KB,NewKB2) ; get_new_members_KB(TAIL,KB, NewKB2)).

get_new_members_KB([A|TAIL],KB,NewKB):-
  get_new_members_KB(TAIL,KB,NewKB).


try(A,B,X) :- var(X), try(A,B,3).
try(A,B,X) :-print(A + B + X).

% res([[]]):-true.

% res([A,B|TAIL]) :-
%   res([B|TAIL]),
%   findOpIn2Members(A,B),
%   merge_lists_no_duplicates(A,B,NoDup),
%   remove_complementary(NoDup, NoCom),
%   member(NoCom, KB),
%   append(KB,NoCom,NewKB),
%   res(NewKB),
%   print(NewKB).

% res([A,B|TAIL]) :-
%   \+findOpIn2Members(A,B),
%   res([A|TAIL]).





% remove_negation(_, [],[]).
% remove_negation(n(A),[A|TAIL],TAIL).
% remove_negation(A, [n(A)|TAIL], TAIL).
% remove_negation(A, [B|TAIL], [B|RESULT]) :- remove_negation(A, TAIL, RESULT).


% deleteNumber([], _, []).
% deleteNumber([H|T], N, [HR|TR]):-
%     H =\= N,
%     HR is H,
%     deleteNumber(T, N, TR).
% deleteNumber([H|T], N, R):-
%     H = N,
%     deleteNumber(T, N, R).


% findOpIn2Members([],List) :- false.
% findOpIn2Members([[A,B]|T],T) :- containsOp(A,List) , findOpIn2Members(TAIL,List).

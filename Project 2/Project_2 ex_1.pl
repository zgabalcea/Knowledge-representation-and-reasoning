negate(n(A),A):-!.
negate(A,n(A)):-!.

processA1(stop,_) :- halt.
processA1(yes, [rhymes]).
processA1(Usr_ans, A1) :- Usr_ans == no, append([],[n(rhymes)],A1).
processA1(Usr_ans, A1) :- writeln("please answer only with 'yes' or 'no'"), ask1(A1).

processA2(Usr_ans, A2) :- Usr_ans == yes, append([],[music],A2).
processA2(Usr_ans, A2) :- Usr_ans == no, append([],[n(music)],A2).
processA2(Usr_ans, A2) :- writeln("please answer only with 'yes' or 'no'"), ask2(A2).

processA3(Usr_ans, A3) :- not(number(Usr_ans)), writeln("please answer only with a number e.g. '43'"), ask3(A3).
processA3(Usr_ans,A3) :- Usr_ans >= 100000, append([],[fans], A3).
processA3(Usr_ans,A3) :- Usr_ans < 100000, append([],[n(fans)], A3).


ask1(Ans1) :- write("are you write rhymes?(yes/no)"), read(Usr_ans1), processA1(Usr_ans1 ,Ans1).
ask2(Ans2) :- write("are you make music?(yes/no)"), read(Usr_ans2), processA2(Usr_ans2,Ans2).
ask3(Ans3) :- write("how many fans do you have?(type a number)"), read(Usr_ans3), processA3(Usr_ans3,Ans3).

ask([Ans1,Ans2,Ans3]) :- ask1(Ans1), ask2(Ans2), ask3(Ans3).
    

read_rules(Rules) :- 
    open('Rules.txt', read, Str),
    read(Str,Rules),
    close(Str).


check_final_response(stop) :- true,!.
check_final_response(_) :- false,!.


final_response() :- 
    writeln("if you want to stop the quiz type 'stop', otherwise type any key and press enter"),
    read(Usr_response),
    Usr_response = stop.
final_response() :- false.


start_quiz() :- 
    read_rules(Rules),
    repeat,
    ask(RList),
    append(Rules,RList, KB),
    backward_chaining(KB,[n(successful_singer)]),
    forward_chaining(KB,[],successful_singer),
    writeln('Continue?'),
    final_response().


merge_lists_no_duplicates(LIST1, LIST2, RESULT):- 
    append(LIST1,LIST2,R), list_to_set(R, RESULT).


substract_helper(A,B,[NA,NB], Resolvent):-
    subtract(A,[NA],A_SUBS),
    subtract(B,[NB],B_SUBS),
    merge_lists_no_duplicates(A_SUBS,B_SUBS,NEW_LIST),
    sort(NEW_LIST,N_L_S),
    append([],N_L_S, Resolvent).


backward_chaining(KB, []) :- writeln("backward chaining result : yes").

backward_chaining(KB, Goal) :-   
    member(Goal_atom, Goal),
    member(C, KB),
    negate(Goal_atom, NG_atom),
    member(NG_atom, C),
    substract_helper(Goal,C,[Goal_atom,NG_atom], RES),
    backward_chaining(KB,RES).

backward_chaining(KB,_) :- writeln("backward chaining result : no").


get_positive_atom([],P) :-!.
get_positive_atom([A|B],A) :- 
    not(A = n(_)),!.
get_positive_atom([A|B],P) :- get_positive_atom(B,P),!.


turn_positive([],[]) :-!.
turn_positive([n(A)|B],[A|T]) :- turn_positive(B,T).

check_solved_new([],_) :- true.
check_solved_new([A|B],Solved) :- 
    member(A,Solved),
    check_solved_new(B,Solved).
check_solved_new(_,_) :- false.


get_new_members([], Solved,List, List) :-!.
get_new_members([C|B], Solved, List, New_Members):-
    get_positive_atom(C, Pos_at),
    subtract(C, [Pos_at], Neg_C),
    turn_positive(Neg_C, Pos_C),
    check_solved_new(Pos_C, Solved),
    not(member(Pos_at, Solved)),
    merge_lists_no_duplicates(List, [Pos_at], New_List),
    get_new_members(B,Solved, New_List,New_Members),!.

get_new_members([C|B], Solved, List, New_Members) :- get_new_members(B, Solved, List, New_Members).


forward_chaining(KB, Solved, Goal) :- member(Goal,Solved), writeln("forward chaining  result : yes"),!.
forward_chaining(KB,Solved, Goal) :- 
    get_new_members(KB,Solved,[],New_Members),
    not(New_Members = []),
    append(Solved,New_Members, Solved_up),
    forward_chaining(KB,Solved_up, Goal).
forward_chaining(_,_,_) :- writeln("forward chaining result : no").
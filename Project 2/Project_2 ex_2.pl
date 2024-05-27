read_rules(Rules) :-
    open('Ex 2 Rules text.txt', read, Str),
    read(Str,Rules),
    close(Str).

processA1(X, X) :- 
    number(X),
    10 >= X,
    X >= 0.

processA1(X,A1) :- 
    writeln("please type only a number on a scale from 1 to 10"),
    ask1(_).

processA2(X, X) :- 
    number(X),
    10 >= X,
    X >= 0.

processA2(X,A1) :- 
    writeln("please type only a number on a scale from 1 to 10"),
    ask1(_).


ask1(Ans1) :- writeln("how oppresive si the political regime, you live on a scale from 1 to 10"), nl, read(Usr_ans1), processA1(Usr_ans1 ,Ans1).
ask2(Ans2) :- writeln("how big is the average income, on a scale from 1 to 10?"), nl, read(Usr_ans2), processA2(Usr_ans2,Ans2).

ask([Ans1,Ans2]) :- ask1(Ans1), ask2(Ans2).

start_quiz(Rules,Ans) :- read_rules(Rules),ask(Ans).
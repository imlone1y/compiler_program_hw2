% initialize gender using fact (set)
male(andy).  male(bob).  male(cecil).  male(dennis).
male(edward). male(felix). male(martin). male(oscar). male(quinn).

female(gigi). female(helen). female(iris).  female(jane).
female(kate). female(liz).  female(nancy). female(pattie). female(rebecca).

% initialize marriage using relation (hashMap)
married(bob, helen).   married(helen, bob).
married(dennis, pattie). married(pattie, dennis).
married(gigi, martin).   married(martin, gigi).

% direct_parent(parent, child) using relation
direct_parent(andy, bob).
direct_parent(bob, cecil).
direct_parent(cecil, dennis).
direct_parent(dennis, edward).
direct_parent(edward, felix).

direct_parent(gigi, helen).
direct_parent(helen, iris).
direct_parent(iris, jane).
direct_parent(jane, kate).
direct_parent(kate, liz).

direct_parent(martin, nancy).
direct_parent(nancy, oscar).
direct_parent(oscar, pattie).
direct_parent(pattie, quinn).
direct_parent(quinn, rebecca).

% Rule
parent(X, Y) :- direct_parent(X, Y).
% the child has two parents
parent(Y, Z) :- direct_parent(X, Z), married(X, Y).

% if x and y have same parents, and x != y, they are siblings
sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.
% if x and y are siblings, and both x and y are male, they are brothers
brother(X, Y) :- sibling(X, Y), male(X), male(Y).
% if x and y are siblings, and both x and y are female, they are sisters
sister(X, Y)  :- sibling(X, Y), female(X), female(Y).
% if y's parent w and z' parent x are siblings, then z and y are cousins
cousin(Y, Z)  :- parent(W, Y), parent(X, Z), sibling(W, X).

% ---------- 批次查詢 ----------
initial_query :-
    (parent(helen, cecil) ->
        write('true'), nl ; write('false'), nl),
    (parent(cecil, felix) ->
        write('true'), nl ; write('false'), nl),
    (sibling(cecil, iris) ->
        write('true'), nl ; write('false'), nl),
    (sibling(jane, pattie) ->
        write('true'), nl ; write('false'), nl),
    (brother(edward, quinn) ->
        write('true'), nl ; write('false'), nl),
    (brother(cecil, iris) ->
        write('true'), nl ; write('false'), nl),
    (sister(helen, nancy) ->
        write('true'), nl ; write('false'), nl),
    (sister(iris, pattie) ->
        write('true'), nl ; write('false'), nl),
    (cousin(iris, oscar) ->
        write('true'), nl ; write('false'), nl),
    (cousin(kate, quinn) ->
        write('true'), nl ; write('false'), nl).


:- initial_query.

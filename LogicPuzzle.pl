%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% LogicPuzzle.pl %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Sean Foley %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% CSCI 4540 %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% 10/27/15 %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Made for my CSCI 4540 Symbolic Programming course at the University of Georgia
%Solves a logic puzzle using SWI Prolog
%Taught by Dr. Potter: cobweb.cs.uga.edu/~potter/

%entry point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
go :-
	solve(Shops),
	nl,
	fail.

%trigger all the facts,
%then add the ferret and the pepsi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve(Shops) :-
	empty(EmptySet),
	length(Shops, 5),
	fill(Shops, EmptySet, Results1),
	rule2(Shops, Results1, Results2),
	rule3(Shops, Results2, Results3),
	rule4(Shops, Results3, Results4),
	rule5(Shops, Results4, Results5),
	rule6(Shops, Results5, Results6),
	rule7(Shops, Results6, Results7),
	rule8(Shops, Results7, Results8),
	rule9(Shops, Results8, Results9),
	rule10(Shops,Results9, Results10),
	rule11(Shops, Results10, Results11),
	rule12(Shops, Results11, Results12),
	rule13(Shops, Results12, Results13),
	rule14(Shops, Results13, Results14),
	rule15(Shops, Results14, Results15),
	addMembers(Shops, Results15, FinalResults),
	writeFormatted(FinalResults, 0), nl, nl,
	findFerret(Shops, F),
	write(F), nl, nl,
	findPepsi(Shops, P),
	write(P), nl, nl, nl.

%Shop Filler
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fill(Shops, Results, NewResults) :-
	member([_, _, _, _, _, 1], Shops),
	member([_, _, _, _, _, 2], Shops),
	member([_, _, _, _, _, 3], Shops),
	member([_, _, _, _, _, 4], Shops),
	member([_, _, _, _, _, 5], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults),
	!. %red cut, keeps the shops in order

empty([]).

%Facts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) There are 5 different color shops in a row at the mall,
% each having a European owner who owns a pet animal, has a
% favorite game, and a favorite drink.
% 
% Representation: [Color, Owner, Pet, Game, Drink, Number]

% 2) The Englishman works in the red shop.
rule2(Shops, Results, NewResults) :-
	member([red, english, _, _, _, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 3) The Spaniard has a dog.
rule3(Shops, Results, NewResults) :-
	member([_, spanish, dog, _, _, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 4) They drink coffee in the green shop.
rule4(Shops, Results, NewResults) :-
	member([green, _, _, _, coffee, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 5) The Belgian drinks tea.
rule5(Shops, Results, NewResults) :-
	member([_, belgian, _, _, tea, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 6) The green shop is next to the orange shop.
rule6(Shops, Results, NewResults) :-
	member([green, _, _, _, _, X], Shops),
	member([orange, _, _, _, _, Y], Shops),
	adjacent(X, Y),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 7) The Angry Birds player has a cat.
rule7(Shops, Results, NewResults) :-
	member([_, _, cat, angryBirds, _, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 8) In the yellow shop they play Candy Crush.
rule8(Shops, Results, NewResults) :-
	member([yellow, _, _, candyCrush, _, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 9) In the middle shop they drink Red Bull.
rule9(Shops, Results, NewResults) :-
	member([_, _, _, _, redBull, 3], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 10) The Norwegian works in the first shop from the left.
rule10(Shops, Results, NewResults) :-
	member([_, norwegian, _, _, _, 1], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 11) The SpongeBob player works next to the person with the goldfish.
rule11(Shops, Results, NewResults) :-
	member([_, _, _, spongeBob, _, X], Shops),
	member([_, _, goldfish, _, _, Y], Shops),
	adjacent(X, Y),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 12) In the shop next to the shop with the rabbit they play Candy Crush.
rule12(Shops, Results, NewResults) :-
	member([_, _, _, candyCrush, _, X], Shops),
	member([_, _, rabbit, _, _, Y], Shops),
	adjacent(X, Y),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 13) The Jetpack Joyride player drinks Powerade.
rule13(Shops, Results, NewResults) :-
	member([_, _, _, jetpackJoyride, powerade, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 14) The French person plays Words With Friends.
rule14(Shops, Results, NewResults) :-
	member([_, french, _, wordsWithFriends, _, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% 15) The Norwegian works next to the blue shop.
rule15(Shops, Results, NewResults) :-
	member([_, norwegian, _, _, _, X], Shops),
	member([blue, _, _, _, _, Y], Shops),
	adjacent(X, Y),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

% Adds the last remaining members to the only remaining spaces
addMembers(Shops, Results, NewResults) :-
	member([_, _, ferret, _, _, _], Shops),
	member([_, _, _, _, pepsi, _], Shops),
	fillNonVars(Shops, FilledShops),
	append(Results, FilledShops, NewResults).

%Makes sure two numbers are adjacent and 0<x<5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
adjacent(N1, N2) :-
	member(N1, [1, 2, 3, 4, 5]),
	N2 is N1 - 1,
	member(N2, [1, 2, 3, 4, 5]).
adjacent(N1, N2) :-
	member(N1, [1, 2, 3, 4, 5]),
	N2 is N1 + 1,
	member(N2, [1, 2, 3, 4, 5]).

%Finder Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
findFerret(Shops, FerretShop) :-
	member(FerretShop, Shops),
	nth0(2, FerretShop, ferret).

findPepsi(Shops, PepsiShop) :-
	member(PepsiShop, Shops),
	nth0(4, PepsiShop, pepsi).

%Formatting stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fillNonVars([], []).
fillNonVars([H | T], ['_' | NT]) :-
	\+nonvar(H),
	fillNonVars(T, NT).
fillNonVars([H | T], [H | NT]) :-
	\+is_list(H),
	nonvar(H),
	fillNonVars(T, NT).
fillNonVars([H | T], [NH | NT]) :-
	is_list(H),
	fillNonVars(H, NH),
	fillNonVars(T, NT).

writeFormatted([], _).
writeFormatted([H | T], Counter) :-
	Counter = 4,
	write(H), nl, nl,
	writeFormatted(T, 0).
writeFormatted([H | T], Counter) :-
	Counter \== 4,
	write(H), nl,
	NewCounter is Counter + 1,
	writeFormatted(T, NewCounter).

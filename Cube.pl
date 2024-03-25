x_tester4(N) :-
    x_tester4_loop(
        [
            [[8, 2, 7], [6, 1], [5, 3], [4, 0, 9]],
            [[8, 2, 7], [6, 1], [4, 0, 9], [5, 3]],
            [[8, 2, 7], [5, 3], [6, 1], [4, 0, 9]],
            [[8, 2, 7], [4, 0, 9], [6, 1], [5, 3]],
            [[6, 1], [8, 2, 7], [4, 0, 9], [5, 3]],
            [[6, 1], [4, 0, 9], [5, 3], [8, 2, 7]],
            [[5, 3], [6, 1], [4, 0, 9], [8, 2, 7]],
            [[5, 3], [4, 0, 9], [6, 1], [8, 2, 7]],
            [[4, 0, 9], [5, 3], [8, 2, 7], [6, 1]],
            [[4, 0, 9], [8, 2, 7], [6, 1], [5, 3]]
        ],
        0,
        N
    ).

x_tester4_loop([], C, C).

x_tester4_loop([T|TS], C, N) :-
    tester4(T),
    C1 is C + 1,
    x_tester4_loop(TS, C1, N).

x_tester4_loop([_|TS], C, N) :-
    x_tester4_loop(TS, C, N).



x_generator4(N)
 :-
    x_generator4_loop(
        [
            [[9, 6, 7],[4, 0, 1],[2, 8, 3],[5]],
            [[9, 8, 3],[6, 0, 1],[5],[4, 7],[2]],
            [[9, 8, 3],[6, 7],[4, 2, 0, 1],[5]],
            [[9, 8, 5, 1],[2],[4, 3],[6, 0, 7]],
            [[9, 8, 5, 1],[2], [3],[6, 0, 4, 7]],
            [[9, 8, 5, 1],[2], [7],[4, 6, 0, 3]],
            [[8, 9], [7],[6, 0, 1],[2, 5, 4, 3]],
            [[8, 9], [7],[5, 6, 3],[4, 0, 2, 1]],
            [[8, 9],[5],[4, 7],[6, 0, 1],[3],[2]],
            [[3],[5],[6, 0, 7],[2],[4, 1],[8, 9]]
        ],
        0,
        N
    ).

x_generator4_loop([], C, C).

x_generator4_loop([T | TS], C, N) :-
    generator4(T), % Assuming generator4/1 is a condition to be met by T
    C1 is C + 1,    % Increment the count
    x_generator4_loop(TS, C1, N).


x_generator4_loop([_ | TS], C, N) :-
    x_generator4_loop(TS, C, N).

% Check if a number is prime
is_prime(2).
is_prime(3).
is_prime(N)
 :-
    N > 3,
    N mod 2 =\= 0,
    \+ has_factor(N, 3).

% Helper to check for factors
has_factor(N, F) :-
    N mod F =:= 0.
has_factor(N, F) :-
    F * F < N,
    F2 is F + 2,
    has_factor(N, F2).

% Convert a list of digits to a number, ignoring leading zeros
list_to_number(List, Number) :-
    drop_leading_zeros(List, CleanList),
    CleanList \= [],
    list_to_number(CleanList, 0, Number).

drop_leading_zeros([0|T], CleanList) :- 
    drop_leading_zeros(T, CleanList), !.
drop_leading_zeros(List, List).

list_to_number([], Acc, Acc).
list_to_number([H|T], Acc, Number) :-
    NewAcc is Acc * 10 + H,
    list_to_number(T, NewAcc, Number).

% Convert a list of digits to a number
digits_to_number(Digits, Number) :-
    foldl(num_append, Digits, 0, Number).

num_append(D, N, N1) :-
    N1 is N * 10 + D.

number_digits(N, Digits) :-
    number_codes(N, Codes),
    maplist(code_digit, Codes, Digits).

code_digit(Code, Digit) :-
    Digit is Code - 48.

% Check if the sequence of digits can be divided into runs forming cubes
check_cube_runs([]).
check_cube_runs(Digits) :-
    append(Run, Rest, Digits),
    length(Run, L),
    L >= 1, L =< 4,
    digits_to_number(Run, Num),
    is_cube(Num),
    check_cube_runs(Rest).

% Check if a number is a perfect cube
is_cube(N) :-
    N > 0,
    Root is round(N ** (1/3)),
    N =:= Root * Root * Root.

main :- 
    generator4(X),
    tester4(X),
    write(X).

generator4(X) :-
	generator1([0,1,2,3,4,5,6,7,8,9], X).
generator1([], []).
generator1(List, [Num|X]) :-
	take_num(List, Num, Rest),
	length(Num, L),
	L > 0, L =< 4,
	Num \= [0|_],
    list_to_number(Num, Number),
    is_prime(Number),
	generator1(Rest, X).
take_num(List, [], List).
take_num(List, [X|D], List2) :-
	select(X, List, List1),
	take_num(List1, D, List2).

tester4(Lists) :-
    maplist(digits_to_number, Lists, Numbers),
    sort(Numbers, [_|Primes]),
	reverse(Primes, Primes1),
    maplist(number_digits, Primes1, RemainingLists),
    append(RemainingLists, Digits),
    check_cube_runs(Digits).
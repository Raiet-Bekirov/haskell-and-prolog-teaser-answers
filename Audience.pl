% Predicate to check if a number is a perfect square
is_perfect_square(N) :-
    SquareRoot is sqrt(N),        % Compute the square root
    RoundedRoot is round(SquareRoot),  % Round it to the nearest integer
    N is RoundedRoot * RoundedRoot.

% Predicate to generate numbers that are perfect squares
generator3(N) :-
    between(1000, 1000000, N),  % Iterate over the range 1,000 to 1,000,000
    is_perfect_square(N).

x_generator3(N) :-
    x_generator3_loop(
        [1024, 9409, 23716, 51529, 123904, 185761, 868624, 962361, 982081, 1000000],
        0,
        N
    ).

x_generator3_loop([], C, C).

x_generator3_loop([T | TS], C, N) :-
    generator3(T),
    C1 is C + 1,
    x_generator3_loop(TS, C1, N).

x_generator3_loop([_ | TS], C, N) :-
    x_generator3_loop(TS, C, N).

% Convert a number to a list of its digits
number_to_digits(N, Digits) :-
    number_to_digits(N, [], Digits).

number_to_digits(0, Digits, Digits) :- !.
number_to_digits(N, Acc, Digits) :-
    N > 0,
    LastDigit is N mod 10,
    Rest is N div 10,
    number_to_digits(Rest, [LastDigit | Acc], Digits).

% Check if all elements in a list are unique
all_unique([]).
all_unique([Head | Tail]) :-
    \+ member(Head, Tail),
    all_unique(Tail).

% Predicate to check if a list of digits satisfies the conditions
check_digits(Digits) :-
    length(Digits, Length),
    nth1(Length, Digits, Length), % Last digit equals the number of digits
    Length1 is Length - 1,
    nth1(Length1, Digits, LastButOne),
    LastButOne mod 2 =:= 1, % Last-but-one digit is odd
    member(0, Digits), % Contains zero
    nth1(1, Digits, FirstDigit),
    nth1(2, Digits, SecondDigit),
    nth1(3, Digits, ThirdDigit),
    valid_multiple(SecondDigit, FirstDigit),
    valid_multiple(ThirdDigit, FirstDigit),
    valid_multiple(LastButOne, FirstDigit).

% Check if a digit is a valid multiple of the first digit (0 is not a multiple)
valid_multiple(Digit, FirstDigit) :-
    Digit =\= 0, % 0 is not considered a valid multiple
    Digit mod FirstDigit =:= 0.


tester3(N) :-
    number_to_digits(N, Digits),
    all_unique(Digits),
    check_digits(Digits).

x_tester3(N) :-
    x_tester3_loop(
        [123056, 128036, 139076, 142076, 148056, 159076, 173096, 189036, 193056, 198076], 
        0, 
        N
    ).

x_tester3_loop([], C, C).

x_tester3_loop([T|TS], C, N) :-
    tester3(T),
    C1 is C + 1,
    x_tester3_loop(TS, C1, N).

x_tester3_loop([_|TS], C, N) :-
    x_tester3_loop(TS, C, N).

main :- 
    generator3(X),
    tester3(X),
    write(X).
-module(seq).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

%PALINDROME
is_palindrome(K) ->
  Elab = string:lowercase(lists:filter(fun(X) -> not lists:member(X, [$., $?, $,, $:, 32]) end, K)),
  string:equal(Elab, lists:reverse(Elab)).

%ANAGRAM
is_an_anagram(_, []) -> false;
is_an_anagram(W, [HD|TL]) ->
  is_an_anagram(lists:sort(fun(X,Y) -> X>Y end , W), lists:sort(fun(X,Y) -> X>Y end , HD), TL).

is_an_anagram(A,A,_) -> true;
is_an_anagram(A,B,[]) -> false;
is_an_anagram(A,B,[HD|TL]) -> is_an_anagram(lists:sort(fun(X,Y) -> X>Y end , A),HD,TL).

%FACTORIALS
factors(N) when N < 2 -> [];
factors(N) -> factors(N, thunks:primes()).
factors(N, [HD|_]) when N rem HD == 0 -> [HD | factors(N div HD, thunks:primes())];
factors(N, [HD|TL]) when HD < N -> factors(N, TL());
factors(_, _) -> [].

%PROPER
is_proper(N) -> lists:foldl(fun(X,ACC) -> ACC + X end , 0, is_proper(N, thunks:from(1))) == N.
is_proper(N, [HD|_]) when N =< HD -> [];
is_proper(N, [HD|TL]) when N rem HD == 0 -> [HD | is_proper(N, TL())];
is_proper(N, [_|TL]) -> is_proper(N, TL()).

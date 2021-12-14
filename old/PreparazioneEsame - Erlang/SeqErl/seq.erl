-module(seq).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

is_palindrome(S) ->
  Fixed = string:casefold (lists:filter (fun(X) -> not lists:member(X, [$;, $., $,, $", $', $?, $!, 32]) end, S)),
  string:equal(Fixed, lists:reverse(Fixed)).

is_an_anagram(_, []) -> false;
is_an_anagram(S, [HD|TL]) ->
  case string:equal(lists:sort(S), lists:sort(HD)) of
    true -> true;
    false -> is_an_anagram (S, TL)
  end.

factors(I) -> factors(I, thunks2:primes()).
factors(_, []) -> [];
factors(I, [HD|TL]) when HD =< I ->
  case I rem HD == 0 of
    true ->  [HD|factors (trunc(I / HD),[HD|TL])];
    false -> factors(I, TL())
  end;
factors(1, _) -> [1];
factors(_, _) -> [].

divisor(I) -> divisor(I, thunks2:from(1)).
divisor(I, [HD|TL]) when HD < I ->
  case I rem HD == 0 of
    true -> [HD|divisor(I, TL())];
    false ->  divisor(I, TL())
  end;
divisor(_,_) -> [].

is_proper(I) -> I == lists:foldr (fun(Acc,Val) -> Acc + Val end, 0, divisor(I)).

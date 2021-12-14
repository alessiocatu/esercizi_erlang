-module(es1).
-export([is_palindrome/1, is_an_anagram/2, factors/1, divisor/1, is_proper/1]).

is_palindrome(S) ->
  L = string:casefold(lists:filter(fun(X) -> not lists:member(X, [$,, $., $;, $?, 32]) end, S)),
  string:equal(string:reverse(L), L).

is_an_anagram(_, []) -> false;
is_an_anagram(S, [HD|TL]) ->
  is_an_anagram(lists:sort(S), lists:sort(HD), TL).

is_an_anagram(A, A, _)  -> true;
is_an_anagram(_, _, []) -> false;
is_an_anagram(A, _, [HD|TL]) ->
  is_an_anagram(A, HD, TL).

get_n_primi() -> [2,3,5,7,11,13,17,18,23,29,31,37,41,43,47,53,59,61,67].

factors(I) ->
  factors(I, get_n_primi(),[]).

factors(1, _, ACC) -> ACC ++ [1];
factors(I, [H|T], ACC) ->
  case (I rem H /= 0) of
    true  -> factors(I, T, ACC);
    false -> factors(I div H, get_n_primi(), ACC ++ [H])
  end.

divisor(I) ->
  divisor(I, 1, []).

divisor(I, DIV, ACC) ->
  if
    I /= DIV ->
      case I rem DIV /= 0 of
        true  -> divisor(I, DIV+1, ACC);
        false -> divisor(I, DIV+1, ACC ++ [DIV])
      end;
   true -> ACC
 end.

is_proper(I) ->
    lists:sum(divisor(I)) == I.

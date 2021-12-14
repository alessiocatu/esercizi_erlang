-module(testing).
-export([test_is_palindrome/0, test_is_anagram/0, test_print_factors/0]).

test(F, L) ->
  lists:foreach(
    fun(X) -> (io:format("~p : ~p~n", [X, F(X)])) end,
    L).

test_is_palindrome() -> test(
  fun(X) -> es1:is_palindrome(X) end,
  ["test","detartrated", "Do geese see God?", "Rise to vote, sir."]
).

test_is_anagram() -> test(
  fun(X) -> es1:is_an_anagram(X,
    ["rat","art","tar"]) end,
    ["rta"]
).

test_print_factors() -> test(
  fun(X) -> es1:factors(X) end,
  [1, 25, 8, 100, 50, 47, 94]
).

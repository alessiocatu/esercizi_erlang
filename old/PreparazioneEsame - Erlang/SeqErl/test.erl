-module(test).
-export([test_pali/0, test_ana/0]).


test_pali() ->
  lists:foreach (fun(X) -> io:format("~p :- ~p~n", [X, seq:is_palindrome(X)]) end,
      ["detartrated", "Do geese see God?", "Rise to vote, sir", "I am not a Palindrome"]).

test_ana() ->
  lists:foreach (fun(X) -> io:format("~p :- ~p~n", [X, seq:is_an_anagram(X, [
    "tar", "rat", "arc", "car", "elbow", "below"
    ])]) end,
      ["tar", "rat", "arc", "car", "elbow", "below"]).

  

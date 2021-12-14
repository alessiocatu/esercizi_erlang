-module(test).
-export([is_palindrome/0, is_an_anagram/0, factors/0, is_proper/0]).

is_palindrome() ->
  io:format("~p is palindrome? -> ~p\n", ["detartrated", seq:is_palindrome("detartrated")]),
  io:format("~p is palindrome? -> ~p\n", ["Do geese see God?", seq:is_palindrome("Do geese see God?")]),
  io:format("~p is palindrome? -> ~p\n", ["Rise to vote, sir.", seq:is_palindrome("Rise to vote, sir.")]),
  io:format("~p is palindrome? -> ~p\n", ["Pino mauro.", seq:is_palindrome("Pino mauro.")]).

is_an_anagram() ->
  List = ["ioac", "pippo", "pluto", "sandro", "teo"],
  io:format("~p\n", [List]),
  io:format("~p is an anagram -> ~p\n", ["ciao", seq:is_an_anagram("ciao", List)]),
  io:format("~p is an anagram -> ~p\n", ["lion", seq:is_an_anagram("lion", List)]).

factors() ->
  io:format("~p primes factors -> ~p\n", [6, seq:factors(6)]),
  io:format("~p primes factors -> ~p\n", [2, seq:factors(2)]),
  io:format("~p primes factors -> ~p\n", [0, seq:factors(0)]),
  io:format("~p primes factors -> ~p\n", [6552, seq:factors(6552)]).

is_proper() ->
  io:format("~p is a perfet number? -> ~p\n", [0, seq:is_proper(0)]),
  io:format("~p is a perfet number? -> ~p\n", [3, seq:is_proper(3)]),
  io:format("~p is a perfet number? -> ~p\n", [6, seq:is_proper(6)]),
  io:format("~p is a perfet number? -> ~p\n", [28, seq:is_proper(28)]),
  io:format("~p is a perfet number? -> ~p\n", [496, seq:is_proper(496)]),
  io:format("~p is a perfet number? -> ~p\n", [453, seq:is_proper(453)]),
  io:format("~p is a perfet number? -> ~p\n", [8129, seq:is_proper(8129)]).

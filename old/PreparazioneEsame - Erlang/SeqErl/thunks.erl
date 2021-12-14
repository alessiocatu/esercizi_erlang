-module(thunks).
-export([from/1, first/1, is_primes/1, primes/0, take/1]).

from(K) -> [K | fun() -> from(K+1) end].

take(N) -> take(N, from(1)).
take(0,_) -> [];
take(N, [HD|TL]) -> [HD|take((N-1), TL())].

filter(_, [], _) -> [];
filter(P, [HD|TL], N) ->
  io:format("ITERAZIONE Numero -> ~p con HD:~p e TL:~p\n", [N,HD,TL]),
  case P(HD) of
    true -> [HD|fun() -> filter(P,TL(), N+1) end];
    false -> filter(P,TL(), N+1)
  end.

sift(N,L) -> filter(fun(X) -> X rem N /= 0 end, L, 0).
sieve([HD|TL]) -> [HD|fun() -> sieve(sift(HD, TL())) end].

primes() -> sieve(from(2)).

is_primes(N) -> is_primes(N, primes()).
is_primes(N, [N,_]) -> true;
is_primes(N, [M,TL]) when M < N -> is_primes(N, TL());
is_primes(_,_) -> false.

first(N) -> first(N, primes()).
first(0,_) -> [];
first(N,[X|P]) -> [X|first(N-1, P())].

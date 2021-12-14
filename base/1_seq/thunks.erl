-module(thunks).
-export([from/1, primes/0, is_prime/1, first/1]).


from(K) -> [K | fun() -> from(K+1) end].

is_prime(K) -> is_prime(K, from(2)).
is_prime(K, [HD|TL]) when HD < K ->
  case K rem HD /= 0 of
    true -> is_prime(K, TL());
    false -> false
  end;
is_prime(_, _) -> true.

find_prime([HD|TL]) ->
  case is_prime(HD) of
    true -> [HD|TL];
    false -> find_prime(TL())
  end.
next_prime([HD|TL]) -> [HD | fun() -> next_prime(find_prime(TL())) end].

primes() -> next_prime(from(2)).

first(K) -> first(K, primes()).
first(K, [HD|TL]) when K > 0 -> [HD | first(K-1, TL())];
first(_, _) -> [].

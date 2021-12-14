-module(thunks2).
-export([from/1, primes/0, take/1, is_prime/1]).

from(N) -> [N|fun () -> from(N+1) end].

is_prime(N) -> is_prime(N, from(2)).
is_prime(N, [HD|TL]) when HD < N ->
  case (N rem HD /= 0) of
    true -> true and is_prime (N, TL());
    false -> false
  end;
is_prime(_,_) -> true.

sieve([HD|TL]) ->
  case is_prime(HD) of
    true -> [HD|fun () -> sieve(TL()) end];
    false -> sieve(TL())
  end.

primes() -> sieve(from(2)).

take(N) -> take(N, primes()).
take(0,_) -> [];
take(N, [HD|TL]) -> [HD|take(N-1, TL())].

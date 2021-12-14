-module(list).
-export([squered_int/1]).

squered_int(L) -> [X*X || X <- L, is_integer(X)].

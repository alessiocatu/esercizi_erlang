-module(eval).
-export([exp/1]).

exp(S) -> exp(S, []).

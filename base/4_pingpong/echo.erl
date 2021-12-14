-module(echo).
-export([start/1, create/0]).

start(N) ->
  spawn(N, echo, create, []),
  ok.

create() ->
    io:format("test\n").

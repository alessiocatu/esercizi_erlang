-module(thunkstest).
-export([take/1, is/0]).

from(K) -> [K | fun() -> from(K+1) end].

take(N) -> take(N, from(1)).
take(0, _) -> [];
take(N, [HD|TL]) -> [HD | take((N-1), (TL()))].

is() ->
  io:format("I'm this actor -> ~p~n", [self()]),
  process_flag(trap_exit, true),
  Pid = spawn_link(fun() -> wait() end),
  io:format("I've spawned this actor -> ~p~n", [Pid]),
  receive
    {EXIT, Pid, _Why} -> io:format("Actor ~p dead -> ~p", [Pid, EXIT])
  end.

wait() ->
  exit(kill).

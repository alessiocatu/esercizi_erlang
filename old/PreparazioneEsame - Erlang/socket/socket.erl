-module(socket).
-export([start/1]).

start(MM) -> loop(MM).

loop(MM) ->
  io:format("Im into loop~n"),
  receive
    {chan, MM, {store, K, V}} -> io:format("Im into store -: [K -> ~p] [V -> ~p]~n", [K,V]), kvs:store(K,V), loop(MM);
    {chan, MM, {lookup, K}} -> io:format("Im into lookup -: [K -> ~p]~n", [K]), MM ! {send, kvs:lookup(K)}, loop(MM);
    {chan_closed, MM} -> io:format("Im into chan_closed~n"), true
  end.

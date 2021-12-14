-module(lc).
-export([start/3]).
-import()

start(MM, _ArgsC, _ArgS) ->
  %MM = lib_chan:start_server("lib.conf"),
  loop(MM).

loop(MM) ->
  receive
    {chan, MM, {store, Key, Value}} -> put(Key, Value), loop(MM);
    {chan, MM, {lookup, Key}} -> MM ! {send, get(Key)}, loop(MM);
    {chan_closed, MM} -> true
  end.

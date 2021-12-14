-module(test).
-export([start/2, send_msg/2, stop/1]).

start(Node, L) ->
  spawn(Node, fun() -> create(L) end).

create(L) ->
  group_leader(whereis(user), self()),
  global:register_name(L, self()),
  io:format("im [~p] creted on [~p] as [~p] ~n", [self(), node(), L]),
  wait().

wait() ->
  io:format("[~p] Waiting...~n", [self()]),
  receive
    {msg, M} -> io:format("[~p] Here it is ~p~n", [self(), M]), wait();
    {stop} -> io:format("[~p] Stopping", [self()]);
    Other -> io:format("[~p] I got this: ~p~n", [self(), Other]), wait()
  end.

send_msg(L, M) -> global:whereis_name(L) ! {msg, M}.
stop(L) -> global:whereis_name(L) ! {stop}.

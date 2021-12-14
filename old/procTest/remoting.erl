-module(remoting).
-export([start/2, create/1, send_msg/2, stop/1]).

%spawn (Node, module, func, args)
start(N, L) ->
  spawn(N, remoting, create, [L]).

% -> global <- è un modulo che fornisce la register normale
%ma a livello di sistemi distribuiti

%register_name(Name, Pid)
create(L) ->
  group_leader(whereis(user), self()),
  global:register_name(L, self()),
  io:format("I'm the actor <~p> created on ~p and registered as ~p~n", [self(), node(), L]),
  wait().

wait() ->
  io:format("Waiting ...~n", []),
  receive
    {msg, M} -> io:format("Here it is ~p~n", [M]), wait();
    {stop} -> io:format("Stopping~n");
    Other -> io:format("I got this :- ~p~n", [Other])
  end.

send_msg(L, M) -> global:whereis_name(L) ! {msg, M}.
stop(L) -> global:whereis_name(L) ! {stop}.

%SE IL PID INIZIA CON 0 ALLORA E' LA MACCHINA LOCALE

-module(pp).
-export([start/0, print/1, stop/0, wait/1, client/0]).

start() ->
  register(server, spawn(?MODULE, client, [])).

client() ->
  Client = spawn_link(?MODULE, wait, [self()]),
  wait_server(Client).

wait_server(Client) ->
  io:format("[~p] Sto aspettando un messaggio...~n", [server]),
  receive
    M ->
      io:format("[~p] Messaggio ricevuto lo inoltro al client ~p -> ~p~n", [server, Client, M]),
      Client ! M,
      wait_server(Client)
  end.

wait(Pid) ->
  io:format("[~p] Sto aspettando un messaggio da server...~n", [Pid]),
  receive
    {msg, M} -> io:format("[~p] Messaggio ricevuto da ~p -> ~p~n", [Pid, server, M]), wait(Pid);
    stop ->
      io:format("[~p] Mi killo~n", [Pid]),
      io:format("[~p] Per propagazione killo il server ~n", [Pid]),
      exit(kill);
    Other -> io:format("[~p] Messaggio non gestito ricevuto da ~p:- ~p~n", [Pid, server, Other]), wait(Pid)
  end.

print(M) ->
  case whereis(server) of
    undefined -> start(), server ! {msg, M};
    _ -> server ! {msg, M}
  end.

stop() ->
  case whereis(server) of
    undefined -> start(), server ! stop;
    _ -> server ! stop
  end.

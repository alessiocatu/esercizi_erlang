-module(echo).
-export([start/0, create/1, wait/0, print/1, stop/0]).

start() ->
  spawn(asar@UtacFreak, echo, create, [as@r]).

create(L) ->
    group_leader(whereis(user), self()),
    global:register_name(L, self()),
    io:format("Istanziato un nuovo processo ~p sulla macchina ~p rinominata ~p~n", [self(), node(), L]),
    wait().

wait() ->
    io:format("Aspetto un messaggio...~n", []),
    receive
      {msg, M}  -> io:format("Il client ha inviato il seguente messaggio: ~n~p~n", [M]), wait();
      {stop}    ->
        io:format("IL PROCESSO SERVER E' TERMINATO~n"),
        exit(end_process);
      Other     -> io:format("Hai inviato :- ~p -> Ma non è supportato~n", [Other])
    end.

print(L) ->  global:whereis_name(as@r) ! {msg, L}.

stop() -> global:whereis_name(as@r) ! {stop}.

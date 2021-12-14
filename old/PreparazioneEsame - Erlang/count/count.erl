-module(count).
-export([start/0, print/1, sum/2, tot/1, init_log/0, log/3]).

start() ->
  register(server, spawn(?MODULE, init_log, [])).

init_log() ->
  Logger = spawn_link(?MODULE, log, [[],[],[]]),
  wait(Logger).

log(Print, Sum, Tot) ->
  receive
    {print, M} ->
      Log = lists:concat(['[',length(Print)+1, '] Calling print with this messages -> ', M]),
      io:format("Aggiunto print record ~p~n", [Log]),
      log([list_to_atom(Log)|Print], Sum, Tot);
    {sum, A, B} ->
      Log =  lists:concat(['[',length(Sum)+1, '] Calling sum with ', A, '+', B,'=', A+B]),
      io:format("Aggiunto sum record ~p~n", [Log]),
      log(Print, [list_to_atom(Log)|Sum], Tot);
    tot ->
      Log =  lists:concat(['[',length(Tot)+1, '] Calling tot ']),
      io:format("Aggiunto tot record ~p~n", [Log]),
      log(Print, Sum, [list_to_atom(Log)|Tot]);
    {tot,print} -> [io:format("~p~n", [X]) || X <- Print], log(Print, Sum, Tot);
    {tot,sum} -> [io:format("~p~n", [X]) || X <- Sum], log(Print, Sum, Tot);
    {tot,tot} -> [io:format("~p~n", [X]) || X <- Tot], log(Print, Sum, Tot)
  end.


wait(Logger) ->
  receive
    {print, M} ->
      io:format("Print ~p~n", [M]),
      Logger ! {print, M}, wait(Logger);
    {sum, A, B} ->
      io:format("Sum :- ~p + ~p = ~p~n", [A,B,A+B]),
      Logger ! {sum, A,B}, wait(Logger);
    {tot, F} ->
      Logger ! tot,
      case F of
        print -> Logger ! {tot,print};
        sum -> Logger ! {tot,sum};
        tot -> Logger ! {tot,tot};
        Other -> io:format("Non esiste la funzione ~p!~n", [Other])
      end, wait(Logger);
      Other -> io:format("Non esiste la funzione ~p!~n", [Other]), wait(Logger)
  end.

print(M) ->
  server ! {print, M}.

sum(A, B) ->
  server ! {sum, A, B}.

tot(F) ->
  server ! {tot, F}.

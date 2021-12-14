-module(ring).
-export([start/3, next/3, idle/0]).

%TODO: L'esercizio non è proprio così. Bisognerebbe collegare il nodo finale con quello inziale

% N numero di processi
% M volte il messaggio
% Messaggio
start(M, N, Message) ->
  Pid = spawn(ring, next, [M, N-1, Message]),
  Pid ! {Message, M-1}.

next(_, 0, _) ->
  io:format("[~p] im a new process\n", [self()]),
  ring:idle();
next(M, N, Message) ->
  io:format("[~p] im a new process\n", [self()]),
  Pid = spawn(ring, next, [M, N-1, Message]),
  Pid ! {Message, M-1},
  ring:idle().

idle() ->
  receive
    {Message, 0} ->
      io:format("[~p] [#~p] received: ~p\n", [self(), 0, Message]),
      self() ! {quit},
      idle();
    {Message, M} ->
      io:format("[~p] [#~p] received: ~p\n", [self(), M, Message]),
      self() ! {Message, M-1},
      idle();
    {quit} ->
      io:format("[~p] received: ### ~p ###\n", [self(), quit]),
      io:format("[~p] deleting\n", [self()]),
      exit(quit);
    Other ->
      io:format("[~p] received: *** ~p ***\n", [self(), Other]),
      idle()
  end.

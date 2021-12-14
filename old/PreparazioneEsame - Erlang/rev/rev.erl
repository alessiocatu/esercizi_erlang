-module(rev).
-export([start/0, create/0, process/2, long_reversed_string/1]).

start() ->
  register(master, spawn(?MODULE, create, [])).

create() ->
  process_flag(trap_exit, true),
  io:format("Created master process on :- ~p~n", [self()]),
  wait([]).

wait(Rev) ->
  io:format("Im the master handler and im waiting a msg....~n"),
  io:format("Rev :- ~p~n", [Rev]),
  receive
    {add, S, N} ->
      io:format("Received the reversed ~pth slice of string :- ~p~n", [N, S]),
      wait([{N, S}|Rev]);
    {calc} ->
      io:format("Received the calc command ~n"),
      Conc = lists:foldr(fun(Value, Acc) -> Acc ++ element(2, Value) end, [], lists:reverse(Rev)),
      io:format("List sorted :- ~p~n", [Conc]),
      wait([]);
    {'EXIT', Pid, _} -> io:format("[~p] <- Has finish to process a part of string", [Pid]);
    Other -> io:format("Received other :- ~p~n", [Other]), wait(Rev)
  end.

process(S, N) ->
  io:format("Sending the reversed ~pth slice of string :- ~p~n", [N, S]),
  master!{add,lists:reverse(S), N},
  io:format("Im dying ~p~n", [self()]),
  exit(normal).

long_reversed_string(S) ->
  io:format("Start reversing input string~n"),
  long_reversed_string(S, 0).

long_reversed_string([], _) ->
    io:format("Input string has finish, sent calc command to the server~n"),
    master ! {calc};
long_reversed_string(S, N) when length(S) < 10 ->
  io:format("Reversing last part of the input string :- ~p~n", [S]),
  Sub = string:slice(S, 0, length(S)),
  spawn_link(?MODULE, process, [Sub, N]),
  long_reversed_string(string:slice(S,9), N+1);
long_reversed_string(S, N) ->
  io:format("Reversing ~pth part of the input string :- ~p~n", [N,S]),
  Sub = string:slice(S, 0, 9),
  spawn_link(?MODULE, process, [Sub, N]),
  long_reversed_string(string:slice(S,9), N+1).

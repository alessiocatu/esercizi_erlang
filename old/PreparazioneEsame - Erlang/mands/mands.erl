-module(mands).
-export([start/1, create_m/1, waits/0, to_slave/2]).

start(N) ->
  register(master, spawn(?MODULE, create_m, [N])).

create_m(N) ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, waits, []),
  master ! {add_nodes, Pid},
  create(N-1),
  waitm(#{},0).

create(1) ->
  Pid = spawn_link(?MODULE, waits, []),
  master ! {add_nodes, Pid};
create(N) ->
  Pid = spawn_link(?MODULE, waits, []),
  master ! {add_nodes, Pid},
  create(N-1).

waitm(Map, N) ->
  io:format("Handler msgs del master :- ~p~n", [whereis(master)]),
  receive
    {add_nodes, Pid} ->
      io:format("Added to master map this node ~p at ~p position~n", [Pid, N+1]),
      waitm(maps:put(N+1, Pid, Map), N+1);
    {msg, Msg, Node} ->
      case Node =< N of
        true ->
          Pid = maps:get(Node, Map),
          io:format("Received from ~p this message: ~p~n", [Pid, Msg]),
          Pid ! {msg, Msg, Node},
          waitm(Map, N);
        false ->
          io:format("This Pid number doesn't exists"),
          waitm(Map, N)
      end;
    {die, Node} ->
      case Node =< N of
        true ->
          Pid = maps:get(Node, Map),
          io:format("Received from ~p this message: ~p~n", [Pid, die]),
          Pid ! {die, Node},
          waitm(Map, N);
        false ->
          io:format("This Pid number doesn't exists"),
          waitm(Map, N)
      end;
    {'EXIT', Pid, Why} -> io:format("[~p] <- is death cus ~p~n", [Pid, Why]), create(1), waitm(Map, N);
    Other ->
      io:format("Other msgs was receive :- ~p~n", [Other]),
      waitm(Map, N)
  end.

waits() ->
  io:format("Handler msgs on :- ~p~n", [self()]),
  receive
    {msg, Msg, N} -> io:format("[~p] Msg from master :- ~p~n", [N, Msg]), waits();
    {die, N} -> io:format("Oh shit, im the ~pth node and im dying~n", [N]), exit(kill);
    Other -> io:format("[~p] Other msgs was receive :- ~p~n", [self(), Other]), waits()
  end.

to_slave(die, Node) ->
  master ! {die, Node};
to_slave(Msg, Node) ->
  master ! {msg, Msg, Node}.

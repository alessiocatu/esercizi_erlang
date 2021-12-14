-module(hebrew).
-export([init/3, create/5]).

init(Joseph, Hebrows, Hops) ->
  %io:format("initd [~p] -> Joseph ~p\n", [self(), Joseph]),
  process_flag(trap_exit, true),
  Next = spawn_link(hebrew, create, [Joseph, self(), Hebrows, 2, Hops]),
  idle(Joseph, Next, 1).

create(Joseph, Pid, M, M, Hops) ->
  %io:format("[~p] created last [~p]\n", [self(), M]),
  process_flag(trap_exit, true),
  Pid ! {process, Hops, 1},
  idle(Joseph, Pid, M);

create(Joseph, Pid, Hebrows, N, Hops) ->
  %io:format("[~p] created [~p]\n", [self(), N]),
  process_flag(trap_exit, true),
  Next = spawn_link(hebrew, create, [Joseph, Pid, Hebrows, N+1, Hops]),
  idle(Joseph, Next, N).

idle(Joseph, Next, N) ->
  io:format("[~p] [~p] idle -> Next[~p]\n", [self(), N, Next]),
  receive
    {process, M, M} ->
      io:format("[~p] [~p] Received process msg to delete\n", [self(), N]),
      exit({normal, [Next,M]});
    {process, Hops, Pos} ->
      io:format("[~p] [~p] Received process msg skip [~p]\n", [self(), N, Pos]),
      case erlang:is_process_alive(Next) of
        true ->
          io:format("[~p] [~p] Sending msg to [~p]\n", [self(), N, Next]),
          Next ! {process, Hops, Pos+1}, idle(Joseph, Next, N);
        false ->
          io:format("[~p] [~p] End msg to [~p]\n", [self(), N, Joseph]),
          Joseph ! {alive, N}
      end;
    {'EXIT', _, {_normal, [W,Hops]}} ->
      io:format("[~p] [~p] Received exit msg [~p]\n", [self(), N, W]),
      case (W == self()) of
        true ->  io:format("[~p] true -> [~p]\n", [self(), Next]), idle(Joseph, Next, N);
        false -> io:format("[~p] false -> [~p]\n", [self(), W]), W ! {process, Hops, 1}, idle(Joseph, W, N)
      end;
    Other -> io:format("Message error -> ~p\n", [Other])
  end.

-module(ring).
-export([start/1, wait/0]).

%N = Process
%M = #Messages
%Msg = Msg sent M times
start(N) ->
  %register(fst_node, spawn(?MODULE, wait(), [])),
  register(fst_node, spawn(fun() -> wait() end)),
  io:format("Im the first -> ~p <- with this PID=~p~n", [fst_node,whereis(fst_node)]),
  Nodes = create(N),
  io:format("All nodes are created and alive -> ~p~n", [Nodes]),
  send_msg(Nodes),
  receive
      after 1 ->
        io:format("Its time to quit~n"),
        fst_node ! {quit, Nodes, Nodes}
  end.

create( 0 ) -> [];
create( N ) -> [ spawn(fun() -> wait() end) | create( N-1 ) ].

send_msg(Nodes) ->
  io:format("Start sending first msg~n"),
  fst_node ! {msg, Nodes, Nodes}.

wait() ->
  io:format("Im ~p process and im waiting some msgs~n", [self()]),
  receive
    {msg, [HD|TL], Nodes} ->
      io:format("Im ~p and i received ~p message~n", [self(), msg]),
      io:format("Im ~p and i start sending ~p message to ~p~n", [self(), msg, HD]),
      io:format("Check if ~p process is alive: ~p~n", [HD, erlang:is_process_alive(HD)]),
      HD ! {msg, TL, Nodes},
      wait();
    {msg, [], Nodes} ->
      io:format("Im ~p and i received ~p message~n", [self(), msg]),
      io:format("Im ~p and i start sending ~p message to the first node called ~p~n", [self(), msg, fst_node]),
      %io:format("Check if ~p process is alive: ~p~n", [fst_node, erlang:is_process_alive(fst_node)]),
      send_msg(Nodes),
      wait();
    {quit, [HD|[]], [H|T]} ->
      io:format("Im quitting ~p as last process~n", [HD]),
      exit(HD, normal),
      H!{quit, [], T};
    {quit, [], [H|T]} ->
      io:format("Im quitting ~p as process~n", [H]),
      exit(H, normal),
      H!{quit, [], T};
    {quit, [HD|TL], Nodes} ->
      io:format("Im propagate quit msg from ~p process~n", [self()]),
      HD ! {quit, TL, Nodes},
      wait()
  end.

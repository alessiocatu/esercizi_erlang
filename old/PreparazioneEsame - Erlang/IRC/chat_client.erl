-module(chat_client).
-export([start/1, connect/5]).

start(Nick) ->  connect("localhost", 2223, "AsDT67aQ", "general", Nick).

connect(Host, Port, Passw, Group, Nick) ->
  spawn(fun() -> handler(Host, Port, Passw, Group, Nick) end).

handler(Host, Port, Passw, Group, Nick) ->
  process_flag(trap_exit, true),
  start_connector(Host, Port, Passw),
  disconnected(Group, Nick).

disconnected(Group, Nick) ->
  receive
    {connected, MM} ->
      io:format("connected to server~nsending data~n"),
      lib_chan_mm:send(MM, {login, Group, Nick}),
      wait_login_response(MM);
    {status, S} ->
      io:format("~p~n", [S]),
      disconnected(Group, Nick);
    Other ->
      io:format("chat_client disconnected unexpected: ~p~n", [Other]),
      disconnected(Group, Nick)
  end.

start_connector(Host, Port, Passw) ->
  S = self(),
  spawn_link(fun() -> try_to_connect(S, Host, Port, Passw) end).

try_to_connect(Parent, Host, Port, Passw) ->
  case lib_chan:connect(Host, Port, chat, Passw, []) of
    {error, _Why } ->
      Parent ! {status, {cannot, connect, Host, Passw}},
      sleep(2000),
      try_to_connect(Parent, Host, Port, Passw);
    {ok, MM} ->
      lib_chan_mm:controller(MM, Parent),
      Parent ! {connected, MM},
      exit(connectorFinished)
  end.

sleep(T) -> receive after T -> true end.

wait_login_response(MM) ->
  receive
    {chan, MM, ack} -> active(MM);
    {'EXIT', _Pid, connectorFinished} -> wait_login_response(MM);
    Other ->
      io:format("chat_client login unexpected: ~p~n", [Other]),
      wait_login_response(MM)
  end.

active(MM) ->
  receive
    {msg, Nick, Str} ->
      lib_chan_mm:send(MM, {relay, Nick, Str}),
      active(MM);
    {cham, MM, {msg, From, Pid, Str}} ->
      io:format("~p@~p: ~p~n", [From, Pid, Str]),
      active(MM);
    {close, MM} -> exit(serverDied);
    Other ->
      io:format("chat_client active unexpected: ~p~n", [Other]),
      active(MM)
  end.

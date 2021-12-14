-module(joseph).
-export([joseph/2, idle/0]).

joseph(Hebrows,Hops) ->
  io:format("[~p] In a circle of ~p people, killing number ~p\n", [self(), Hebrows, Hops]),
  Joseph = self(),
  spawn (hebrew, init, [Joseph, Hebrows, Hops]),
  idle().

idle() ->
  receive
    {alive, Pos} ->
      io:format("Joseph is the Hebrew in position ~p", [Pos]),
      exit(quit);
    Other -> io:format("Messaggio non chiaro: ~p", [Other]), idle()
  end.

-module(store).
-export([start/0, store/2, lookup/1, wait/0]).

%Design a distributed version of an associative store
%in which values are associated with tags.
%It is possible to store a tag/value pair, and to look up the value(s)
%associated with a tag. One example for this is an address book for email,
%in which email addresses (values) are associated with nicknames (tags).

%Replicate the store across two nodes on the same host,
%send lookups to one of the nodes (chosen either at random or alternately),
%and send updates to both.

%Reimplement your system with the store nodes on other hosts
%(from each other and from the frontend).
%What do you have to be careful about when you do this?

%How could you reimplement the system to include three or four store nodes?

%Design a system to test your answer to this exercise.
%This should generate random store and lookup requests.
start() ->
  register(master, spawn(?MODULE, wait, [])).

store(Key, Value) ->
  master ! {store, Key, Value}.

lookup(Key) ->
  master ! {lp, Key}.

wait() ->
  receive
    {store, Key, Value} -> put(Key, Value), wait();
    {lp, Key} -> io:format("Elem at [key:~p] is ~p~n", [Key, get(Key)]), wait();
    Other -> io:format("Other -> ~p~n", [Other]), wait()
  end.

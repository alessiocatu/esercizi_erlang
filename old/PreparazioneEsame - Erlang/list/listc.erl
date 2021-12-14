-module(listc).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

%squared_int that removes all non-integers from a polymorphic list
%and returns the resulting list of integers squared, e.g.,
%squared_int([1, hello, 100, boo, “boo”, 9]) should return [1, 10000, 81].
squared_int(LST) ->
  lists:filter(fun(X) -> is_integer(X) end, LST).

%intersect that given two lists, returns a new list that is the intersection
%of the two lists (e.g., intersect([1,2,3,4,5], [4,5,6,7,8]) should return [4,5]).
intersect(A, B) ->
  lists:filter(fun(X) -> lists:member(X, B) end, A).

%symmetric_difference that given two lists, returns a new list that is the
%symmetric difference of the two lists. For example symmetric_difference([1,2,3,4,5],
% [4,5,6,7,8]) should return [1,2,3,6,7,8].
symmetric_difference(A, B) ->
  (A--intersect(A,B)) ++ (B--intersect(A,B)).

%listc:symmetric_difference([1,2,3,4,5], [4,5,6,7,8]).

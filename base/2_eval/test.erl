-module(test).
-export([eval/0]).

eval() -> eval:eval("{minus, {plus, {num, 2}, {num,3}}").

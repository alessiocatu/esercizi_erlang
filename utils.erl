-module(utils).

% Effettuare chiamate su server
rpc:call(Nodo, Modulo, Metodo, [Parametri]).

% Effettuare ping per sync tra nodi
net_adm:ping(Nodo).

% Settare il group_leader dove verrà scritto il io:format
% whereis(user) <- standard
% self() <- Pid del processo su cui verrà scritto
group_leader(whereis(user), self()),

% Thunks
from(K) -> [K | fun() -> from(K+1) end].

% Spawn con la registrazione contemporanea
register(master, spawn(?MODULE, wait, [])).

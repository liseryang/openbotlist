%%----------------------------------------------------------
%% File:   server_lib
%% Descr:  IRC Server library gen_server
%% Author: Berlin Brown
%% Date:   3/2/2008
%%----------------------------------------------------------

-module(functional_test_server).

-include("irc_server.hrl").

-export([functional_test/0]).

functional_test() ->
	io:format("Running functional test~n"),
	Client = #irc_server_info{},
	ServStart = server_lib:start_link(Client),
	case ServStart of
		{ ok, P } ->
			io:format("trace: app:server pid/lib [~p]~n", [P]),
			server_lib:server_listen(P),
			State = server_lib:get_cur_state(P),
			io:format("trace: app:server state [~p]~n", [State]),
			wait_for_messages(State)
	end,
	io:format("Done~n").

%%
%% Parm:Client - ServState
wait_for_messages(ServState) ->
    receive		
        Else ->
            io:format("trace: app: wait_messages:else <incoming>~n"),
            wait_for_messages(ServState)
    after connection_timeout() + 10000 ->
            io:format("INFO: Timed out")
    end.

connection_timeout() ->
    % 1 minute
    60000.

%% End of File
	

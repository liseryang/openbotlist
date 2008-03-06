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
	% Ensure that the app_handler is associcated with this app process
	Client = #irc_server_info{app_handler=self()},
	ServStart = server_lib:start_link(Client),
	case ServStart of
		{ ok, P } ->
			io:format("trace: app:server pid/lib [~p]~n", [P]),
			server_lib:server_listen(P),
			State = server_lib:get_cur_state(P),
			io:format("trace: app:server state [~p]~n", [State]),
			% Launch initial accept clients block
			server_lib:server_accept_call(P),
			wait_for_clients(State)
	end,
	io:format("Done~n").

%%
%% Parm:Client - ServState
wait_for_clients(ServState) ->
	Handler = self(),
	io:format("trace: app: wait_for_clients~n"),
    receive		
        { ready_accept } ->
			% Application process is ready to accept new clients
            io:format("trace: app: wait_messages:accept <incoming>~n"),
            wait_for_clients(ServState);
		Error ->
			io:format("trace: [!] app:error.wait_for_clients <idle>: ~p~n", [Error]),
			Handler ! { ready_accept }
    after connection_timeout() + 20000 ->
            io:format("INFO: Timed out")
    end.

connection_timeout() ->
    % 1 minute
    60000.

%% End of File
	

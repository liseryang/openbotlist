%% irc_server.hrl
%%
-record(irc_server_info, {port=6667, app_handler=undefined}).
-record(server_state, {serv_sock, client, state, 
					   connection_timeout, app_handler=undefined}).

%% irc_server.hrl
%%
-record(irc_server_info, {port=6667}).
-record(server_state, {serv_sock, client, state, 
					   connection_timeout, app_handler=undefined}).

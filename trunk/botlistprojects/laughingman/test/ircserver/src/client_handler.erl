%%----------------------------------------------------------
%% File:   server_lib
%% Descr:  IRC Server library gen_server
%% Author: Berlin Brown
%% Date:   3/2/2008
%%
%% Additional Resources:
%% http://www.erlang.org/doc/man/gen_tcp.html
%%----------------------------------------------------------

-module(client_handler).

-include("irc_server.hrl").

-behaviour(gen_server).

-export([start_link/1, get_cur_state/1]).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(Client) ->
    gen_server:start_link(?MODULE, [Client], []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%%
%% Description: Initiates the server
%% Whenever a gen_server is started using gen_server:start/3,4 
%% or gen_server:start_link/3,4, this function is called by the new process to initialize. 
%%--------------------------------------------------------------------
init([Client]) ->
	io:format("trace: client_handler:init~n"),
	AppHandler = undefined,
	{ok, #server_state{app_handler=AppHandler,
					   connection_timeout=undefined,
					   client=Client,
					   state=starting}}.

%%--------------------------------------------------------------------
%% From = is a tuple {Pid, Tag} where Pid is the 
%%        pid of the client and Tag is a unique tag. 
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(get_cur_state, _From, #server_state{} = State) ->
	% Generic method to get the current state.
	io:format("trace: lib:handle_call:get_cur_state~n"),
	{reply, {ok, State}, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, #server_state{client=Client}) ->
    io:format("trace: client:handler:terminate reason:[~p]~n", [_Reason]),
    ok;
terminate(shutdown, #server_state{client=Client}) ->
    io:format("trace: client:handler:terminate.shutdown~n"),
    ok.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({tcp, Sock, Data}, State) ->	
    inet:setopts(Sock, [{active, once}]),
	io:format("trace: lib:info.tcp data [~p]~n", [Data]),
    {noreply, State};
handle_info({tcp_closed, Sock}, State) ->
	io:format("trace: lib:info.tcp_closed~n"),
    {noreply, State#server_state{state=disconn}};
handle_info({tcp_error, Sock, Reason}, State) ->
	io:format("trace: lib:info.tcp_error~n"),
    inet:setopts(Sock, [{active, once}]),
    {noreply, State#server_state{state=disconn}}.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

get_cur_state(ServLib) ->
	io:format("trace: lib:get_cur_state: pid:[~p] ~n", [ServLib]),
	% Return: {ok, State}
	gen_server:call(ServLib, get_cur_state).

%% End of File
